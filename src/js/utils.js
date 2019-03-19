const sleep = m => new Promise(r => setTimeout(r, m));

async function loadEveryModels(paths, models3D){
	var loader = new THREE.GLTFLoader();
	var loader_count = 0;

	for(p in paths){
		loader_count++;
		loader.load(
			paths[p],
			function(res){
				models3D[p] = res.scenes[0];
				loader_count--;
			}
		);
	}

	while(loader_count != 0)	await sleep(50);
}
