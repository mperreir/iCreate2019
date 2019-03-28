let renderer, scene, camera, projector, state, glitch_renderer, active_renderer, saturation_renderer;
let models3D = {};

let div = document.getElementById('container');
let mouse = new THREE.Vector2();
let rotationCamera = -0.45;

let local_state = -1;
let global_state = 0; // For the tests

const canvas = document.getElementById('canvas');
const context = canvas.getContext('2d');

function animate() {
	requestAnimationFrame(animate);
	active_renderer.render(scene, camera);
};

init();
async function init() {
	loadImage()
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

	// Tests
	await sleep(5000);
	global_state++;
	await sleep(5000);
	global_state++;
	// await sleep(5000);
	// global_state++;
	// await sleep(15000);
	// global_state++;
}

async function startGame(event){
	let temp_state = getState();

	if(temp_state !== local_state){
		switch(temp_state) {
			case 0:
				document.getElementById('logo').style.opacity = 0;
				await treeMap(scene, models3D);
				console.log(saturation_renderer);
				break;
			case 1:
				removeMap(scene, models3D);
				break;
			case 2:
				cityMap(scene, models3D);
				document.addEventListener('keypress', interactionEvent);
				//await sleep(1000);
				//await moveCamera(0,10,50,-0.1,20,100);
				break;
			case 3:
				let diminution_saturation = async () => {
					let saturation = saturation_renderer.passes[1].uniforms.saturation;
					while(saturation.value > 0.1){
						saturation_renderer.passes[1].uniforms.saturation.value -= 0.01
						await sleep(20);
					};
				}
				diminution_saturation();

				let tempGlitch = async (temp) => {
					active_renderer = glitch_renderer;
					await sleep(temp);
					active_renderer = saturation_renderer;
				}

				await sleep(2000);
				tempGlitch(300);
				await sleep(2000);
				tempGlitch(300);
				break;
			case 4:

				break;
		}
		local_state = temp_state;
	}
	setTimeout(startGame, 100);
}

function getState(){
	// TODO: Fontion à relier au serv python
	return global_state;
}

function interactionEvent(event){
	console.log(event.code)
	if(event.code === 'KeyQ'){
		addHouse();
	} else if (event.code === 'KeyB') {
		addBuilding();
	}
}

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	renderer.setSize(window.innerWidth, window.innerHeight);
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
}
