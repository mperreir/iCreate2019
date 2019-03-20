let renderer, scene, camera, projector;
let models3D = {};

let container = document.getElementById('container');
let raycaster = new THREE.Raycaster(),INTERSECTED;
let mouse = new THREE.Vector2();

let color = {
	'blue' : 0x45a8e5,
	'green' : 0x8ec945,
}

let models_paths = {
	'tree':'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/tree/tree.gltf',
	'house':'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/scene.gltf',
};

async function init() {
	renderer = new THREE.WebGLRenderer({antialias: true});
	renderer.setSize(window.innerWidth, window.innerHeight);
	renderer.setClearColor(color.blue, 1);
	container.appendChild(renderer.domElement);

	// Scene, lightning and camera organisation
	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(0, 50, 50);
	camera.rotation.x -= 0.25 * Math.PI;
	scene.add(camera);
	// TODO: Revoir les parametres des lumiéres
	light = new THREE.PointLight(0xffffff, 1, 4000);
	light.position.set(50, 0, 0);
	light_two = new THREE.PointLight(0xffffff, 1, 4000);
	light_two.position.set(-100, 800, 800);
	lightAmbient = new THREE.AmbientLight(0x404040);
	scene.add(light, light_two, lightAmbient);

	// Initial map
  let geometry = new THREE.PlaneGeometry(1000, 1000, 2);
  let material = new THREE.MeshBasicMaterial({color: color.green, side: THREE.DoubleSide});
  let plane = new THREE.Mesh(geometry, material);
  plane.rotation.x = 0.5 * Math.PI;
  scene.add(plane);

	// Loading every models
	await loadEveryModels(models_paths, models3D);
	treeMap(scene, models3D);

	renderer.render(scene, camera);
	document.addEventListener('mousemove', onMouseMove, false);
	animate();
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
