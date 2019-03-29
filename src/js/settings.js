var color = {
	//'blue' : 0x45a8e5,
	blue: 0x00909B,
	darkblue: 0x2F4858,
	grey: 0x51586C,
	grey2: 0x72687B,
	black: 0x212223,
	green: 0x92FF9C,
	purple: 0x845EC2,
	orange: 0xFF9671,
	yellow: 0xF9F871,
	beige: 0xBDA69E,
	beige2: 0xAA8F91,
}

var models_paths = {
	tree:{
		url:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/tree/tree.gltf'
	},
	// house:{
	// 	url:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/scene.gltf',
	// 	texture:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/textures/Material.001_diffuse.png',
	// 	seekChild:"house000_0"
	// }
};



let data = {1850:{
		1:[30,10,0,0,70,0],
		2:[20,10,0,0,60,10],
		3:[10,10,0,0,60,20],
		4:[0,10,0,0,50,30],
		5:[0,10,0,0,40,50],
		6:[0,10,0,0,40,50],
		7:[0,10,0,0,30,60],
		8:[0,10,0,0,30,60],
		9:[0,10,0,0,30,60],
		10:[0,10,0,0,30,60]
	},
	1950 :{
		1:[30,10,0,10,50,0],
		2:[20,10,10,10,50,0],
		3:[20,20,0,10,30,10],
		4:[20,20,0,0,50,10],
		5:[10,30,10,0,30,20],
		6:[10,30,0,0,30,30],
		7:[0,30,10,0,20,40],
		8:[0,30,10,0,20,40],
		9:[0,30,10,20,30,40],
		10:[0,30,10,20,30,40]
	},
	1999 :{
		1:[30,0,0,10,60,0],
		2:[10,20,0,10,60,0],
		3:[20,20,0,10,40,10],
		4:[10,10,0,0,50,20],
		5:[10,20,20,0,40,10],
		6:[10,30,10,0,40,10],
		7:[0,20,20,0,30,30],
		8:[10,30,20,0,20,20],
		9:[10,30,20,0,20,20],
		10:[20,30,20,0,20,10]
	},
	2019:{
		1:[10,30,0,10,50,0],
		2:[10,20,0,10,60,0],
		3:[10,25,10,5,40,10],
		4:[20,15,10,5,40,10],
		5:[10,30,20,0,30,20],
		6:[10,30,20,0,30,20],

		7:[10,20,20,0,20,10],
		8:[20,20,20,0,20,10],
		9:[10,30,30,0,20,10],
		10:[10,30,20,10,20,10]
	}
}


let batNamemanager = {1:"high_house",2:"little_house",3:"house_mitoyenne",4:"building",5:"tree", 6:"field"};

function ordre(name){
	switch (name) {
		case "building":
			return 5
			break;
		case "high_house":
			return 4
			break;
		case "house_mitoyenne":
			return 3
			break;
		case "little_house":
			return 2
			break;
		case "tree":
			return 1
			break;
		case "field":
			return 1
			break;
	}
}

function isSuperieur(new_model, old_model){
	return (ordre(new_model) > ordre(old_model)) ? true : false;
}
