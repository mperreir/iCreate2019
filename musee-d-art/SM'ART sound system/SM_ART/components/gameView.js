/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from 'react';
import { StyleSheet, } from 'react-native';
import { BackgroundView } from './backgroundView';
import { LumenView } from './enigmas/lumenView';
import { GuitarView } from './enigmas/guitarView';
import { FillingCircleView } from './enigmas/fillingCircleView';
import { SwaperView } from './enigmas/swaperView';
import { BreathingView } from './enigmas/breathingView';
import { SoundView } from './enigmas/soundView';
import { setApp } from './enigmas/enigmaBase';
import { load } from '../communications';
import {isNFCEnabled} from '../events';

/**
 * Vue principal du jeu affichant le component lié à l'énigme en cours.
 * Chaque énigme résolu fait progresser la vue dans la sous vue suivante.
 */
export class GameView extends Component {
	constructor(props) {
		super(props);
		setApp(this);
		this.setViews();
		this.state = { step: 0 };
	}
	/**
	 * Méthode pour passer à l'énigme suivante
	 */
	next() {
		this.setState({ step: this.state.step + 1 });
	}
	componentDidMount()
	{
		load((e)=>{
			alert("Erreur : impossible de se connecter au serveur, êtes-vous sûre d'avoir lancé le serveur et d'avoir bien configuré l'IP dans le menu de configuration de l'application ?");
			this.props.end();
		});
		isNFCEnabled().then((r)=>{
			if(!r)
			{
				alert("Erreur le NFC n'est pas activé !");
				this.props.end();

			}
		});
	}
	/**
	 * Active le tableau des énigmes
	 */
	setViews()
	{
		this.seqView = [
			<BreathingView duration={3000}></BreathingView>,
			<LumenView></LumenView>,
			<GuitarView></GuitarView>,
			<FillingCircleView></FillingCircleView>,
			<SoundView></SoundView>,
			<SwaperView></SwaperView>,
		];
	}
	end() {
		this.setViews();
		this.setState({ step: 0 });
	}
	/**
	 * Transition de vue d'une durée T
	 */
	nextTimed(duration) {
		this.seqView.splice(this.state.step + 1, 0, <BreathingView duration={duration}></BreathingView>)
		this.setState({ step: this.state.step + 1 });
	}
	/**
	 *Transition avec le lancement d'un son
	 La vue transite après la fin du son
	 * @param {*} sound
	 */
	nextSound(sound) {
		this.seqView.splice(this.state.step + 1, 0, <BreathingView sound={sound}></BreathingView>)
		this.setState({ step: this.state.step + 1 });
	}
	render() {
		return (
			<BackgroundView style={styles.container}>
				{this.seqView[this.state.step]}
			</BackgroundView>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: '#323232',
	},
	headline: {
		fontSize: 30,
		textAlign: 'center',
		margin: 10,
		color: '#F5F5F5'
	},
});