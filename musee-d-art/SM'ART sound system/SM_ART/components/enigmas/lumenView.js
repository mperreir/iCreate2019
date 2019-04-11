import React, {
	Component,
} from 'react';
import { Image, View, StyleSheet } from 'react-native'
import { lightHandler } from '../../events';
import { app } from './enigmaBase'
import {InterView} from './interView';
import { play_sound, stop_sound, play_ambiance, stop_ambiance } from '../../communications';
/**
 * Vue pour la première étape.
 * Attend que la luminosité soit haute pour aller à l'énigme suivante.
 */
export class LumenView extends Component {
	constructor(props) {
		super(props)
	}
	componentDidMount() {
		play_ambiance("ghost")
		this.lightHandler = lightHandler((light)=>{
			//Passage à l'énigme suivant quand la luminosité passe au dessus de 10
			if(light>10){
				stop_ambiance("ghost")
				this.lightHandler.stop();
				//Transition avec le son de l'introduction
				app.nextSound("intro");
				lightHandler((light) => {});
			}
		});
	}
	componentWillUnmount() {

	}
	render() {
		return (
			<InterView>
			</InterView>
		);
	}
}
