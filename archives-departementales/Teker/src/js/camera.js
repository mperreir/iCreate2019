async function animatedRotationCamera(newangle,incr){
	while(rotationCamera!=newangle){
		if (Math.abs(rotationCamera,newangle) <incr*2){
			rotationCamera=newangle;
		}
		if (rotationCamera<newangle){
			rotationCamera+=incr;
		}
		else{
			rotationCamera-=incr;
		}
		camera.rotation.x = rotationCamera * Math.PI;
		await sleep(100);
	}
}
function increment(start,end,incr){
	if (Math.abs(start-end) <incr){
		start=end;
	}
	if (Math.abs(start-end) != 0){
			if(start>end){
				start -= incr;
			}
			else{
				start += incr;
			}
		}
	return start;

}
async function moveCamera(x_end, y_end,z_end,newangle,time,nb_transition){
	let rotationCamera = -0.45;
	var incrx = Math.abs(camera.position.x-x_end) / nb_transition;
	var incry = Math.abs(camera.position.y-y_end)/ nb_transition;
	var incrz = Math.abs(camera.position.z-z_end) / nb_transition;
	var incrangle = Math.abs(rotationCamera-newangle)/ nb_transition;
	while(Math.abs(camera.position.x-x_end) != 0 || Math.abs(camera.position.y-y_end) != 0 || Math.abs(camera.position.z-z_end) != 0  ||Math.abs(rotationCamera-newangle) != 0 ){
		camera.position.x=increment(camera.position.x,x_end,incrx);
		camera.position.y=increment(camera.position.y,y_end,incry);
		camera.position.z=increment(camera.position.z,z_end,incrz);
		rotationCamera=increment(rotationCamera,newangle,incrangle);
		camera.rotation.x = rotationCamera * Math.PI;
		await sleep(time);
	}

	//animatedRotationCamera(newangle,0.025);
	await sleep(100);

}
