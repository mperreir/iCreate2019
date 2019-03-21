const sleep = m => new Promise(r => setTimeout(r, m));

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
					let material = new THREE.MeshBasicMaterial({map: texture});
					geometry.material = material;
				}
				geometry.scale.set(1,1,1);
				models3D[model] = geometry;
				loader_count--;
			}
		);
	}

	while(loader_count != 0)	await sleep(50);
	console.log(models3D);
}
