
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

Créer l'envionnement virtuel à partir de son export décrit en YAML, puis l'activer.

```bash
$ conda env create -f venv.yml 
```

### Lancement de l'application

```bash
$ conda activate icreate  # activation de l'environnement virtuel python
$ python src/main.py      # lancement du programme
```
