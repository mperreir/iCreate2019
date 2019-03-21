let renderer, scene, camera, projector;
let models3D = {};

let container = document.getElementById('container');
let raycaster = new THREE.Raycaster(),INTERSECTED;
let mouse = new THREE.Vector2();
var rotationCamera = -0.45;

async function init() {
	renderer = new THREE.WebGLRenderer({antialias: true});
	renderer.setSize(window.innerWidth, window.innerHeight);
	renderer.setClearColor(color.blue, 1);
	renderer.gammaOutput = true;
	renderer.gammaFactor = 2.2;
	container.appendChild(renderer.domElement);

	// Scene, lightning and camera organisation
	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(0, 200, 50);

	camera.rotation.x = rotationCamera * Math.PI;
	scene.add(camera);
	// TODO: Revoir les parametres des lumiéres
	light = new THREE.PointLight(0xffffff, 1, 4000);
	light.position.set(1000, 0, 0);
	light_two = new THREE.PointLight(0xffffff, 1, 4000);
	light_two.position.set(-100, 800, 800);
	lightAmbient = new THREE.AmbientLight(0x404040);
	scene.add(light, light_two, lightAmbient);
	await createMap()
	// Initial map

	// Loading every models
	await loadEveryModels(models_paths, models3D);
	//treeMap(scene, models3D);
	//houseMap(scene, models3D);
	randomMap(scene, models3D);

	renderer.render(scene, camera);
	//document.addEventListener('mousemove', onMouseMove, false);
	animate();
	await sleep(10000);
	await moveCamera(0,3,150,0,50,100);
}
async function createMap(){
	texture = new THREE.TextureLoader().load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture.jpg");

// how many times to repeat in each direction; the default is (1,1),
//   which is probably why your example wasn't working

	material = new THREE.MeshBasicMaterial( { map: texture} );

	plane = new THREE.Mesh(new THREE.PlaneGeometry(400, 400), material);
	plane.material.side = THREE.DoubleSide;
	plane.position.x = 10;
	//plane.position.y = -40;
	plane.position.z = -30;

	plane.rotation.x = 0.5 * Math.PI;
	scene.add(plane);

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

function animate() {
	requestAnimationFrame(animate);
	renderer.render(scene, camera);
};

init();
