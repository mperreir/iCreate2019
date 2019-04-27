import React, {
	Component,
} from 'react';
import { Image, View, StyleSheet, Dimensions } from 'react-native'
import { app,Tags,TagsHandler} from './enigmaBase';
import { InterView } from './interView';
var { height, width } = Dimensions.get('window');
import { play_sound, stop_sound, play_ambiance,stop_ambiance } from '../../communications';
/**
 * Vue gérant l'énigme du cadena
 * Attend seulement l'utilisation du bon tag pour aller à l'étape suivante.
 */
export class SoundView extends Component {
	constructor(props) {
		super(props)
	}
	componentDidMount() {
		//Lancement de l'ambiande du cadenas
		//Chaque son correspond à un chiffre du code
		play_ambiance("cadenas");
		this.tagHandler = TagsHandler;
		this.tagHandler.addTagHandler(Tags.coeur, () => {
			this.tagHandler.removeTagHandler(Tags.coeur);
			//Changement d'énigme
			//Stop l'ambiance et lance le dialogue suivant
			stop_ambiance("cadenas");
			app.nextSound("enigme4");
		});
	}
	componentWillUnmount() {

	}
	render() {
		return (
			<InterView/>
		);
	}
}

