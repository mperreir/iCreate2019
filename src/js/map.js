function getCirclePitSteps(width, length, object_width, object_length){
  let normalized_width = width / object_width;
  let normalized_length = length / object_length;

  let x = 0;
  let y = 0;
  let dx = 1;
  let dy = 0;
  let x_limit = 0;
  let y_limit = 0;
  let counter = 0;
  let counter_limit = 9;

  var res = [[]];

  while(counter < normalized_width * normalized_length){
    if(dx > 0){
        if(x > x_limit){
            dx = 0;
            dy = 1;
        }
    }
    else if(dy > 0){
        if(y > y_limit){
            dx = -1;
            dy = 0;
        }
    } else if(dx < 0){
        if(x < (-1 * x_limit)){
            dx = 0;
            dy = -1;
        }
    } else if(dy < 0) {
        if(y < (-1 * y_limit)){
            dx = 1;
            dy = 0;
            x_limit += 1;
            y_limit += 1;
        }
    }
    res[res.length-1].push({'x':x*object_width,'y':y*object_length});
    x += dx;
    y += dy;

    counter += 1;
    if(counter === counter_limit){
      counter_limit += (4 * Math.sqrt(counter)) + 4;
      res.push([]);
    }
  }

  return res;
}

function expansion(model, scene){
  let box = new THREE.Box3().setFromObject(model);
  steps = getCirclePitSteps(300, 300, box.max.x - box.min.x, (box.max.y - box.min.y)/1.5);
  console.log(steps);
  for(s of steps){
    for(pos of s){
      let new_model = model.clone();
      //new_model.position.set(pos.y, 0, pos.x);
      new_model.position.set(pos.x, 0, pos.y);
    	scene.add(new_model);
    }
  }
}

function treeMap(scene, models3D){
	models3D.tree.rotation.set(0, -1.5708, 0);
  expansion(models3D.tree, scene);
}
