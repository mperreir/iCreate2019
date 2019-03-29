let renderer, scene, camera, projector, state, glitch_renderer, active_renderer, saturation_renderer;
let models3D = {};
let sound2;

let div = document.getElementById('container');
let mouse = new THREE.Vector2();
let rotationCamera = -0.45;

let local_state = -1;
let nbIm = 0;
let nbMa = 0;
let global_state = -1; // For the tests
let population = 0;
let population_ajoute = 0;
let sound;
const canvas = document.getElementById('canvas');
const context = canvas.getContext('2d');

function animate() {
	requestAnimationFrame(animate);
	active_renderer.render(scene, camera);
};

init();

async function init() {
	fetch('http://localhost:5002/reset');

	sound = new Howl({
  src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/init.mp3"],
  volume: 0.5
	});

	sound.play();
	await loadImage()
	renderer = new THREE.WebGLRenderer({antialias: true});
	renderer.setSize(window.innerWidth, window.innerHeight);
	renderer.setClearColor(color.blue, 1);
	renderer.gammaOutput = true;
	renderer.gammaFactor = 2.2;
	renderer.shadowMap.enabled= true;
	active_renderer = renderer;

	// Scene, lightning and camera organisation
	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(0, 200, 50);
	camera.rotation.x = rotationCamera * Math.PI;
	scene.add(camera);
	makeLight();
	makeSky();
	await createMap();
	div.appendChild(renderer.domElement);
	renderer.render(scene, camera);
	// Postproduction
	setShaders();

	document.addEventListener('keypress', interactionEvent);
	animate();
	// Starting the game
	cloudySky();
	await loadEveryModels(models_paths, models3D);
	buildDistricts();
	setTimeout(()=>{document.getElementById('logo').style.opacity = 0}, 4000);
	updateDate(1500,1);
	await treeMap(scene, models3D);
	startGame();

	// await sleep(5000);
	// global_state++;
	// await sleep(5000);
	// global_state++;
	// await sleep(5000);
	// global_state++;
}

async function startGame(event){

	let temp_state = getState();
	let global_speed = 0.001;

	if(temp_state !== local_state){
		//await moveCamera(0,10,50,-0.05,20,100);

		switch(temp_state) {
			case 1:
				updateDate(1900,5);
				await expansionV2(scene, 0, global_speed);
				break;
			case 2:
				sound.stop();
				sound = new Howl({
					src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/1850.mp3"],
					volume: 0.9,
					loop : true
				});
				sound.play();
				updateDate(1950,5);
				await expansionV2(scene, 1, global_speed);
				removeMap(scene, models3D);
				break;
			case 3:
				sound.stop();
				sound = new Howl({
					src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/1950.mp3"],
					volume: 0.9,
					loop : true
				});
				sound.play();
				updateDate(1999,5);
				await expansionV2(scene, 2, global_speed);
				//await moveCamera(0,10,50,-0.1,20,100);
				break;
			case 4:
				updateDate(2019,5);
				await moveCamera(0,50,130,-0.17,20,100);

				await expansionV2(scene, 3, global_speed);
				await sleep(4000);
				document.getElementById('housePopulation').style.fontSize = '3em';
				await sleep(3000);
				document.getElementById('housePopulation').style.fontSize = '0em';
				document.getElementById('personnes').style.opacity = 1;
				document.getElementById('people').style.opacity = 1;
				let old_population = 0;
				let grow_speed = 1;

					let actualisationState = async () => {
						while(true){
							getState();
							await sleep(100);
						};
					}

					actualisationState();

				while(population_ajoute < 150){
					population += Math.round(Math.random() * grow_speed);
					(population_ajoute + population < 10) ? updatePopulation(true) : updatePopulation();
					(population_ajoute + population < 10) ? grow_speed = 1 : grow_speed = 10;
					await sleep(1000);
					if(old_population < 50 && population_ajoute > 50) tempGlitch(300);
					if(old_population < 80 && population_ajoute > 80) tempGlitch(300);
					if(old_population < 100 && population_ajoute > 100){
						tempGlitch(300);
						diminutionSaturation();
					}
					if(old_population < 120 && population_ajoute > 120) tempGlitch(300);
					old_population = population_ajoute;
				};
				active_renderer = glitch_renderer;
				setTimeout(()=>{document.getElementById('outro').style.opacity = 1}, 5000);
				break;
		}
		local_state = temp_state;
	}
	setTimeout(startGame, 100);
}

