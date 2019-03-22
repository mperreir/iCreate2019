let CONTAINER = [];

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

function makeCircle(rayonmax, padding_max){

  var res = [[]];
  rayon = padding_max;
  while (rayon < rayonmax){
    steps = 2 * rayon * Math.PI / padding_max;

    res.push(circle(rayon, steps, 0, 0));
    inter=[];
    rayon+=padding_max;

  }
  console.log(res);
  return res;

}
async function expansion(models, scene, speed=1, width=300, length=300, rand=2, padding=2){
  let max = getHugestObject(models);
  steps = makeCircle(100,max.userData.length + padding);
  //getCirclePitSteps(width, length, max.userData.length + padding,
      //max.userData.width + padding);
  let add_model = async () => {
      let new_model = (models[Math.floor(Math.random() * models.length)]).clone();
      new_model.position.set(pos.x + Math.random() * rand, 0, pos.y + Math.random() * rand);
      new_model.rotation.set(0, Math.PI * Math.random(), 0);
      await sleep(Math.random() * 1000 * speed);
      let scale = 1 + ((Math.random() * 0.3) - 0.3);
      new_model.scale.set(scale, scale, scale);
      scene.add(new_model);
      CONTAINER.push(new_model);
  };

  for(var s of steps){
    for(var pos of s) add_model(pos);
    await sleep(800*speed);
  }
}

async function treeMap(scene, models3D){
  await expansion([models3D.tree], scene, 0.4, 100, 200, 5, 4);
}

async function houseMap(scene, models3D){
  models3D.house.scale.set(0.1,0.1,0.1);
  expansion([models3D.house], scene, 0.7, 500, 500, 10, 30);
}

async function cityMap(scene, models3D){
  let model_arr = Object.values(models3D);
  model_arr = model_arr.filter(x => x.userData.name !== 'tree');
  await expansion(model_arr, scene, 1, 100, 200, 2, 2);
}

async function removeMap(scene, models3D){
  let max = CONTAINER.length;
  for(var i = 0; i < max; i++){
    let temp_object = CONTAINER.shift();
    scene.remove(temp_object);
    await sleep(1);
  }
}

function circle (radius, steps, centerX, centerY){
    var xValues = [centerX];
    var yValues = [centerY];
    inter=[];
    for (var i = 1; i < steps; i++) {
        xValues = (centerX + radius * Math.cos(Math.PI * i / steps*2-Math.PI/2));
        yValues = (centerY + radius * Math.sin(Math.PI * i / steps*2-Math.PI/2));
        inter.push({'x':xValues,'y':yValues})
   }
   console.log(inter);
   return inter;

}
function replaceElement(old_model, new_model){
  new_model = (new_model).clone();
  new_model.rotation.set(0, Math.PI * Math.random(), 0);
  let scale = 1 + ((Math.random() * 0.3) - 0.3);
  new_model.scale.set(scale, scale, scale);
  new_model.position.set(old_model.position.x, 0, old_model.position.z);
  scene.add(new_model);
  scene.remove(old_model);
}

function replaceByModel(model){
  let different_model;
  let u = 0;
  while(CONTAINER[u].userData.name === model.userData.name &&
    u < CONTAINER.length - 1) u++;

  if(CONTAINER[u].userData.name !== model.userData.name){
    replaceElement(CONTAINER[u], model);
    CONTAINER.splice(u,1);
  }
}

function addBuilding() {
  replaceByModel(models3D.skyscraper);
};

function addHouse() {
  replaceByModel(models3D.house2);
};
