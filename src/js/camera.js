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
async function moveCamera(x_end, y_end,z_end,newangle,time){
	while(Math.abs(camera.position.x-x_end) != 0 || Math.abs(camera.position.y-y_end) != 0 || Math.abs(camera.position.z-z_end) != 0  ||Math.abs(rotationCamera-newangle) != 0 ){
		camera.position.x=increment(camera.position.x,x_end,1);
		camera.position.y=increment(camera.position.y,y_end,1);
		camera.position.z=increment(camera.position.z,z_end,1);
		rotationCamera=increment(rotationCamera,newangle,0.025);
		camera.rotation.x = rotationCamera * Math.PI;
		if (Math.abs(rotationCamera-newangle) != 0){
			rotationCamera=increment(rotationCamera,newangle,0.00000025);
			await sleep(50);
		}
		
		console.log(rotationCamera);
		console.log("1");
		
		await sleep(time);
	}

	//animatedRotationCamera(newangle,0.025);
	await sleep(100);

}