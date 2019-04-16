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
		url:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/archives-departementales/Teker/src/model/tree/tree.gltf'
	},
	// house:{
	// 	url:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/scene.gltf',
	// 	texture:'https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/model/house/textures/Material.001_diffuse.png',
	// 	seekChild:"house000_0"
	// }
};

let data = {1850:{
		1:[20,10,0,0,80,0],
		2:[10,10,0,0,50,30],
		3:[0,10,0,0,40,50],
		4:[0,10,0,0,30,60],
		5:[0,10,0,0,30,70],
		6:[0,10,0,0,30,70],
		7:[0,0,0,0,30,70],
		9:[0,0,0,0,30,70],
		7:[0,0,0,0,30,70],
		9:[0,0,0,0,30,70],
	},
	1950 :{
		1:[20,10,0,0,80,0],
		2:[10,10,0,0,50,30],
		3:[0,10,0,0,40,50],
		4:[0,10,0,0,30,60],
		5:[0,10,0,0,30,70],
		7:[0,0,0,0,30,70],
		9:[0,0,0,0,30,70],
		7:[0,0,0,0,30,70],
		9:[0,0,0,0,30,70],
	},
	1999 :{
		1:[20,0,5,5,80,0],
		2:[10,0,5,5,50,30],
		3:[0,10,0,0,40,50],
		4:[0,10,0,0,30,60],
		5:[0,10,0,0,30,70],
		6:[0,10,0,0,30,70],
		7:[0,10,0,0,30,70],
		8:[0,10,0,0,30,70],
		9:[0,10,0,0,20,70],
		10:[0,10,0,0,20,70]
	},
	2019:{
		1:[20,0,5,5,80,0],
		2:[10,0,5,5,50,30],
		3:[0,10,0,0,40,50],
		4:[0,10,0,0,30,60],
		5:[0,10,0,0,30,70],
		6:[0,10,0,0,30,70],
		7:[0,10,0,0,30,70],
		8:[0,10,0,0,30,70],
		9:[0,10,0,0,20,70],
		10:[0,10,0,0,20,70]
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
