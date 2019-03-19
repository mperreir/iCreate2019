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
	renderer.setClearColor(0x48F9FF, 1);
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
  var geometry = new THREE.PlaneGeometry( 1000, 1000, 2 );
  var material = new THREE.MeshBasicMaterial( {color: 0x54E87A, side: THREE.DoubleSide} );
  var plane = new THREE.Mesh( geometry, material );
  plane.rotation.x = 0.5 * Math.PI;
  scene.add( plane );
	//createSpheres();

	renderer.render(scene, camera);
  let tree_path = 'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/tree.gltf';
	var loader = new THREE.GLTFLoader();
	loader.load(
	   tree_path,
	   function ( gltf ) {
	      var scale = 5.6;
				console.log(gltf.scenes[0]);
				let bus = {};
	      bus.body = gltf.scenes[0];
	      bus.body.name = 'body';
	      bus.body.rotation.set ( 0, -1.5708, 0 );
	      bus.body.scale.set (scale,scale,scale);
	      bus.body.position.set ( 0, 3.6, 0 );
	      bus.body.castShadow = true;
				scene.add( bus.body );
	   },
	);
}

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
