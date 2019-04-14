#pragma once
#include "TuioListener.h"
#include "TuioClient.h"
#include "UdpReceiver.h"
#include "TcpReceiver.h"
#include <math.h>
//#include<unistd.h>
#include "MyPoint.h"
#include<vector>

class TuioPion : public TUIO::TuioListener
{
public:
	TuioPion();
	~TuioPion();

	void addTuioObject(TUIO::TuioObject *tobj);
	void updateTuioObject(TUIO::TuioObject *tobj);
	void removeTuioObject(TUIO::TuioObject *tobj);

	void addTuioCursor(TUIO::TuioCursor *tcur);
	void updateTuioCursor(TUIO::TuioCursor *tcur);
	void removeTuioCursor(TUIO::TuioCursor *tcur);

	void addTuioBlob(TUIO::TuioBlob *tblb);
	void updateTuioBlob(TUIO::TuioBlob *tblb);
	void removeTuioBlob(TUIO::TuioBlob *tblb);

	void refresh(TUIO::TuioTime frameTime);
};

