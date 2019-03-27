const sleep = m => new Promise(r => setTimeout(r, m));

function createLocalModels(models3D){
	var textureLoader = new THREE.TextureLoader();
	let loader = new THREE.TextureLoader();

	var geometry = new THREE.BoxGeometry(2, 3, 2);

	var material = new THREE.MeshLambertMaterial({color: color.darkblue});
	var cube = new THREE.Mesh(geometry, material);
	models3D.little_house = cube;


	geometry = new THREE.BoxGeometry(2, 3, 3);
	material = new THREE.MeshLambertMaterial({color: color.red});
	cube = new THREE.Mesh(geometry, material);
	models3D.house2 = cube;



// creates the cube by mixing the geometry and materials
	geometry = new THREE.BoxGeometry(2, 4, 6);
	material = new THREE.MeshLambertMaterial({color: color.grey2});
	cube = new THREE.Mesh(geometry, material);
	models3D.building = cube;

	let textureImmeublePorte =loader.load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/Immeuble_porte.png");
	let textureImmeubleSansPorte =loader.load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/Immeuble_sansporte.png");
	textureImmeubleSansPorte.magFilter = THREE.LinearFilter;
	textureImmeubleSansPorte.anisotropy = renderer.getMaxAnisotropy();
	textureImmeublePorte.magFilter = THREE.LinearFilter;
	textureImmeublePorte.anisotropy = renderer.getMaxAnisotropy();

	let materialArray = [
	    new THREE.MeshBasicMaterial( { map: textureImmeublePorte,transparent: true, } ),
	    new THREE.MeshBasicMaterial( { map: textureImmeublePorte ,transparent: true,} ),
	    new THREE.MeshBasicMaterial( {color: 0xAEAEAE } ),
	    new THREE.MeshBasicMaterial( { color: 0xAEAEAE} ),
	    new THREE.MeshBasicMaterial( { map: textureImmeubleSansPorte,transparent: true, } ),
	    new THREE.MeshBasicMaterial( { map:textureImmeubleSansPorte,transparent: true,  } ),
	];

	geometry = new THREE.BoxGeometry(3.5, 10,3.5);
	cube = new THREE.Mesh(geometry, materialArray);
	//cube.position.y -= 10;
	models3D.skyscraper = cube;
	models3D.skyscraper.position.y+=5;

	let textureMaisonPorte =loader.load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/Maison_porte.png");
	let textureMaisonSansPorte =loader.load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/Maison_sansporte.png");
	textureMaisonSansPorte.magFilter = THREE.LinearFilter;
	textureMaisonSansPorte.anisotropy = renderer.getMaxAnisotropy();
	textureMaisonPorte.magFilter = THREE.LinearFilter;
	textureMaisonPorte.anisotropy = renderer.getMaxAnisotropy();

	materialArray = [
			new THREE.MeshBasicMaterial( { map: textureMaisonPorte,transparent: true, } ),
			new THREE.MeshBasicMaterial( { map: textureMaisonPorte ,transparent: true,} ),
			new THREE.MeshBasicMaterial( {color: 0x855223 } ),
			new THREE.MeshBasicMaterial( { color: 0x855223} ),
			new THREE.MeshBasicMaterial( { map: textureMaisonSansPorte,transparent: true, } ),
			new THREE.MeshBasicMaterial( { map:textureMaisonSansPorte,transparent: true,  } ),
	];

	geometry = new THREE.BoxGeometry(4, 3, 4);
	cube = new THREE.Mesh(geometry, materialArray);
	models3D.building2 = cube;
	models3D.building2.position.y += 3;

}

async function loadEveryModels(paths, models3D){
	createLocalModels(models3D);
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
	for(e in models3D) {
		models3D[e].userData.name = e;
		models3D[e].castShadow = true;
    models3D[e].receiveShadow = true;
	}
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
