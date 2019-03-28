/* Filename: client.js */
const views = 
	[
		{
			paragraphe: "Vous avez décidé de rendre l’étalement urbain maximal. La population est heureuse \
				d’avoir des pavillons avec des très grands jardins dans des espaces calmes, \
				mais la surface agricole a disparu. Votre population a faim, et passe des heures \
				dans les embouteillages pour aller travailler en centre-ville, ou pour accéder \
				aux services publics. Les espaces verts naturels ont disparus. \
				Essayez de construire la ville plus haute.",
			script: render0
		},
		{
			paragraphe: "L’étalement urbain est important. La population est ravie de vivre dans des \
				pavillons avec des petits jardins, mais la surface agricole est peu conséquente. \
				Votre population se plaint du manque de nourriture dans les étalages des magasins, \
				ainsi que des embouteillages aux heures de pointe. Il ne reste qu’une seule forêt, \
				très éloignée de la ville. Essayez de construire la ville plus haute.",
			script: render1
		},
		{
			paragraphe: 'L’étalement urbain est moyen. La population vit dans des maisons mitoyennes \
				et dans des grands appartements avec balcon. La surface agricole n’est pas optimale, \
				mais suffisante. Votre population préfère prendre les transports en commun pour \
				éviter les embouteillages aux heures de pointe, et profite des forêts en périphérie \
				pour faire des balades le weekend.',
			script: render2
		},
		{
			paragraphe: "L’étalement urbain est moindre. La population vit dans des appartements avec balcons. \
				La surface agricole est optimale et permet un bon développement économique. \
				Votre population peut se permettre d’aller à pied au travail et aux services publics. \
				Une dynamique propre à la collectivité s’est instaurée, et pour apprécier des moments \
				calmes, beaucoup profitent des espaces naturels à portée des transports en communs.",
			script: render3
		},
		{
			paragraphe: "L’étalement urbain est minime. La population vit dans de petits appartements dans \
				de très hauts immeubles. La surface agricole est importante et a accéléré le \
				développement économique de la ville. Tous les services sont à quelques minutes \
				à pied, mais la ville est bruyante et dense. Le prix des appartements a beaucoup \
				augmenté. Essayez de construire la ville plus basse.",
			script: render4
		}
	]

function render0(){

	// Affichage de l'image de fond
	$("#back_image").attr('src','img0.svg');

	//Affichage animée du texte
	$(".text").css({"position":"absolute", "color":"white","width":"260px", "top":"320px","right":"70px", "font-size":"19px", "text-align": "justify"});
	$(".text").toggle('slow');
	$(".text").text(views[0].paragraphe);
	
	//Placement de chaque point
	$("#1").css({"position":"absolute","top":"10.8em","left":"14.8em"});
	$("#2").css({"position":"absolute","top":"20.1em","left":"22.8em"});
	$("#3").css({"position":"absolute","top":"25.6em","left":"35.9em"});
	$("#4").css({"position":"absolute","top":"31em","left":"35.9em"});
	$("#5").css({"position":"absolute","top":"36.4em","left":"22.8em"});
	$("#6").css({"position":"absolute","top":"41.9em","left":"22.8em"});
	//Affichage animée des points
	$(".circle").toggle('slow');
	
}

function render1(){

	// Affichage de l'image de fond
	$("#back_image").attr('src','img1.svg');
	
	//Affichage animée du texte
	$(".text").css({"position":"absolute", "color":"white","width":"260px", "top":"320px","right":"70px", "font-size":"19px", "text-align": "justify"});
	$(".text").toggle('slow');
	$(".text").text(views[1].paragraphe);

	//Placement de chaque point
	$("#1").css({"position":"absolute","top":"10.8em","left":"18.1em"});
	$("#2").css({"position":"absolute","top":"20.1em","left":"26.2em"});
	$("#3").css({"position":"absolute","top":"25.5em","left":"32.6em"});
	$("#4").css({"position":"absolute","top":"31em","left":"32.6em"});
	$("#5").css({"position":"absolute","top":"36.4em","left":"26.2em"});
	$("#6").css({"position":"absolute","top":"41.9em","left":"26.2em"});
	//Affichage animée des points
	$(".circle").toggle('slow');
	
}


