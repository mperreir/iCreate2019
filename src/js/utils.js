const sleep = m => new Promise(r => setTimeout(r, m));

async function loadEveryModels(paths, models3D){
	var loader = new THREE.GLTFLoader();
	var loader_count = 0;

	for(p in paths){
		loader_count++;
		loader.load(
			paths[p],
			function(res){
				console.log('Hey')
				console.log(res);
				loader_count--;
				let castleTexture = new THREE.TextureLoader().load(`https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/textures/Material.001_diffuse.png`)
				let castleMaterial = new THREE.MeshBasicMaterial({ map: castleTexture })

				models3D[p] = new THREE.Mesh(res.scenes[0], castleMaterial);

			}
		);
	}

	while(loader_count != 0)	await sleep(50);
	console.log('fin')
	console.log(models3D);
}
