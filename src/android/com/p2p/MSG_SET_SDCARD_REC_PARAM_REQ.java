package com.p2p;

import java.util.Arrays;

public class MSG_SET_SDCARD_REC_PARAM_REQ {
	public static final int MY_LEN = 112;

    int bRecordCoverInSDCard; //0->disable record in sd-card; 1->enable record in sd-card 
    int nRecordTimeLen; //record time length, in minutes 
    int reserve1; 
    int bRecordTime; //0->disable 1->enable 
    //byte[] reserve2 = new byte[84]; 
    //int nSDCardStatus; //0: no sdcard; 1: sdcard inserted 
    //int nSDTotalSpace; //in MBytes 
    //int nSDFreeSpace; //in MBytes 
    
    byte[] byt_recordCoverInSDCard = new byte[4];
    byte[] byt_nrecordtimelen = new byte[4];
    byte[] byt_brecordtime = new byte[4];
   
    public static byte[] toBytes(int bRecordCoverInSDCard,int nRecordTimeLen,int bRecordTime){
    	byte[] byts=new byte[MY_LEN];
		Arrays.fill(byts, (byte)0);
		
		byte[] byt_recordCoverInSDCard = Convert.intToByteArray_Little(bRecordCoverInSDCard);
		byte[] byt_nrecordtimelen = Convert.intToByteArray_Little(nRecordTimeLen);
		byte[] byt_brecordtime = Convert.intToByteArray_Little(bRecordTime);
		
	    System.arraycopy(byt_recordCoverInSDCard, 0, byts, 0, byt_recordCoverInSDCard.length);
	    System.arraycopy(byt_nrecordtimelen, 0, byts, 4, byt_nrecordtimelen.length);
	    System.arraycopy(byt_brecordtime, 0, byts, 12, byt_brecordtime.length);	    
		return byts;
	}
}
