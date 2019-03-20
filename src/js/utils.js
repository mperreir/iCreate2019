const sleep = m => new Promise(r => setTimeout(r, m));

async function loadEveryModels(paths, models3D){
	var loader = new THREE.GLTFLoader();
	var loader_count = 0;

	for(p in paths){
		loader_count++;
		loader.load(
			paths[p],
			function(res){
				console.log(res);
				models3D[p] = res.scene.children[0];
				loader_count--;
			}
		);
	}

	while(loader_count != 0)	await sleep(50);
	console.log(models3D);
}
