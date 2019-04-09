# La DeadPool

- Partenaire : Département de Loire-Alantique 

- Etudiants : Alexis de Giusti, Arthur Ruellan, Bilel Jegham, Justine Fabarez, Jade _____, Rémi Gaillard,  Viviane Sabarly

- Technologie d'entrée : LeapMotion

- Technologie de sortie : Projection sur Objet (Mapping)

  

# Nom de l'installation (à remplacer)

## Description

Cette installation….

## Guide de réalisation et d’installation du projet

Ce projet est réalisable sur n'importe quelle structure en forme d'arbre, il faut mapper le tronc et les branches pour chaque nouvelle structure.

### Matériel nécessaire
1. Un vidéoprojecteur
2. Un écran 24 pouces (pour qu'il rentre dans la structure faite à cet usage)
3. Un ordinateur ayant deux sortie vidéo et avec 8Gb de ram
4. Une structure en forme d'arbre sur laquelle projeter
5. Cable et rallonge à prévoir
6. Leapmotion


### Logiciels nécessaires et procédure d'installation
#### Logiciels et librairies nécessaires :
1. Processing
 1. Module Physica (pour gérer de la physique sur les feuilles)
 2. Module LeapMotion (pour reconnaitre les mouvements fait avec le leapMotion)
2. SDK LeapMotion

#### Procédure d'installation
Mettre en place tous les équipements
Processing rajouter de la RAM alouée dans les préférences (6Gb)

##### Mapping du tronc
Ensuite il faut faire le mapping du tronc de l'arbre, pour le faire il faut lancer le sketch mapping.
Une fois le skecth mapping lancé il faut détourer le tronc à l'aide de la souris comme si on avait une brosse sur paint.
Vous disposez des touches suivantes pour controler le visuel et l'enregistrer :
- `r` pour enregistrer le dessin (sauvegarder dans le dossier /leapMotion/data/tronc.json)
- `backspace` pour effacer les derniers points
- `up` pour augmenter taille de la brosse
- `down` pour réduire la taille de la brosse


##### Mapping des branches
Une fois le skecth mapping_branche lancé il faut mapper les branches une à une sur la structure avec une souris.
Vous disposez des touches suivantes pour controler le visuel des branches et l'enregistrer :
- `n` créer une nouvelle branche
- `r` pour sauvegarder dans un fichier (sauvegarder dans le dossier /leapMotion/data/branches.json) 
- `v` supprimer la branche en cours
- `x` supprime la branche en cours et revient à la branche précédente
- `y` active l'effet de vent


### Procédures de montage et de lancement du projet
#### Lancement du leapMotion
Lancement du leapMotion
```bash
sudo leapd
```
> Si le leapMotion ne fonctionne pas bien on peut répondre aux questions avec les touches du clavier

Lancer le sketch leapMotion 


