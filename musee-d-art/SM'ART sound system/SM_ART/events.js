/**
 * Fichier contenant les différents types d'événements utilisés.
 *
 *
 * */
import React, {
	DeviceEventEmitter // will emit events that you can listen to
} from 'react-native';
import { SensorManager } from 'NativeModules';
import NfcManager, { NfcAdapter } from 'react-native-nfc-manager'

/**
 *
 *	Fonction permettant de créer un gestionaire d'événement pour des secousses de téléphone
 *
 * @param {*} time Temps de secousse nécessaire
 * @param {*} threshold Seuil de force (somme des forces selon les axes x,y et de l'accéléromètre)
 * @param {*} activation Foncion lancé au début d'une secousse
 * @param {*} stop  Fonction lancé à la fin d'une secouse
 * @param {*} callback  Evénement à lancer quand l'événement s'est bien réalisé
 */
export function ShakingHandler(time,threshold,activation,stop,callback)
{
	var begin = false;
	var elapsedtime = 0;
	DeviceEventEmitter.addListener('Accelerometer', function (data) {
		let x = data.x;
		let y = data.y;
		let z = data.z;
		let sum = Math.abs(x) + Math.abs(y) + Math.abs(z);
		if (sum > threshold && begin == false) {
			activation();
			begin = true;
			elapsedtime = 0;
		} else if (sum > threshold) {
			elapsedtime += 0.1;
			if (elapsedtime >= time) {
				begin = false;
				elapsedtime = 0;
				stop();
				callback();
			}
		}
		else if(sum <= threshold && begin==true) {
			stop();
			begin = false;
			elapsedtime = 0;
		}
	}
	);
	SensorManager.startAccelerometer(100);
	this.stop = () => { SensorManager.stopAccelerometer();}
	return this;
}
/**
 * Retourne si le NFC est activé sur le téléphone
 */
export function isNFCEnabled()
{
	return NfcManager.isEnabled();
}
/**
 * Créer un gestionaire de tag
 * @param {*} unknownHandler Fonction par défaut pour un tag inconnu
 */
export function tagHandler(unknownHandler)
{
	this.tagMap = {};
	this.unknownHandler = unknownHandler;
	/**
	 * Fonction permettant de rajouter un événement à un tag
	 */
	this.addTagHandler = function(tag,handler){this.tagMap[tag]=handler;};
	/**
	 * Retire un tag de la liste des tags
	 */
	this.removeTagHandler = function(tag){delete this.tagMap[tag]};
	/**
	 * Définit l'événement par défaut
	 */
	this.setUnknownHandler = function(handler){this.unknownHandler = handler};
	this.stop = function(){NfcManager.unregisterTagEvent()};
	NfcManager.registerTagEvent(
		tag => {
			if(this.tagMap[tag.id])
			{
				this.tagMap[tag.id]();
			}
			else
			{
				this.unknownHandler(tag);
			}
		},
		'',
		{
			invalidateAfterFirstRead: true,
			isReaderModeEnabled: true,
			readerModeFlags:
				NfcAdapter.FLAG_READER_NFC_A | NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK,
		},
	);
	return this;
}
/**
 * Désactive le gestionaire d'événement de luminosité
 */
function stopLight() {
	SensorManager.stopLightSensor();
	DeviceEventEmitter.removeAllListeners('LightSensor');
}
var lH = {
	"stop": stopLight
}
/**
 * Définit un gestionaire d'évenment de luminosité
 * @param {*} callback Fonction d'événement prenant en paramètre la luminosité.
 */
export function lightHandler(callback)
{
	SensorManager.startLightSensor(100);	DeviceEventEmitter.addListener('LightSensor', function (data) {
		callback(data.light);
	}
	);
	return lH;
}


function stop(){
	SensorManager.stopGyroscope();
}
var gyroHandler = {
	"stop":stop
}
/**
 * Définit un gestionaire d'évenment de rotation
 * @param {*} callback Fonction d'événement prenant en paramètre les axes du gyroscope (x,y,z)
 */
export function gyroscopeHandler(callback) {
	SensorManager.startGyroscope(100);
	DeviceEventEmitter.addListener('Gyroscope', function (data) {
		callback(data.x, data.y, data.z);
	}
	);
	return gyroHandler;
}