function render2(){

	// Affichage de l'image de fond
	$("#back_image").attr('src','img2.svg');
	
	//Affichage animée du texte
	$(".text").css({"position":"absolute", "color":"white","width":"260px", "top":"320px","right":"70px", "font-size":"19px", "text-align": "justify"});
	$(".text").toggle('slow');
	$(".text").text(views[2].paragraphe);

	//Placement de chaque point
	$("#1").css({"position":"absolute","top":"10.8em","left":"21.4em"});
	$("#2").css({"position":"absolute","top":"20.1em","left":"29.5em"});
	$("#3").css({"position":"absolute","top":"25.6em","left":"29.5em"});
	$("#4").css({"position":"absolute","top":"31em","left":"29.5em"});
	$("#5").css({"position":"absolute","top":"36.4em","left":"29.5em"});
	$("#6").css({"position":"absolute","top":"41.9em","left":"29.5em"});
	//Affichage animée des points
	$(".circle").toggle('slow');
	
}


function render3(){

	// Affichage de l'image de fond
	$("#back_image").attr('src','img3.svg');
	
	//Affichage animée du texte
	$(".text").css({"position":"absolute", "color":"white","width":"260px", "top":"320px","right":"70px", "font-size":"18px", "text-align": "justify"});
	$(".text").toggle('slow');
	$(".text").text(views[3].paragraphe);

	//Placement de chaque point
	$("#1").css({"position":"absolute","top":"10.8em","left":"24.7em"});
	$("#2").css({"position":"absolute","top":"20.1em","left":"32.6em"});
	$("#3").css({"position":"absolute","top":"25.6em","left":"26.2em"});
	$("#4").css({"position":"absolute","top":"31em","left":"26.2em"});
	$("#5").css({"position":"absolute","top":"36.4em","left":"32.6em"});
	$("#6").css({"position":"absolute","top":"41.9em","left":"32.6em"});
	//Affichage animée des points
	$(".circle").toggle('slow');
	
}


function render4(){

	// Affichage de l'image de fond
	$("#back_image").attr('src','img4.svg');
	
	//Affichage animée du texte
	$(".text").css({"position":"absolute", "color":"white","width":"260px", "top":"320px","right":"70px", "font-size":"19px", "text-align": "justify"});
	$(".text").toggle('slow');
	$(".text").text(views[4].paragraphe);

	//Placement de chaque point
	$("#1").css({"position":"absolute","top":"10.8em","left":"28em"});
	$("#2").css({"position":"absolute","top":"20.1em","left":"35.9em"});
	$("#3").css({"position":"absolute","top":"25.6em","left":"22.75em"});
	$("#4").css({"position":"absolute","top":"31em","left":"22.75em"});
	$("#5").css({"position":"absolute","top":"36.4em","left":"35.9em"});
	$("#6").css({"position":"absolute","top":"41.9em","left":"35.9em"});
	//Affichage animée des points
	$(".circle").toggle('slow');
	
}

// Cache les composants ajoutés dynamiquement sur l'image de fond
function clear(){
	$(".text").toggle();
	$(".circle").toggle();
}

// Au lancement de la page
$(document).ready(function() {
	
	// Création d'un socket client
	var socket = io.connect('http://localhost:8080');
	
	// Stocke le niveau affiché à l'écran
	var currentLevel;
	
	// A la réception d'un message du serveur
	socket.on('message', function(niveau) {
		// Lors de la réception du premier message
		if(typeof currentLevel === 'undefined'){
			views[niveau].script();
		}
		// Dans le cas où le niveau à afficher ne l'est pas encore
		else if(niveau !== currentLevel){
			clear();
			views[niveau].script();
		}
		currentLevel = niveau;
	});
   
  });