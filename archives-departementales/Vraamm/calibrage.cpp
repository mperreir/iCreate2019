#include <opencv2/opencv.hpp>
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <fstream>


/*
	ce programme sert à faire la le mappage des différentes zones au début en dur
*/

int main()
{
	//Open the default video camera
	cv::VideoCapture cam1(1);
	cv::VideoCapture cam2(2);

	// if not success, exit program
	if (cam1.isOpened() == false)
	{
		std::cout << "Cannot open the video camera 1" << std::endl;
		std::cin.get(); //wait for any key press
		return -1;
	}
	if (cam2.isOpened() == false)
	{
		std::cout << "Cannot open the video camera 2" << std::endl;
		std::cin.get(); //wait for any key press
		return -1;
	}

	cam1.set(cv::CAP_PROP_FRAME_WIDTH, 1280);
	cam1.set(cv::CAP_PROP_FRAME_HEIGHT, 720);

	cam2.set(cv::CAP_PROP_FRAME_WIDTH, 1280);
	cam2.set(cv::CAP_PROP_FRAME_HEIGHT, 720);

	//calibrage cam 1

	int iWidth = cam1.get(cv::CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
	int iHeight = cam1.get(cv::CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video

	std::string winName = "Calibrage camera 1 : " + std::to_string(iWidth) + " x " + std::to_string(iHeight);

	cv::namedWindow(winName, cv::WINDOW_NORMAL); //create a window named winName

	cam1.set(cv::CAP_PROP_AUTO_EXPOSURE, 0);
	cam1.set(cv::CAP_PROP_AUTO_WB, 0);

	int iGain1 = cam1.get(cv::CAP_PROP_GAIN);
	int iExposure1 = cam1.get(cv::CAP_PROP_EXPOSURE);
	int iMirrored1 = false;

	//Zone 1
	int iLowH1Zone1 = 0;
	int iHighH1Zone1 = 179;

	int iLowS1Zone1 = 0;
	int iHighS1Zone1 = 255;

	int iLowV1Zone1 = 0;
	int iHighV1Zone1 = 255;
	//Zone 2
	int iLowH1Zone2 = 0;
	int iHighH1Zone2 = 179;

	int iLowS1Zone2 = 0;
	int iHighS1Zone2 = 255;

	int iLowV1Zone2 = 0;
	int iHighV1Zone2 = 255;
	//Zone 3
	int iLowH1Zone3 = 0;
	int iHighH1Zone3 = 179;

	int iLowS1Zone3 = 0;
	int iHighS1Zone3 = 255;

	int iLowV1Zone3 = 0;
	int iHighV1Zone3 = 255;

	//Create trackbars in winName window
	cv::createTrackbar("LowH Zone 1", winName, &iLowH1Zone1, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 1", winName, &iHighH1Zone1, 179);

	cv::createTrackbar("LowS Zone 1", winName, &iLowS1Zone1, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 1", winName, &iHighS1Zone1, 255);

	cv::createTrackbar("LowV Zone 1", winName, &iLowV1Zone1, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 1", winName, &iHighV1Zone1, 255);


	cv::createTrackbar("LowH Zone 2", winName, &iLowH1Zone2, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 2", winName, &iHighH1Zone2, 179);

	cv::createTrackbar("LowS Zone 2", winName, &iLowS1Zone2, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 2", winName, &iHighS1Zone2, 255);

	cv::createTrackbar("LowV Zone 2", winName, &iLowV1Zone2, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 2", winName, &iHighV1Zone2, 255);

	cv::createTrackbar("LowH Zone 3", winName, &iLowH1Zone3, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 3", winName, &iHighH1Zone3, 179);

	cv::createTrackbar("LowS Zone 3", winName, &iLowS1Zone3, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 3", winName, &iHighS1Zone3, 255);

	cv::createTrackbar("LowV Zone 3", winName, &iLowV1Zone3, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 3", winName, &iHighV1Zone3, 255);

	cv::createTrackbar("Gain", winName, &iGain1, 255, [](int gain, void *cam1) {static_cast<cv::VideoCapture*>(cam1)->set(cv::CAP_PROP_GAIN, gain); }, &cam1);
	cv::createTrackbar("Exposure", winName, &iExposure1, 255, [](int exposure, void *cam1) {static_cast<cv::VideoCapture*>(cam1)->set(cv::CAP_PROP_EXPOSURE, exposure); }, &cam1);
	cv::createTrackbar("Mirrored", winName, &iMirrored1, 1);

	cv::Mat cam1Zone1, cam1Zone2, cam1Zone3;

	while (true)
	{
		cv::Mat imgOriginal;

		bool bSuccess = cam1.read(imgOriginal); // read a new frame from video
		if (iMirrored1)
			cv::flip(imgOriginal, imgOriginal, 1);

		if (!bSuccess) //if not success, break loop
		{
			std::cout << "Cannot read a frame from video stream" << std::endl;
			break;
		}

		cv::Mat imgHSV;

		cv::cvtColor(imgOriginal, imgHSV, cv::COLOR_BGR2HSV); //Convert the captured frame from BGR to HSV

		cv::Mat imgThresholdedZone1;
		cv::Mat imgThresholdedZone2;
		cv::Mat imgThresholdedZone3;

		cv::inRange(imgHSV, cv::Scalar(iLowH1Zone1, iLowS1Zone1, iLowV1Zone1), cv::Scalar(iHighH1Zone1, iHighS1Zone1, iHighV1Zone1), imgThresholdedZone1); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		cv::inRange(imgHSV, cv::Scalar(iLowH1Zone2, iLowS1Zone2, iLowV1Zone2), cv::Scalar(iHighH1Zone2, iHighS1Zone2, iHighV1Zone2), imgThresholdedZone2); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		cv::inRange(imgHSV, cv::Scalar(iLowH1Zone3, iLowS1Zone3, iLowV1Zone3), cv::Scalar(iHighH1Zone3, iHighS1Zone3, iHighV1Zone3), imgThresholdedZone3); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));


		cv::imshow("Zone 1", imgThresholdedZone1); //show the thresholded image zone 1
		cv::imshow("Zone 2", imgThresholdedZone2); //show the thresholded image zone 2 
		cv::imshow("Zone 3", imgThresholdedZone3); //show the thresholded image zone 3
		cv::imshow("Original", imgOriginal); //show the original image

		int key = cv::waitKey(30);

		if (key == 27) //wait for 'esc' key press for 30ms. If 'esc' key is pressed, break loop
		{
			std::cout << "esc key is pressed by user" << std::endl;
			cv::destroyAllWindows();
			break;
		}
		else if (key == 13) //'enter'
		{
			std::cout << "calibration validated" << std::endl;
			cv::destroyAllWindows();
			cam1Zone1=imgThresholdedZone1;
			cam1Zone2=imgThresholdedZone2;
			cam1Zone3=imgThresholdedZone3;
			break;
		}
	}
	cam1.release();


	//calibrage cam 2

	iWidth = cam2.get(cv::CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
	iHeight = cam2.get(cv::CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video

	winName = "Calibrage camera 2 : " + std::to_string(iWidth) + " x " + std::to_string(iHeight);

	cv::namedWindow(winName, cv::WINDOW_NORMAL); //create a window named winName

	cam2.set(cv::CAP_PROP_AUTO_EXPOSURE, 0);
	cam2.set(cv::CAP_PROP_AUTO_WB, 0);

	int iGain2 = cam2.get(cv::CAP_PROP_GAIN);
	int iExposure2 = cam2.get(cv::CAP_PROP_EXPOSURE);
	int iMirrored2 = false;

	//Zone 1
	int iLowH2Zone1 = 0;
	int iHighH2Zone1 = 179;

	int iLowS2Zone1 = 0;
	int iHighS2Zone1 = 255;

	int iLowV2Zone1 = 0;
	int iHighV2Zone1 = 255;
	//Zone 2
	int iLowH2Zone2 = 0;
	int iHighH2Zone2 = 179;

	int iLowS2Zone2 = 0;
	int iHighS2Zone2 = 255;

	int iLowV2Zone2 = 0;
	int iHighV2Zone2 = 255;
	//Zone 3
	int iLowH2Zone3 = 0;
	int iHighH2Zone3 = 179;

	int iLowS2Zone3 = 0;
	int iHighS2Zone3 = 255;

	int iLowV2Zone3 = 0;
	int iHighV2Zone3 = 255;

	//Create trackbars in winName window
	cv::createTrackbar("LowH Zone 1", winName, &iLowH2Zone1, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 1", winName, &iHighH2Zone1, 179);

	cv::createTrackbar("LowS Zone 1", winName, &iLowS2Zone1, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 1", winName, &iHighS2Zone1, 255);

	cv::createTrackbar("LowV Zone 1", winName, &iLowV2Zone1, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 1", winName, &iHighV2Zone1, 255);


	cv::createTrackbar("LowH Zone 2", winName, &iLowH2Zone2, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 2", winName, &iHighH2Zone2, 179);

	cv::createTrackbar("LowS Zone 2", winName, &iLowS2Zone2, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 2", winName, &iHighS2Zone2, 255);

	cv::createTrackbar("LowV Zone 2", winName, &iLowV2Zone2, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 2", winName, &iHighV2Zone2, 255);

	cv::createTrackbar("LowH Zone 3", winName, &iLowH2Zone3, 179); //Hue (0 - 179)
	cv::createTrackbar("HighH Zone 3", winName, &iHighH2Zone3, 179);

	cv::createTrackbar("LowS Zone 3", winName, &iLowS2Zone3, 255); //Saturation (0 - 255)
	cv::createTrackbar("HighS Zone 3", winName, &iHighS2Zone3, 255);

	cv::createTrackbar("LowV Zone 3", winName, &iLowV2Zone3, 255); //Value (0 - 255)
	cv::createTrackbar("HighV Zone 3", winName, &iHighV2Zone3, 255);

	cv::createTrackbar("Gain", winName, &iGain2, 255, [](int gain, void *cam2) {static_cast<cv::VideoCapture*>(cam2)->set(cv::CAP_PROP_GAIN, gain); }, &cam2);
	cv::createTrackbar("Exposure", winName, &iExposure2, 255, [](int exposure, void *cam2) {static_cast<cv::VideoCapture*>(cam2)->set(cv::CAP_PROP_EXPOSURE, exposure); }, &cam2);
	cv::createTrackbar("Mirrored", winName, &iMirrored2, 1);

	cv::Mat cam2Zone1, cam2Zone2, cam2Zone3;

	while (true)
	{
		cv::Mat imgOriginal;

		bool bSuccess = cam2.read(imgOriginal); // read a new frame from video
		if (iMirrored1)
			cv::flip(imgOriginal, imgOriginal, 1);

		if (!bSuccess) //if not success, break loop
		{
			std::cout << "Cannot read a frame from video stream" << std::endl;
			break;
		}

		cv::Mat imgHSV;

		cv::cvtColor(imgOriginal, imgHSV, cv::COLOR_BGR2HSV); //Convert the captured frame from BGR to HSV

		cv::Mat imgThresholdedZone1;
		cv::Mat imgThresholdedZone2;
		cv::Mat imgThresholdedZone3;

		cv::inRange(imgHSV, cv::Scalar(iLowH2Zone1, iLowS2Zone1, iLowV2Zone1), cv::Scalar(iHighH2Zone1, iHighS2Zone1, iHighV2Zone1), imgThresholdedZone1); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone1, imgThresholdedZone1, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		cv::inRange(imgHSV, cv::Scalar(iLowH2Zone2, iLowS2Zone2, iLowV2Zone2), cv::Scalar(iHighH2Zone2, iHighS2Zone2, iHighV2Zone2), imgThresholdedZone2); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone2, imgThresholdedZone2, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		cv::inRange(imgHSV, cv::Scalar(iLowH2Zone3, iLowS2Zone3, iLowV2Zone3), cv::Scalar(iHighH2Zone3, iHighS2Zone3, iHighV2Zone3), imgThresholdedZone3); //Threshold the image

		//morphological opening (remove small objects from the foreground)
		cv::erode(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::dilate(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));

		//morphological closing (fill small holes in the foreground)
		cv::dilate(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));
		cv::erode(imgThresholdedZone3, imgThresholdedZone3, cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5)));


		cv::imshow("Zone 1", imgThresholdedZone1); //show the thresholded image zone 1
		cv::imshow("Zone 2", imgThresholdedZone2); //show the thresholded image zone 2 
		cv::imshow("Zone 3", imgThresholdedZone3); //show the thresholded image zone 3
		cv::imshow("Original", imgOriginal); //show the original image

		int key = cv::waitKey(30);

		if (key == 27) //wait for 'esc' key press for 30ms. If 'esc' key is pressed, break loop
		{
			std::cout << "esc key is pressed by user" << std::endl;
			cv::destroyAllWindows();
			break;
		}
		else if (key == 13)
		{
			std::cout << "calibration validated" << std::endl;
			cv::destroyAllWindows();
			cam2Zone1=imgThresholdedZone1;
			cam2Zone2=imgThresholdedZone2;
			cam2Zone3=imgThresholdedZone3;
			break;
		}
	}
	cam2.release();

	std::ofstream file;
	file.open("cam1Zone1.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam1Zone1.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();
	file.open("cam1Zone2.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam1Zone2.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();
	file.open("cam1Zone3.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam1Zone3.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();

	file.open("cam2Zone1.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam2Zone1.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();
	file.open("cam2Zone2.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam2Zone2.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();
	file.open("cam2Zone3.txt");
	for(int i=0;i<720;i++)
	{
		for(int j=0; j<1280; j++)
		{
			file<<cam2Zone3.at<bool>(i,j)<<std::endl;
		}
	}
	file.close();
	
	return 0;
}