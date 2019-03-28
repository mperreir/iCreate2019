let renderer, scene, camera, projector, state, glitch_renderer, active_renderer, saturation_renderer;
let models3D = {};
let sound2;

let div = document.getElementById('container');
let mouse = new THREE.Vector2();
let rotationCamera = -0.45;

let local_state = -1;
let global_state = 0; // For the tests
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
	div.appendChild(renderer.domElement);

	// Scene, lightning and camera organisation
	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(0, 200, 50);
	camera.rotation.x = rotationCamera * Math.PI;
	scene.add(camera);
	makeLight();
	makeSky();
	await createMap();
	renderer.render(scene, camera);
	// Postproduction
	setShaders();

	// Starting the game
	animate();
	await loadEveryModels(models_paths, models3D);
	startGame();

	await sleep(10000);
	console.log("etat 2");
	global_state++;
	await sleep(5000);
	global_state++;
}

async function startGame(event){

	let temp_state = getState();


	if(temp_state !== local_state){
		//await moveCamera(0,10,50,-0.05,20,100);

		switch(temp_state) {
			case 0:
				console.log("etat 1")
				updateDate(1500,5);
				setTimeout(()=>{document.getElementById('logo').style.opacity = 0}, 3000);

				await treeMap(scene, models3D);
				break;
			case 1:
				console.log("etat 1 1 1")
				sound.stop();
				sound = new Howl({
				src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/1850.mp3"],
				volume: 0.9,
				loop : true
				});
				sound.play();

				removeMap(scene, models3D);
				break;
			case 2:
				updateDate(2019,15);
				sound.stop();
				sound = new Howl({
				src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/1950.mp3"],
				volume: 0.9,
				loop : true
				});
				sound.play();

				await cityMap(scene, models3D);
				//await moveCamera(0,10,50,-0.1,20,100);
				document.addEventListener('keypress', interactionEvent);
				document.getElementById('personnes').style.opacity = 1;
				document.getElementById('people').style.opacity = 1;

				await sleep(4000);
				document.getElementById('housePopulation').style.fontSize = '3em';
				await sleep(3000);
				document.getElementById('housePopulation').style.fontSize = '0em';
				let old_population = 0;
				let grow_speed = 1;
				while(population_ajoute < 150){
					population += Math.round(Math.random() * grow_speed);
					(population_ajoute + population < 10) ? updatePopulation(true) : updatePopulation();
					(population_ajoute + population < 10) ? grow_speed = 1 : grow_speed = 5;
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
				global_state++;
				break;
			case 3:
				active_renderer = glitch_renderer;
				//await moveCamera(0,10,50,-0.15,20,100);
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
		return reponse.json()
	}).then(function(json){
		console.log(json["Etat"])
	})
}

function interactionEvent(event){
	if(population > 0){
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
	console.log(detail);
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
		saturation_renderer.passes[1].uniforms.saturation.value -= 0.01
		await sleep(20);
	};
}

let tempGlitch = async (temp) => {
	active_renderer = glitch_renderer;
	await sleep(temp);
	active_renderer = saturation_renderer;
}
