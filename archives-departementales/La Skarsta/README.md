# La Skarsta

- **Partenaire** : Département de Loire Atlantique

- **Etudiants** : 
	- COUGNAUD Julien
	- CRÉQUER Kilian
	- DUFOUR Laureline
	- MOITEAUX Quentin
	- MULTON Justine
	- PAPILLON Guillaume
	- PARAIRE Léa

- **Technologie d'entrée** : Capteurs téléphone mobile

- **Technologie de sortie** : Périphérique mobile

  

# De l'horizontal au vertical

## Description

Cette installation….

## Guide de réalisation et d’installation du projet

Comprend les aspects matériels et logiciels (toute l'installation, pas que la partie informatique !). A faire en commun avec les designers. Peut être intégré au README ou faire l'objet d'un PDF externe.

### Partie Design
...


### Partie informatique

#### Pré-requis

##### Matériels

- Un smartphone équipé d'un capteur NFC, notamment un Nokia 6.
- Une tablette Samsung Galaxy A.
- Un ordinateur / serveur sur lequel sera lancé le serveur web.
	
Les trois équipements doivent se trouver sur le même réseau (accès au même réseau WIFI par exemple). L'ordinateur devra notamment être accessible depuis son adresse IP notée [ADRESSE_IP_SERVEUR] dans la suite de ce README.

##### Logiciels

Sur l'ordinateur devra être installé : 
- NodeJS (v11.12.0) - https://nodejs.org/fr/ et son gestionnaire de paquets officiels : npm.
- Le lecteur multimédia MPlayer - https://sourceforge.net/projects/mplayerwin/. Puis ajoutez dans la variable d'environnement PATH de votre système, le chemin du répertoire d'installation de ce lecteur.
	
Sur le téléphone devra être installé :
- L'application mobile Sensors2C pour permettre l'envoi de requêtes OSC au serveur - https://sensors2.org/osc/

#### Etapes d'installation

##### Configuration Smartphone
Configurez l'application Sensors2C en indiquant dans les paramètres de cette application :
- L'adresse IP de l'ordinateur (champ Host). Pour la récupérer, sous Windows par exemple, ouvrez un invité de commandes et tapez la commande ipconfig pour récupérer l'adresse IPv4 associée à votre poste. Même démarche dans une console Linux avec la commande ifconfig ou ip addr.
- Le port qui sera écouté par le serveur pour transmettre les informations relatives aux tags NFC scannés depuis le téléphone. Indiquez le port 9912.
- Un taux d'envoi des données au serveur (champ Sensor Rate). Vous pouvez indiquer ici un taux "normal (slowest)". A noter que plus il est élevé, et plus votre smartphone se déchargera vite.
- Puis, toujours dans cette application, dans la fenêtre principale, activez la récupération des données NFC ("Near Field Communication") puis la transmission des données ("Send data"). Si vous ne voyez pas le protocole NFC dans la liste, vérifiez l'activation du NFC dans les paramètres de votre smartphone. 
		
##### Configuration serveur

- Modifiez le fichier public/client.js pour y indiquer l'adresse IP du futur serveur web sous la forme suivante :

// Création d'un socket client

var socket = io.connect('http://[ADRESSE_IP_SERVEUR]:8080');

- Sur l'ordinateur jouant le rôle de serveur, placez-vous à la racine du projet (où se trouve ce README), puis lancez les commandes suivantes : 
- npm install pour installer les packages requis pour lancer l'application web.
- node app.js pour lancer le serveur.
	
	
##### Configuration tablette
- Ouvrez le navigateur sur la tablette puis accédez à la page suivante : http://[ADRESSE_IP_SERVEUR]:8080/ , vous devrez alors voir la page apparaître à l'écran.
