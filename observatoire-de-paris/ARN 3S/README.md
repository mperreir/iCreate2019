# iCreate2019

## L'équipe ARN-3S

* Anaïs Barreaud
* Nathan Rossard
* Rémi Taunay
* Samuele Da Silva
* Selma Duran
* Simon Paugam

## Technologies

Entrée **-->** Sortie  
Leap Motion **-->** Son Spatialisé

## Contact de l'organisme porteur de projet

Lucie Leboulleux, de l'Observatoire de Paris.
 
# Installation

## Montage et démontage de la structure

**TODO**

## Logiciel

### Driver de la carte son StarTech ICUSBAUDIO7D

[Ce driver](https://sgcdn.startech.com/005329/media/sets/C-Media-CM6206_Drivers/[CMedia%20CM6206]%20Windows%20USB%207.1%20Audio%20Adapter.zip) est disponible sous Windows uniquement.  
Le télécharger puis l'installer.   

### Branchements physiques

Effectuer le branchement des différents périphériques.  
* leap motion
* carte son et ses enceintes 5.1

### Configuration du surround 5.1

Dans la zone de notification, ouvrir l'utilitaire du driver "USB Multi-Channel Audio Device" et régler sur 6 (5.1CH) la sortie analogique, dans l'onglet "Param. principal".

Toujours dans la zone de notification, clic droit sur l'icône du son > "Son" > "Lecture". Vérifier la présence des hauts-parleurs carte son et de sa sortie numérique. "Configurer" les hauts-parleurs de la carte son externe et régler sur "Surround 5.1". "Suivant"x3 puis "Terminer". 

### Installation du driver du Leap Motion

**TODO**

### Récupération des sources

```bash
$ git clone http://github.com/S0nzero/iCreate2019.git/ icreate
$ cd icreate
```

### Environnement d'exécution

Télécharger puis installer et configurer [conda](https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe).

```bash
$ conda update conda
$ conda config --add channels conda-forge
```

Créer et activer l'environnement virtuel python.
```bash
$ conda create -n icreate python=3.7
$ . activate icreate
$ pip install websockets pyopenal pyogg 
```

### Lancement de l'application

```bash
$ cd src
$ python main.py
```