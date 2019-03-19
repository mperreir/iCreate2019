// --- cleaning console --- //
console.clear();

// --- threeJS --- //
var renderer, scene, camera, distance, raycaster, projector;

var container = document.getElementById('container');
var raycaster = new THREE.Raycaster(),INTERSECTED;
var mouse = new THREE.Vector2();
var distance = 400;

// -- basic initialization -- //
function init() {
	renderer = new THREE.WebGLRenderer({
		antialias: true
	});
	renderer.setSize(window.innerWidth, window.innerHeight);
	renderer.setClearColor(0x140b33, 1);
	container.appendChild(renderer.domElement);

	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 0.2, 25000);
	camera.position.set(100, 100, 2000);
	scene.add(camera);

	light = new THREE.PointLight(0xffffff, 1, 4000);
	light.position.set(50, 0, 0);
	light_two = new THREE.PointLight(0xffffff, 1, 4000);
	light_two.position.set(-100, 800, 800);
	lightAmbient = new THREE.AmbientLight(0x404040);
	scene.add(light, light_two, lightAmbient);

	createSpheres();

	renderer.render(scene, camera);

	document.addEventListener('mousemove', onMouseMove, false);
	window.addEventListener('resize', onWindowResize, false);
}

// -- spheres -- //
function createSpheres() {

	spheres = new THREE.Object3D();

	for (var i = 0; i < 80; i++) {
		var sphere = new THREE.SphereGeometry(4, Math.random() * 12, Math.random() * 12);
		var material = new THREE.MeshPhongMaterial({
			color: Math.random() * 0xff00000 - 0xff00000,
			shading: THREE.FlatShading,
		});

		var particle = new THREE.Mesh(sphere, material);
		particle.position.x = Math.random() * distance * 10;
		particle.position.y = Math.random() * -distance * 6;
		particle.position.z = Math.random() * distance * 4;
		particle.rotation.y = Math.random() * 2 * Math.PI;
		particle.scale.x = particle.scale.y = particle.scale.z = Math.random() * 12 + 5;
		spheres.add(particle);
	};

	spheres.position.y = 500;
	spheres.position.x = -2000;
	spheres.position.z = -100;
	spheres.rotation.y = Math.PI * 600;

	scene.add(spheres);
};


// -- events -- //
function onMouseMove(event) {
	mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
	mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
	mouseX = event.clientX - window.innerWidth / 2;
	mouseY = event.clientY - window.innerHeight / 2;
	camera.position.x += (mouseX - camera.position.x) * 0.01;
	camera.position.y += (mouseY - camera.position.y) * 0.01;
	camera.lookAt(scene.position);
};

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	renderer.setSize(window.innerWidth, window.innerHeight);
	camera.updateProjectionMatrix();
};

// ---- //
function animate() {
	requestAnimationFrame(animate);
	render();
};

// -- render all -- //
function render() {
	renderer.render(scene, camera);
};

// -- run functions -- //
init();
animate();
