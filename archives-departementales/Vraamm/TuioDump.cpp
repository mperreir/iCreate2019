#include "TuioDump.h"
#define WIN32
#include <iostream>
#include <al.h>
#include <alc.h>
#include <string>
#include <vector>
#include <sndfile.h>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <fstream>

#include "TuioPion.h"

void newZones(std::vector<int> &zone1, std::vector<int> &zone2, std::vector<int> &zone3, TUIO::TuioClient &client, int** matZone1, int** matZone2, int** matZone3, int camNumber)
{
	std::vector<TUIO::TuioObject*> objects;
	for (int i = 0; i < objects.size(); i++)
	{
		int temp(objects.at(i)->getSymbolID());
		if (matZone1[int(objects.at(i)->getX() * 1280)][int(objects.at(i)->getY() * 720)])
		{
			zone1.push_back(temp);
		}
		else if (matZone2[int(objects.at(i)->getX() * 1280)][int(objects.at(i)->getY() * 720)])
		{
			zone2.push_back(temp);
		}
		else if (matZone3[int(objects.at(i)->getX() * 1280)][int(objects.at(i)->getY() * 720)])
		{
			zone3.push_back(temp);
		}
	}
}

void concatZones(std::vector<int> &zoneA, std::vector<int> &zoneB)
{

	for (auto it = zoneB.begin(); it != zoneB.end(); it++)
	{
		auto it2 = std::find(zoneA.begin(), zoneA.end(), *it);
		if (it2 == zoneA.end())
		{
			zoneA.push_back(*it2);
		}

	}

}

void diffZones(std::vector<int> &oldZone, std::vector<int> &newZone, std::vector<int> &add, std::vector<int> &del)
{
	for (auto it = oldZone.begin(); it != oldZone.end(); it++)
	{
		auto it2 = std::find(newZone.begin(), newZone.end(), *it);
		if (it2 == newZone.end())
		{
			del.push_back(*it2);
		}

	}

	for (auto it = newZone.begin(); it != newZone.end(); it++)
	{
		auto it2 = std::find(oldZone.begin(), oldZone.end(), *it);
		if (it2 == oldZone.end())
		{
			add.push_back(*it2);
		}

	}
}

bool InitOpenAL()
{
	// Ouverture du device
	ALCdevice* device = alcOpenDevice("Generic Software");
	if (!device)
		return false;

	// Création du contexte
	ALCcontext* context = alcCreateContext(device, NULL);
	if (!context)
		return false;

	// Activation du contexte
	if (!alcMakeContextCurrent(context))
		return false;

	return true;
}

void GetDevices(std::vector<std::string>& devices)
{
	// Vidage de la liste
	devices.clear();

	// Récupération des devices disponibles
	const ALCchar* deviceList = alcGetString(NULL, ALC_DEVICE_SPECIFIER);

	if (deviceList)
	{
		// Extraction des devices contenus dans la chaîne renvoyée
		while (strlen(deviceList) > 0)
		{
			devices.push_back(deviceList);
			deviceList += strlen(deviceList) + 1;
		}
	}
}

void ShutdownOpenAL()
{
	// Récupération du contexte et du device
	ALCcontext* context = alcGetCurrentContext();
	ALCdevice*  device = alcGetContextsDevice(context);

	// Désactivation du contexte
	alcMakeContextCurrent(NULL);

	// Destruction du contexte
	alcDestroyContext(context);

	// Fermeture du device
	alcCloseDevice(device);
}

