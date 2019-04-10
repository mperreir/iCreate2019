# TEKER

- Partenaire : Archives Departementales

- Etudiants : Mayuko Loeillot, Alexandre Cail, Colin Treal, Farouk Khelifi, Stiven Morvan, Théodore Guellier Di Giulio

- Technologie d'entrée :

- Technologie de sortie :


# IN FINE Habitat

# Guide d'utilisation

## Description

Cette installation présente un voyage à travers le temps dans Nantes, en permettant une visualisation des évolutions de cette ville.
Elle permet une prise de conscience et une sensibilisation sur l'impact de nos habitations sur notre environnement en invitant le spectateur à prendre des choix.

Une carte virtuelle de Nantes s'affiche représentant sont état en 1500. L'utilisateur est invité à marcher sur différents dalles qui lui permettront d'avancer dans le temps jusqu'à nos jours.
La ville se construit et la caméra se met en vue première personne, un compteur affiche le nombre de nouveaux arrivants qu'il faut loger.
L'utilisateur doit les loger en tapant avec des maisons ou building imprimé en 3D. Au fur et à mesure des glitchs apparaissent jusqu'à une perte de contrôle suivi d'un message de sensibilisation.

## Guide de réalisation et d’installation du projet

### Matériel nécessaire
- 6 capteurs piezo, possédant une extension de leurs câbles
- Un ordinateur possédant chrome (la version a été développée en considérant ce navigateur)
- Une arduino et un cable d'alimentation USB

### Logiciels nécessaires et procédure d'installation
- Les package python suivant : flask, numpy numpy, matplotlib, flask_cors, flask_restful (installer via pip ou conda)
- L'IDE arduino (https://www.arduino.cc/en/Main/Software)
- Chrome (L'expérience marche sur d’autres navigateurs mais il peut y avoir des problèmes de compatibilités)

### Procédure de montage et de lancement du projet
- Relier les différents capteurs piezo à l'arduino
- Brancher l'arduino à l'ordinateur
- Vérifier le port de communication utilisé grâce au logiciel Arduino (Il suffit de regarder l'identifiant du serial détecté), s'il n'est pas égal à 4 il faut de changer l'identifiant ligne 31 de TraitementAudio.py)
- Pour démarrer le serveur python exécutez la commande : python src/python/TraitementAudio.py
- Vous pouvez vérifier les résultats en regardant les différentes variables accessible à l'adresse = localhost:5002
- Ouvrez le fichier index.html dans votre navigateur, l'expérience commencera (une fois l'expérience terminée relancer avec F5)
- PS : La version de l'application a été réadapté pour quelle puisse marcher en autonomie sans l'installation physique. (en version web)
