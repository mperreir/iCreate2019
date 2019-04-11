# Application

Ce dossier contient l'application de notre projet.
Celle-çi permet également de configurer les tags et le serveur à utiliser pour l'escape game.

L'application gère chaque énigme comme une sous vues avec ses propres événements, chaque énigmes se situent dans le dossier components/enigmas.

Vous pouvez également consultez ce schéma pour avoir un aperçu des vues, et les fichiers qui leurs correspondent.

![Schéma des vues](./schéma.png)

- T : vue de transition : [](./components/breathingView.js)
- M1-M5 : menus : [](./menuView.js)
- E1 : Enigme de luminosité [](./components/lumenView.js)
- E2 : Enigme de la guitare [](./components/guitarView.js)
- E3 : Enigme de la chasse et des tags [](./components/fillingCircleView.js)
- E4 : Enigme du cadenas [](./components/soundView.js)
- E5 : Enigme des portraits [](./components/swaperView.js)