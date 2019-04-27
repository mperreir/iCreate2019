#include "TuioListener.h"
#include "TuioClient.h"
#include "UdpReceiver.h"
#include "TcpReceiver.h"
#include <math.h>
//#include<unistd.h>
#include"MyPoint.h"
#include<vector>

using namespace TUIO;

class TuioDump : public TuioListener {
	
	public:
		TuioDump(int port);
		~TuioDump()
		{
			tuioClient->disconnect();
			delete tuioClient;
			delete oscReceiver;
		}
		void addTuioObject(TuioObject *tobj);
		void updateTuioObject(TuioObject *tobj);
		void removeTuioObject(TuioObject *tobj);

		void addTuioCursor(TuioCursor *tcur);
		void updateTuioCursor(TuioCursor *tcur);
		void removeTuioCursor(TuioCursor *tcur);

		void addTuioBlob(TuioBlob *tblb);
		void updateTuioBlob(TuioBlob *tblb);
		void removeTuioBlob(TuioBlob *tblb);

		void refresh(TuioTime frameTime);

		std::vector<MyPoint*> getList();
		int getSize();
private:
	OscReceiver *oscReceiver;
	TuioClient *tuioClient;
	std::vector<MyPoint*> objectList;
	int size;
};

