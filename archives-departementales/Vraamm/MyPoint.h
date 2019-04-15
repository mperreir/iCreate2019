#pragma once
class MyPoint {
private:
	int id;
	int sid;
	float x;
	float y;
public:
	MyPoint(int a, int b, float c, float d) {
		id = a;
		sid = b;
		x = c;
		y = d;
	}
	int getID() {
		return id;
	}
	int getSID() {
		return sid;
	}
	float getX() {
		return x;
	}
	float getY() {
		return y;
	}
	void setX(float a) {
		x = a;
	}
	void setY(float a) {
		y = a;
	}
	void printPoint() {
		std::cout << "id = " << id << " sid = " << sid << " x = " << x << " y = " << y << std::endl;
	}
};