ALuint LoadSound(const std::string& filename)
{
	// Ouverture du fichier audio avec libsndfile
	SF_INFO fileInfos;
	SNDFILE* file = sf_open(filename.c_str(), SFM_READ, &fileInfos);
	if (!file)
		return 0;

	// Lecture du nombre d'échantillons et du taux d'échantillonnage (nombre d'échantillons à lire par seconde)
	ALsizei nbSamples = static_cast<ALsizei>(fileInfos.channels * fileInfos.frames);
	ALsizei sampleRate = static_cast<ALsizei>(fileInfos.samplerate);

	// Lecture des échantillons audios au format entier 16 bits signé (le plus commun)
	std::vector<ALshort> samples(nbSamples);
	if (sf_read_short(file, &samples[0], nbSamples) < nbSamples)
		return 0;

	// Fermeture du fichier
	sf_close(file);

	// Détermination du format en fonction du nombre de canaux
	ALenum format;
	switch (fileInfos.channels)
	{
	case 1:  format = AL_FORMAT_MONO16;   break;
	case 2:  format = AL_FORMAT_STEREO16; break;
	default: return 0;
	}

	// Création du tampon OpenAL
	ALuint buffer;
	alGenBuffers(1, &buffer);

	// Remplissage avec les échantillons lus
	alBufferData(buffer, format, &samples[0], nbSamples * sizeof(ALushort), sampleRate);

	// Vérification des erreurs
	if (alGetError() != AL_NO_ERROR)
		return 0;

	return buffer;
}

void playNantesUrbain(ALuint source)
{
	ALuint buffer = LoadSound("Pistes\\Nantes.-S1.-Ilot-urbain.wav");

	// On attache le tampon contenant les échantillons audios à la source
	alSourcei(source, AL_BUFFER, buffer);

	float movement = 0;

	// Lecture du son
	alSourcePlay(source);

	ALint status;

	ALfloat seconds = 0.f;

	do
	{
		// Récupération de l'état du son
		alGetSourcei(source, AL_SOURCE_STATE, &status);

		alGetSourcef(source, AL_SEC_OFFSET, &seconds);

		if (6 < seconds && seconds < 20)
		{
			movement += 0.0001;
			alSource3f(source, AL_POSITION, 0.f, 0.f, movement);
		}
		else
		{
			alSource3f(source, AL_POSITION, 0.f, 0.f, 0.f);
		}

	} while (status == AL_PLAYING);

	// Destruction du tampon
	alDeleteBuffers(1, &buffer);
}

void playAutourUrbain(ALuint source)
{
	ALuint buffer = LoadSound("Pistes\\Autour.-S1.-Ilot-urbain.wav");

	// On attache le tampon contenant les échantillons audios à la source
	alSourcei(source, AL_BUFFER, buffer);

	float movement = 0;

	// Lecture du son
	alSourcePlay(source);

	ALint status;

	ALfloat seconds = 0.f;

	do
	{
		// Récupération de l'état du son
		alGetSourcei(source, AL_SOURCE_STATE, &status);

		alGetSourcef(source, AL_SEC_OFFSET, &seconds);

		if (5 < seconds && seconds < 22)
		{
			movement += 0.0001;
			alSource3f(source, AL_POSITION, 0.f, 0.f, movement);
		}
		else
		{
			alSource3f(source, AL_POSITION, 0.f, 0.f, 0.f);
		}

	} while (status == AL_PLAYING);

	// Destruction du tampon
	alDeleteBuffers(1, &buffer);
}

void playLittoralUrbain(ALuint source)
{
	ALuint buffer = LoadSound("Pistes\\Littoral.-S1.-Ilot-urbain.wav");

	// On attache le tampon contenant les échantillons audios à la source
	alSourcei(source, AL_BUFFER, buffer);

	float movement = 0;

	// Lecture du son
	alSourcePlay(source);

	ALint status;

	ALfloat seconds = 0.f;

	do
	{
		// Récupération de l'état du son
		alGetSourcei(source, AL_SOURCE_STATE, &status);

		alGetSourcef(source, AL_SEC_OFFSET, &seconds);

		if (5 < seconds && seconds < 22)
		{
			movement += 0.0001;
			alSource3f(source, AL_POSITION, 0.f, 0.f, movement);
		}
		else
		{
			alSource3f(source, AL_POSITION, 0.f, 0.f, 0.f);
		}

	} while (status == AL_PLAYING);

	// Destruction du tampon
	alDeleteBuffers(1, &buffer);
}

