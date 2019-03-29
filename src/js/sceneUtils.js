function makeLight(){
	lightAmbient = new THREE.AmbientLight(0x7f7f7f);

	solar_light = new THREE.DirectionalLight();
	solar_light.position.set(-500, 500, 0);
	solar_light.castShadow = true;
	solar_light.intensity = 1;

	solar_light.shadow.mapSize.width = 2048;
	solar_light.shadow.mapSize.height = 2048;
	solar_light.shadow.camera.near = 0.5;
	solar_light.shadow.camera.far = 20000;

	intensidad=150;

	solar_light.shadow.camera.left = -intensidad;
	solar_light.shadow.camera.right = intensidad;
	solar_light.shadow.camera.top = intensidad;
	solar_light.shadow.camera.bottom = -intensidad;

	scene.add(solar_light, lightAmbient);
}

function makeSky(){
	var vertexShader = `
		varying vec3 vWorldPosition;
			void main() {
				vec4 worldPosition = modelMatrix * vec4(position, 1.0);
				vWorldPosition = worldPosition.xyz;
				gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
			}
	`;
	var fragmentShader = `
			uniform vec3 topColor;
			uniform vec3 bottomColor;
			uniform float offset;
			uniform float exponent;
			varying vec3 vWorldPosition;
			void main() {
				float h = normalize(vWorldPosition + offset).y;
				gl_FragColor = vec4(mix(bottomColor, topColor, max(pow(max(h , 0.0), exponent), 0.0)), 1.0);
			}
	`;

	var uniforms = {
		"topColor": { value: new THREE.Color(0x0077ff) },
		"bottomColor": { value: new THREE.Color(0xcfe5fe) },
		"offset": { value: 33 },
		"exponent": { value: 0.6 }
	};

	scene.fog = new THREE.Fog(scene.background, 1, 800);
	scene.fog.color.copy(uniforms[ "bottomColor" ].value);
	var skyGeo = new THREE.SphereBufferGeometry(4000, 32, 15);
	var skyMat = new THREE.ShaderMaterial({
		uniforms: uniforms,
		vertexShader: vertexShader,
		fragmentShader: fragmentShader,
		side: THREE.BackSide
	});
	var sky = new THREE.Mesh(skyGeo, skyMat);
	scene.add(sky);
}

async function createMap(){
	texture = new THREE.TextureLoader().load("https://raw.githubusercontent.com/morvan-s/iCreate2019/master/src/textures/texture.jpg");
	material = new THREE.MeshLambertMaterial({map: texture});
	plane = new THREE.Mesh(new THREE.PlaneGeometry(400, 400), material);
	plane.material.side = THREE.DoubleSide;
	plane.position.x = 10;
	plane.position.z = -30;
	plane.rotation.x = -0.5 * Math.PI;
	plane.receiveShadow = true;
	scene.add(plane);
}


function setShaders(){
	var saturationShader = {
		uniforms: {
			"tDiffuse": { type: "t", value: null },
			"saturation": { type: "f", value: 1.5 },
		},
		vertexShader: [
			"varying vec2 vUv;",
			"void main() {",
				"vUv = uv;",
				"gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);",
			"}"
		].join("\n"),
		fragmentShader: [
			"uniform sampler2D tDiffuse;",
			"varying vec2 vUv;",
			"uniform float saturation;",
			"void main() {",
				"vec3 original_color = texture2D(tDiffuse, vUv).rgb;",
				"vec3 lumaWeights = vec3(.25,.50,.25);",
				"vec3 grey = vec3(dot(lumaWeights,original_color));",
				"gl_FragColor = vec4(grey + saturation * (original_color - grey) ,1.0);",
			"}"
		].join("\n")
	};

	saturation_renderer = new THREE.EffectComposer(renderer);
	saturation_renderer.addPass(new THREE.RenderPass(scene, camera));
	let saturationEffect = new THREE.ShaderPass(saturationShader);
	saturationEffect.renderToScreen = true;
	saturation_renderer.addPass(saturationEffect);
	active_renderer = saturation_renderer;

	let glitchPass = new THREE.GlitchPass();
	glitchPass.renderToScreen = true;
	glitch_renderer = new THREE.EffectComposer(renderer);
	glitch_renderer.addPass(new THREE.RenderPass(scene, camera));
	glitch_renderer.addPass(glitchPass);
	glitch_renderer.passes[1].goWild = true;
}
