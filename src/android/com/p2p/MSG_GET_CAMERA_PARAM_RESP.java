package com.p2p;

public class MSG_GET_CAMERA_PARAM_RESP {
	public  final int MY_LEN = 56;
	public  int nResolution; 	// 0->160*120, 1->320*240, 2->640*480,
								// 3->640*360,
								// 4->1280*720, 5->1280*960
	public  int nBright; 		// [0,255]
	public  int nContrast; 		// [0,7]
	public  int reserve1;
	public  int nSaturation; 	// [0,255]
	public  int bOSD; 			// 0->disable, 1->enable
	public  int nMode; 			// 0->50Hz, 1->60Hz
	public  int nFlip; 			// 0->normal, 1->flip, 2->mirror, 3->flip & mirror
	public  byte[] reserve2 = new byte[8];
	public  byte[] nIRLed = new byte[1]; 	// 0->close, 1->open, 2->auto
											// support getting
											// its value when FirmwareVer>=0.1.0.18
	public  byte[] reserve3 = new byte[15];	
	public  byte[] nResolution_byte;
	public  byte[] nBright_byte;
	public  byte[] nContrast_byte;
	public  byte[] nSaturation_byte;
	public  byte[] bOSD_byte;
	public  byte[] nMode_byte;
	public  byte[] nFlip_byte;

	public  MSG_GET_CAMERA_PARAM_RESP(byte[] data) {
		nResolution_byte = new byte[4];
		nBright_byte = new byte[4];
		nContrast_byte = new byte[4];
		nSaturation_byte = new byte[4];
		bOSD_byte = new byte[4];
		nMode_byte = new byte[4];
		nFlip_byte = new byte[4];
		nIRLed = new byte[1];

		System.arraycopy(data, 0, nResolution_byte, 0, nResolution_byte.length);
		System.arraycopy(data, 4, nBright_byte, 0, nBright_byte.length);
		System.arraycopy(data, 8, nContrast_byte, 0, nContrast_byte.length);
		System.arraycopy(data, 16, nSaturation_byte, 0, nSaturation_byte.length);
		System.arraycopy(data, 20, bOSD_byte, 0, bOSD_byte.length);
		System.arraycopy(data, 24, nMode_byte, 0, nMode_byte.length);
		System.arraycopy(data, 28, nFlip_byte,0, nFlip_byte.length);

		data[40] = nIRLed[0];
	}

	public int getnResolution() {
		return Convert.byteArrayToInt_Little(nResolution_byte);
	}

	public void setnResolution(int nResolution) {
		this.nResolution = nResolution;
	}

	public int getnBright() {
		return Convert.byteArrayToInt_Little(nBright_byte);
	}

	public void setnBright(int nBright) {
		this.nBright = nBright;
	}

	public int getnContrast() {
		return Convert.byteArrayToInt_Little(nContrast_byte);
	}

	public void setnContrast(int nContrast) {
		this.nContrast = nContrast;
	}

	public int getnSaturation() {
		return Convert.byteArrayToInt_Little(nSaturation_byte);
	}

	public void setnSaturation(int nSaturation) {
		this.nSaturation = nSaturation;
	}

	public int getbOSD() {
		return Convert.byteArrayToInt_Little(bOSD_byte);
	}

	public void setbOSD(int bOSD) {
		this.bOSD = bOSD;
	}

	public int getnMode() {
		return Convert.byteArrayToInt_Little(nMode_byte);

	}

	public void setnMode(int nMode) {
		this.nMode = nMode;
	}

	public int getnFlip() {
		return Convert.byteArrayToInt_Little(nFlip_byte);
	}

	public void setnFlip(int nFlip) {
		this.nFlip = nFlip;
	}

	public byte[] getnIRLed() {
		return nIRLed;
	}

	public void setnIRLed(byte[] nIRLed) {
		this.nIRLed = nIRLed;
	}

}