void playLittoralMaisonHameau(ALuint source)
{
	ALuint buffer = LoadSound("Pistes\\Littoral.-S2-et-S3-maison-et-hameau.wav");

	// On attache le tampon contenant les échantillons audios à la source
	alSourcei(source, AL_BUFFER, buffer);

	// Lecture du son
	alSourcePlay(source);

	ALint status;
	do
	{
		// Récupération de l'état du son
		alGetSourcei(source, AL_SOURCE_STATE, &status);

	} while (status == AL_PLAYING);

	// Destruction du tampon
	alDeleteBuffers(1, &buffer);

}

void playNantesAutourMaisonHameau(ALuint source)
{
	ALuint buffer = LoadSound("Pistes\\Nantes.-S2-et-S3.-Maison-et-hameau.wav");

	// On attache le tampon contenant les échantillons audios à la source
	alSourcei(source, AL_BUFFER, buffer);

	// Lecture du son
	alSourcePlay(source);

	ALint status;
	do
	{
		// Récupération de l'état du son
		alGetSourcei(source, AL_SOURCE_STATE, &status);

	} while (status == AL_PLAYING);

	// Destruction du tampon
	alDeleteBuffers(1, &buffer);
}

void play(std::string s)
{

	// Création d'une source
	ALuint source;
	alGenSources(1, &source);

	// Définition de la position de l'écouteur (ici l'origine)
	alListener3f(AL_POSITION, 0.f, 0.f, 0.f);

	// Définition de la vitesse de l'écouteur (ici nulle)
	alListener3f(AL_VELOCITY, 0.f, 0.f, 0.f);

	// Définition de l'orientation de l'écouteur (ici il regarde vers l'axe des Z soit vers l'avant)
	ALfloat Orientation[] = { 0.f, 0.f, 1.f, 0.f, 1.f, 0.f };
	alListenerfv(AL_ORIENTATION, Orientation);

	// Définition de l'angle d'émission de la source, ici étant de 360°
	alSourcef(source, AL_CONE_INNER_ANGLE, 360.f);

	// Définition initiale de la position de la source 
	alSource3f(source, AL_POSITION, 0.f, 0.f, 0.f);

	if (s == "nantes-ilot urbain")
		playNantesUrbain(source);

	if (s == "autour-ilot urbain")
		playAutourUrbain(source);

	if (s == "littoral-ilot urbain")
		playLittoralUrbain(source);

	if (s == "nantes-maison" || s == "nantes-hameau" || s == "autour-maison" || s == "autour-hameau")
		playNantesAutourMaisonHameau(source);

	if (s == "littoral-hameau" || s == "littoral-maison")
		playLittoralMaisonHameau(source);

	// Destruction de la source
	alSourcei(source, AL_BUFFER, 0);
	alDeleteSources(1, &source);
}


TuioDump::TuioDump(int port)
{
	size = 0;
	oscReceiver = new UdpReceiver(port);
	tuioClient = new TuioClient(oscReceiver);
	tuioClient->addTuioListener(this);
	tuioClient->connect();
	if (tuioClient->isConnected()) {
		std::cout << "success!" << std::endl;
	}
}

void TuioDump::addTuioObject(TuioObject *tobj) {
	size++;
	MyPoint *point = new MyPoint(tobj->getSymbolID(), tobj->getSessionID(), tobj->getX(), tobj->getY());
	objectList.push_back(point);
	//std::cout << "add obj " << tobj->getSymbolID() << " (" << tobj->getSessionID() << "/"<<  tobj->getTuioSourceID() << ") "<< tobj->getX() << " " << tobj->getY() << " " << tobj->getAngle() << std::endl;
}

