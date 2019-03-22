from SerialInput import SerialInput

if __name__ == "__main__":
    serialInput = SerialInput("/dev/cu.usbmodem141401")
    serialInput.start()
