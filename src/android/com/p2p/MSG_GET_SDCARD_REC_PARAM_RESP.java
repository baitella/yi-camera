package com.p2p;

public class MSG_GET_SDCARD_REC_PARAM_RESP {

	    int bRecordCoverInSDCard; //0->disable record in sd-card; 1->enable record in sd-card 
	    int nRecordTimeLen; //record time length, in minutes 
	    int reserve1; 
	    int bRecordTime; //0->disable 1->enable 
	    byte[] reserve2 = new byte[84]; 
	    int nSDCardStatus; //0: no sdcard; 1: sdcard inserted 
	    int nSDTotalSpace; //in MBytes 
	    int nSDFreeSpace; //in MBytes 
	    
	    byte[] byt_recordCoverInSDCard = new byte[4];
	    byte[] byt_nrecordtimelen = new byte[4];
	    byte[] byt_brecordtime = new byte[4];
	    byte[] byt_nsdcardstatus = new byte[4];
	    byte[] byt_nsdtotalspace = new byte[4];
	    byte[] byt_nsdfreespace = new byte[4];
	    
		public MSG_GET_SDCARD_REC_PARAM_RESP(byte[] data) {
			System.arraycopy(data, 0,   byt_recordCoverInSDCard, 0, byt_recordCoverInSDCard.length);
			System.arraycopy(data, 4,   byt_nrecordtimelen, 0, byt_nrecordtimelen.length);
			System.arraycopy(data, 12,  byt_brecordtime, 0, byt_brecordtime.length);
			System.arraycopy(data, 100, byt_nsdcardstatus, 0, byt_nsdcardstatus.length);
			System.arraycopy(data, 104, byt_nsdtotalspace, 0, byt_nsdtotalspace.length);
			System.arraycopy(data, 108, byt_nsdfreespace, 0, byt_nsdfreespace.length);
		}
		
		public int getbRecordCoverInSDCard() {
			if(byt_recordCoverInSDCard==null) return 0;
			else return Convert.byteArrayToInt_Little(byt_recordCoverInSDCard);
		}
		public void setbRecordCoverInSDCard(int bRecordCoverInSDCard) {
			this.bRecordCoverInSDCard = bRecordCoverInSDCard;
		}
		public int getnRecordTimeLen() {
			if(byt_nrecordtimelen==null) return 0;
			else return Convert.byteArrayToInt_Little(byt_nrecordtimelen);
		}
		public void setnRecordTimeLen(int nRecordTimeLen) {
			this.nRecordTimeLen = nRecordTimeLen;
		}
		public int getbRecordTime() {
			if(byt_brecordtime == null) return 0;
			else return Convert.byteArrayToInt_Little(byt_brecordtime);
		}
		public void setbRecordTime(int bRecordTime) {
			this.bRecordTime = bRecordTime;
		}
		public int getnSDCardStatus() {
			if(byt_nsdcardstatus == null) return 0;
			else return Convert.byteArrayToInt_Little(byt_nsdcardstatus);
		}
		public void setnSDCardStatus(int nSDCardStatus) {
			this.nSDCardStatus = nSDCardStatus;
		}
		public int getnSDTotalSpace() {
			if(byt_nsdtotalspace == null) return 0;
			else return Convert.byteArrayToInt_Little(byt_nsdtotalspace);
		}
		public void setnSDTotalSpace(int nSDTotalSpace) {
			this.nSDTotalSpace = nSDTotalSpace;
		}
		public int getnSDFreeSpace() {
			if(byt_nsdfreespace == null) return 0;
			else return Convert.byteArrayToInt_Little(byt_nsdfreespace);
		}
		public void setnSDFreeSpace(int nSDFreeSpace) {
			this.nSDFreeSpace = nSDFreeSpace;
		}
}