void TuioDump::updateTuioObject(TuioObject *tobj) {
	std::vector<MyPoint*>::iterator iter = objectList.begin();
	for (; iter < objectList.end(); iter++) {
		if ((*iter)->getID() == tobj->getSymbolID() && (*iter)->getSID() == tobj->getSessionID()) {
			(*iter)->setX(tobj->getX());
			(*iter)->setY(tobj->getY());
		}
	}
	//std::cout << "set obj " << tobj->getSymbolID() << " (" << tobj->getSessionID() << "/"<<  tobj->getTuioSourceID() << ") "<< tobj->getX() << " " << tobj->getY() << " " << tobj->getAngle() 
				//<< " " << tobj->getMotionSpeed() << " " << tobj->getRotationSpeed() << " " << tobj->getMotionAccel() << " " << tobj->getRotationAccel() << std::endl;
}

void TuioDump::removeTuioObject(TuioObject *tobj) {
	size--;
	std::vector<MyPoint*>::iterator iter = objectList.begin();
	for (; iter < objectList.end();) {
		if ((*iter)->getID() == tobj->getSymbolID() && (*iter)->getSID() == tobj->getSessionID()) {
			iter = objectList.erase(iter);
		}
		else {
			++iter;
		}
	}
	//std::cout << "del obj " << tobj->getSymbolID() << " (" << tobj->getSessionID() << "/"<<  tobj->getTuioSourceID() << ")" << std::endl;
}

void TuioDump::addTuioCursor(TuioCursor *tcur) {
	std::cout << "add cur " << tcur->getCursorID() << " (" << tcur->getSessionID() << "/" << tcur->getTuioSourceID() << ") " << tcur->getX() << " " << tcur->getY() << std::endl;
}

void TuioDump::updateTuioCursor(TuioCursor *tcur) {
	std::cout << "set cur " << tcur->getCursorID() << " (" << tcur->getSessionID() << "/" << tcur->getTuioSourceID() << ") " << tcur->getX() << " " << tcur->getY()
		<< " " << tcur->getMotionSpeed() << " " << tcur->getMotionAccel() << " " << std::endl;
}

void TuioDump::removeTuioCursor(TuioCursor *tcur) {
	std::cout << "del cur " << tcur->getCursorID() << " (" << tcur->getSessionID() << "/" << tcur->getTuioSourceID() << ")" << std::endl;
}

void TuioDump::addTuioBlob(TuioBlob *tblb) {
	std::cout << "add blb " << tblb->getBlobID() << " (" << tblb->getSessionID() << "/" << tblb->getTuioSourceID() << ") " << tblb->getX() << " " << tblb->getY() << " " << tblb->getAngle() << " " << tblb->getWidth() << " " << tblb->getHeight() << " " << tblb->getArea() << std::endl;
}

void TuioDump::updateTuioBlob(TuioBlob *tblb) {
	std::cout << "set blb " << tblb->getBlobID() << " (" << tblb->getSessionID() << "/" << tblb->getTuioSourceID() << ") " << tblb->getX() << " " << tblb->getY() << " " << tblb->getAngle() << " " << tblb->getWidth() << " " << tblb->getHeight() << " " << tblb->getArea()
		<< " " << tblb->getMotionSpeed() << " " << tblb->getRotationSpeed() << " " << tblb->getMotionAccel() << " " << tblb->getRotationAccel() << std::endl;
}

void TuioDump::removeTuioBlob(TuioBlob *tblb) {
	std::cout << "del blb " << tblb->getBlobID() << " (" << tblb->getSessionID() << "/" << tblb->getTuioSourceID() << ")" << std::endl;
}

void  TuioDump::refresh(TuioTime frameTime) {
	//std::cout << "refresh " << frameTime.getTotalMilliseconds() << std::endl;
}

std::vector<MyPoint*> TuioDump::getList()
{
	return objectList;
}

