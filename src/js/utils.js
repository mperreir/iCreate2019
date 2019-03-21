const sleep = m => new Promise(r => setTimeout(r, m));

function createLocalModels(models3D){
	var geometry = new THREE.BoxGeometry(1, 1, 1);
	var material = new THREE.MeshBasicMaterial({color: color.orange});
	var cube = new THREE.Mesh(geometry, material);
	models3D.little_house = cube;
}

async function loadEveryModels(paths, models3D){
	var loader = new THREE.GLTFLoader();
	var loader_count = 0;

	for(p in paths){
		loader_count++;
		let model = p;
		loader.load(
			paths[model].url,
			function(res){
				let geometry = res.scenes[0];

				while(geometry.hasOwnProperty('children') && geometry.children.length > 0 && paths[model].seekChild){
					if(geometry.name == paths[model].seekChild) paths[model].seekChild = false;
					geometry = geometry.children[0];
				}

				if(paths[model].texture){
					let texture = new THREE.TextureLoader().load(paths[model].texture);
					texture.encoding = THREE.sRGBEncoding;
					texture.flipY = false;
					let material = new THREE.MeshBasicMaterial({map: texture});
					geometry.material = material;
				}

				geometry.scale.set(1,1,1);
				updateInformation(geometry);
				models3D[model] = geometry;
				loader_count--;
			}
		);
	}

	while(loader_count != 0)	await sleep(50);
	//console.log(models3D);
}

function updateInformation(geometry) {
	let box = new THREE.Box3().setFromObject(geometry);
	geometry.userData.width = Math.abs(box.min.x) + box.max.x;
	geometry.userData.length = Math.abs(box.min.z) + box.max.z;
	geometry.userData.surface = geometry.userData.width * geometry.userData.length;
}

function getHugestObject(arrayObjects){
	arrayObjects.forEach((e)=>updateInformation(e));
	return arrayObjects.reduce((acc, cur) => (acc.userData.surface < cur.userData.surface) ? cur : acc);
}
