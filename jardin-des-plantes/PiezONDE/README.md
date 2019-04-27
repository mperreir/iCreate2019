# PiezONDE

- Partenaire : SEVE

- Etudiants : Alma Steinfeld, Nijie Ma, Romane Watrin, Emme Brossaud, Yves Le Palud, Lilian Barreteau

- Technologie d'entrée : Capteurs piezo

- Technologie de sortie : Son spatialisé

  

# De fil en graines

## Guide de réalisation et d’installation du projet

## Cf. le dossier installation pour la structure

## Matériel nécessaire

* 1 Arduino Uno
* 4 Capteur piezo
* Enceinte Dolby 5.1 (Testé avec Creative inspire T6300) 
* Un ordinateur (Testé avec windows)

## Logiciels nécessaires et procédure d'installation

Environnement python 3.6 avec le package manager [conda](https://conda.io/projects/conda/en/latest/) ainsi que les packages suivants:

* [PySerial](https://github.com/pyserial/pyserial)
* [PyOpenAl](https://github.com/Zuzu-Typ/PyOpenAL)
* [PyOgg](https://github.com/Zuzu-Typ/PyOgg)

L'IDE Arduino pour téléverser le programme sur la carte [ici](https://www.arduino.cc/en/Main/Software)

## Lancement de l'installation

### Enceintes

Brancher les enceintes à l'ordinateur. Il faut ensuite disposer les enceintes pour former la configuration Dolby 5.1

Configurer votre ordinateur pour que la sortie son soit les enceintes. Vérifier que vous êtes bien en Dolby 5.1 et non en stéréo.

### Arduino
Téléverser le programme dans l'arduino. Laissez l'arduino branché à l'odrinateur.
Notez le nom de la console de la sortie standard de votre Arduino.

### Execution du programme python

Dans le fichier main.py à la ligne correspondant à:


serialInput = SerialInput(NOM_DE_LA_CONSOLE_DE_VOTRE_ARDUINO)

Remplacez NOM_DE_LA_CONSOLE_DE_VOTRE_ARDUINO par le nom que vous avez noté à l'étape précédente.

Executez main.py