int TuioDump::getSize()
{
	return size;
}


int main()
{
	int** cam1Zone1 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam1Zone1[i] = new int[720];
	}
	int** cam1Zone2 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam1Zone2[i] = new int[720];
	}
	int** cam1Zone3 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam1Zone3[i] = new int[720];
	}
	int** cam2Zone1 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam2Zone1[i] = new int[720];
	}
	int** cam2Zone2 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam2Zone2[i] = new int[720];
	}
	int** cam2Zone3 = new int*[1280];
	for (int i = 0; i < 1280; i++)
	{
		cam2Zone3[i] = new int[720];
	}

	std::ifstream file;
	file.open("cam1Zone1.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam1Zone1[j][i];
		}
	}
	file.close();
	file.open("cam1Zone2.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam1Zone2[j][i];
		}
	}
	file.close();
	file.open("cam1Zone3.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam1Zone3[j][i];
		}
	}
	file.close();

	file.open("cam2Zone1.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam2Zone1[j][i];
		}
	}
	file.close();
	file.open("cam2Zone2.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam2Zone2[j][i];
		}
	}
	file.close();
	file.open("cam2Zone3.txt");
	for (int i = 0; i < 720; i++)
	{
		for (int j = 0; j < 1280; j++)
		{
			file >> cam2Zone3[j][i];
		}
	}
	file.close();
	InitOpenAL();

	std::cout << "launch both reactivision clients, then press Enter (wait for reactivison clients to be fully launched)" << std::endl;
	std::cin.get();

	std::vector<int> zone1, zone2, zone3; //id_symbole


	TuioPion pion1;
	TUIO::OscReceiver *receiver1;
	receiver1 = new TUIO::UdpReceiver(3334);
	TUIO::TuioClient client1(receiver1);
	client1.addTuioListener(&pion1);
	client1.connect(true);

	TuioPion pion2;
	TUIO::OscReceiver *receiver2;
	receiver2 = new TUIO::UdpReceiver(3333);
	TUIO::TuioClient client2(receiver2);
	client2.addTuioListener(&pion2);
	client2.connect(true);

	std::map<int, std::string> batiments;
	batiments[4] = "ilot urbain";
	batiments[5] = "maison";
	batiments[6] = "hameau";

	while (true)
	{
		std::cin.get();
		{
			std::vector<int> cam1NewZone1, cam1NewZone2, cam1NewZone3, cam2NewZone1, cam2NewZone2, cam2NewZone3;
			newZones(cam1NewZone1, cam1NewZone2, cam1NewZone3, client1, (int**)cam1Zone1, (int**)cam1Zone2, (int**)cam1Zone3, 1);
			newZones(cam2NewZone1, cam2NewZone2, cam2NewZone3, client2, (int**)cam2Zone1, (int**)cam2Zone2, (int**)cam2Zone3, 2);
			concatZones(cam1NewZone1, cam2NewZone1);
			concatZones(cam1NewZone2, cam2NewZone2);
			concatZones(cam1NewZone3, cam2NewZone3);
			std::vector<int> addZone1, delZone1, addZone2, delZone2, addZone3, delZone3;//id_symbole
			diffZones(zone1, cam1NewZone1, addZone1, delZone1);
			diffZones(zone2, cam1NewZone2, addZone2, delZone2);
			diffZones(zone3, cam1NewZone3, addZone3, delZone3);

			for (int i = 0; i < addZone1.size(); i++)
			{
				play("nantes-" + batiments[addZone1.at(i)]);
			}
			for (int i = 0; i < addZone2.size(); i++)
			{
				play("autour-" + batiments[addZone2.at(i)]);
			}
			for (int i = 0; i < addZone3.size(); i++)
			{
				play("littoral-" + batiments[addZone3.at(i)]);
			}
		}
	}


	delete receiver1;
	delete receiver2;


	ShutdownOpenAL();

	return 0;
}