function getState(){
	// TODO: Fontion à relier au serv python
	//127.0.0.1:5002/data
	const url='http://localhost:5002/data';
	fetch(url).then(function(reponse){
		console.log(reponse)
		return reponse.json()
	}).then(function(json){
		console.log(json)
		global_state = json["Etat"];
		if(global_state == 3 && json["NbMaisons"] != nbMa){
			addHouse();
			population -= 2;
			population_ajoute += 2;
			updatePopulation();
		}
		if(global_state == 3 && json["NbImmeubles"] != nbMa){
			addBuilding();
			population -= 10;
			population_ajoute += 10;
			updatePopulation();
		}
		nbIm = json["NbImmeubles"];
		nbMa = json["NbMaisons"];
	})
	return global_state;
}

function interactionEvent(event){
	console.log(event.code)
	if(population > 0 || true){
		if(event.code === 'KeyQ'){
			addHouse();
			population -= 2;
			population_ajoute += 2;
		} else if (event.code === 'KeyB') {
			addBuilding();
			population -= 10;
			population_ajoute += 10;
		}
		if(population < 0) population = 0;
		updatePopulation();
	}
}

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	active_renderer.setSize(window.innerWidth, window.innerHeight);
	camera.updateProjectionMatrix();
};

function onMouseMove(event) {
	mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
	mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
	mouseX = event.clientX - window.innerWidth / 2;
	mouseY = event.clientY - window.innerHeight / 2;
	camera.position.x += (mouseX - camera.position.x) * 0.001;
	camera.position.y += (mouseY - camera.position.y) * 0.001;
	camera.lookAt(scene.position);
};

async function loadImage(){
	var img = new Image();
	img.onload = function(){
		context.drawImage(img, 0, 0);
	};
	img.src = "https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture_seuil.jpg";
	img.crossOrigin='anonymous';

	var img2 = new Image();
	img2.onload = function(){
		context.drawImage(img2, 400, 0);
	};
	img2.src = "https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture_zones.jpg";
	img2.crossOrigin='anonymous';
}

async function updateDate(limit, delay=10){
	let date = document.getElementById('date');
	let current_date = parseInt(date.textContent);
	while(current_date !== limit){
		current_date++;
		date.textContent = current_date;
		await sleep(delay);
	}
}

async function updatePopulation(detail=false,delay=30){
	let popu = document.getElementById('personnes');
	let current_population = parseInt(popu.textContent);
	if(detail && current_population !== population) document.getElementById('inhabitant').style.fontSize = '2.5em';
	while(current_population !== population){
		if(current_population < population) current_population++;
		else current_population--;
		popu.textContent = current_population;
		await sleep(delay);
	}
	if(detail){
		await sleep(500);
		document.getElementById('inhabitant').style.fontSize = '0em';
	}
}

let diminutionSaturation = async () => {
	let saturation = saturation_renderer.passes[1].uniforms.saturation;
	while(saturation.value > 0.1){
		saturation_renderer.passes[1].uniforms.saturation.value -= 0.01;
		await sleep(20);
	};
}

let tempGlitch = async (temp) => {
	active_renderer = glitch_renderer;
	await sleep(temp);
	active_renderer = saturation_renderer;
}

async function cloudySky(){
	var geometry = new THREE.BoxGeometry(13, 4, 8);
	var material = new THREE.MeshBasicMaterial({color: 0xFFFFFF, transparent:true, opacity:0.8});
	var cube = new THREE.Mesh(geometry, material);
	cloud = cube;
	cloud.position.y = 80;

	let animCloud = async (c) => {
		while (true) {
			if(c.position.x < -300)	c.position.x = 300;
			c.position.x -= 1;
			await sleep(25);
		}
	}

	for(let i = 0; i < 20; i++){
		let new_cloud = await cloud.clone();
		new_cloud.position.x = 300;
		new_cloud.position.z = Math.random() * 150 - 75;
		scene.add(new_cloud);
		animCloud(new_cloud);
		await sleep(Math.random() * 600);
	}
}
