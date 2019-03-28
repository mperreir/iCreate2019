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
  return res;
}

async function expansion(models, scene, speed=1, width=300, length=300, rand=2, padding=2){
  let max = getHugestObject(models);
  steps = makeCircle(100,max.userData.length + padding);
  //getCirclePitSteps(width, length, max.userData.length + padding,
      //max.userData.width + padding);
  let add_model = async () => {
    var x = pos.x + Math.random() * rand;
    var y =  pos.y + Math.random() * rand;
    let new_model = getModelbyZone(x,y);
    var z = new_model.position.y;
    var alpha =  Math.PI * Math.random();
    var bo = await regionOccupated(x,y,new_model.userData.width,new_model.userData.length,alpha);
    if(bo === false){
      new_model.position.set(x,z,y);
      new_model.rotation.set(0,alpha, 0);
      // console.log(await getZone(x,y))
      await sleep(Math.random() * 1000 * speed);
      let scale = 1 + ((Math.random() * 0.3) - 0.3);
      new_model.scale.set(scale, scale, scale);
      scene.add(new_model);
      CONTAINER.push(new_model);
    }
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
   return inter;
}

function replaceElement(old_model, new_model){
  //sound2.stop();
  sound2 = new Howl({
  src: ["https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/ressources/sounds/chantier.ogg"],
  volume: 0.9
	});
  sound2.play();
  new_model = (new_model).clone();
  new_model.rotation.set(0, Math.PI * Math.random(), 0);
  let scale = 1 + ((Math.random() * 0.3) - 0.3);
  new_model.scale.set(scale, scale, scale);
  new_model.position.set(old_model.position.x, new_model.position.y, old_model.position.z);
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
  replaceByModel(models3D.building);
};

function addHouse() {
  replaceByModel(models3D.little_house);
};

async function regionOccupated(x,y,lar,lon,alpha){
  var maxX,maxY,minX,minY;
  if(alpha < Math.PI/2 ){
    maxX = x + Math.cos(alpha) * lar + Math.cos(alpha - Math.PI/2) * lon;
    minX = x ;
    maxY = y + Math.sin(alpha) * lar;
    minY = y + Math.sin(alpha - Math.PI/2) * lon;
  }else if (alpha < Math.PI) {
    maxX = x + Math.cos(alpha - Math.PI/2) * lon;
    minX = x + Math.cos(alpha) * lar;
    maxY = y + Math.sin(alpha - Math.PI/2) * lon + Math.sin(alpha) * lar;
    minY = y;
  }else if (alpha < 3*Math.PI/2) {
    maxX = x;
    minX = x + Math.cos(alpha) * lar + Math.cos(alpha - Math.PI/2) * lon;
    maxY = y + lon * Math.sin(alpha - Math.PI/2);
    minY = y + Math.sin(alpha) * lar;
  }else{
    maxX = x + Math.cos(alpha) * lar;
    minX = x + Math.cos(alpha - Math.PI/2) * lon;
    maxY = y;
    minY = y + Math.sin(alpha - Math.PI/2) * lon + Math.sin(alpha) * lar;
  }
	for (var i = Math.round(minX); i <= Math.round(maxX+0.1) ;i++) {
		for (var j = Math.round(minY); j <=Math.round(maxY+0.1); j++ ){
			var bo = await isOccupated(i,j)
			if(bo == true){
				return true;
			}
		}
	}
	return false;
}

async function isOccupated(x,y){
	var rx = x + 200 - 10;
	var ry = y + 200 + 30;

	if(rx > 400 || ry > 400 || rx < 0 || ry < 0){
		console.log('Out of bounds');
		return true;
	}else{
		let pixel = context.getImageData(rx, ry, 1, 1).data;
		if(pixel[0] > 100){
			return true;
		}else{
			return false;
		}
	}
}

function getZone(x,y){
	var rx = x + 400 + 200 - 10;
	var ry = y + 200 + 30;
  var pixel = context.getImageData(rx,ry,1,1).data;
  var r = pixel[0];
  var v = pixel[1];




  if(r < 50){
    r = 0;
  }else if (r < 112) {
    r = 102;
  }else if (r < 170) {
    r = 128;
  }else if (r < 240) {
    r = 232;
  }else{
    r = 255;
  }

  if(v < 40){
    v = 0;
  }else if (v < 100) {
    v = 82;
  }else if (v < 170) {
    v = 128;
  }else if (v < 240) {
    v = 230;
  }else{
    v = 255;
  }


  switch(r){
    case 232:
      return 1;
      break;
    case 102:
      return 2;
      break;
    case 0:
      switch(v){
        case 82:
          return 3;
          break;
        case 128:
          return 4;
          break;
        case 255:
          return 10;
          break;
        case 0:
          return 11;
          break;
      }
      break;
    case 128:
      switch(v){
        case 128:
          return 5;
          break;
        case 230:
          return 6;
          break;
        case 255:
          return 7;
          break;
      }
      break;
    case 255:
      if(v == 255){
        return 8;
      }else{
        return 9;
      }
    break;

  }


  return 99;

	// 3 = (0,82,38)
	// 4 = (0,128,128)
	// 5 = (128,128,128)
	// 6 = (128,230,128)
	// 7 = (128,255,180)
	// 8 = (255,255,180)
	// 9 = (255,0,0)
	// 10 = (0,255,0)
	// 11 = (0,0,255)

}



function getModelbyZone(x,y){
  x = Math.round(x);
  y = Math.round(y);
  var zoneType = getZone(x,y);
  var annee  = 1850;
  switch(global_state){
    case 0:
      annee = 1850;
      break;
    case 1:
      annee = 1950;
      break;
    case 2:
      annee = 1999;
      break;
    case 3:
      annee = 2016;
      break;
  }

  var value = Math.random() * 100;
  var i = 0;
  while(value >= 0 && i < 6){
    value -= data[annee][zoneType][i];
    i++;
    //console.log(data[annee][zoneType])
  }



  //aletaoire
  // console.log(models3D.little_house);
  return models3D[batNamemanager[i]].clone();
}
//Données json

/*["HightHouse","LittleHouse","HouseMitoyenne","Building","tree", "fields"] */
/*
    "orange"  :1
  "brown" :2
  "green" :3
  "darkblue" :4
  "grey" :5
  "lightgreen" :6
  "white":7
  "red":8
  "flashgreen":9
  "blue":10
*/
