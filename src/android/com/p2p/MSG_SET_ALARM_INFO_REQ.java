package com.p2p;

import java.util.Arrays;

public class MSG_SET_ALARM_INFO_REQ {
	public static final int MY_LEN = 272+16;

	public static final int MD_LEVEL_LOW =0;
	public static final int MD_LEVEL_MID =1;
	public static final int MD_LEVEL_HIGH=2;
	
	private byte[] bMDEnable=new byte[4];	  //bMDEnable[0]--> enable flag of MD0,...; their value are 0->disable, 1->enable;
	private byte[] nMDSensitivity=new byte[4];//nMDSensitivity[0]--> sensitivity value of MD0,...; their value are [0,9],0->the highest, 9->the lowest;
	private int bInputAlarm=0;		//0->disable; 1->enable
	private int nInputAlarmMode=0;	//0->low level(close);  1->high level(open)
	private int bIOLinkageWhenAlarm=0; //Trigger IO output, 0->disable linkage; 1->enable linkage
	//private int reserve1;
	private int nPresetbitWhenAlarm=0; //[0,8]; 0->disable; >0 enable, position index from 1 to 8
	private int bMailWhenAlarm=0;	   //0->disable; 1->enable
	private int bSnapshotToSDWhenAlarm=0;  //0->disable; 1->enable	//None for L Series
	private int bRecordToSDWhenAlarm=0;	   //0->disable; 1->enable  //None for L Series
	private int bSnapshotToFTPWhenAlarm=0; //0->disable; 1->enable
	private int bRecordToFTPWhenAlarm=0;   //0->disable; 1->enable  //None for L Series
	//CHAR  reserve2[8];
	private int nAlarmTime_sun_0=-1;		//24 hours every day, 15 minutes every hour, one flag every 15 minutes, one flag is one bit. bit0---bit95, 0 is invalid in this period(15 minutes), 1 is valid in this period(15 minutes). 
	private int nAlarmTime_sun_1=-1;		//nAlarmTime_sun_0.bit0=00:00:00--00:14:59; nAlarmTime_sun_0.bit1=00:15:00--00:29:59; nAlarmTime_sun_0.bit2=00:30:00--00:44:59; ......
	private int nAlarmTime_sun_2=-1;		//nAlarmTime_sun_1.bit0=08:00:00--08:14:59; nAlarmTime_sun_1.bit1=08:15:00--08:29:59; nAlarmTime_sun_1.bit2=08:30:00--08:44:59; ......
	private int nAlarmTime_mon_0=-1;		
	private int nAlarmTime_mon_1=-1;		//nAlarmTime_sun_0, nAlarmTime_sun_1, nAlarmTime_sun_2: Sunday
	private int nAlarmTime_mon_2=-1;		//nAlarmTime_mon_0, nAlarmTime_mon_1, nAlarmTime_mon_2: Monday
	private int nAlarmTime_tue_0=-1;		//......
	private int nAlarmTime_tue_1=-1;
	private int nAlarmTime_tue_2=-1;
	private int nAlarmTime_wed_0=-1;
	private int nAlarmTime_wed_1=-1;
	private int nAlarmTime_wed_2=-1;
	private int nAlarmTime_thu_0=-1;
	private int nAlarmTime_thu_1=-1;
	private int nAlarmTime_thu_2=-1;
	private int nAlarmTime_fri_0=-1;
	private int nAlarmTime_fri_1=-1;
	private int nAlarmTime_fri_2=-1;
	private int nAlarmTime_sat_0=-1;
	private int nAlarmTime_sat_1=-1;
	private int nAlarmTime_sat_2=-1;
	private byte nAudioAlarmSensitivity=0;  //0->disable; >0 enable, [1,100] is sensitivity value. 1 is the lowest, 100 is the highest. level 1 is [1,10), level 2 is [10,20),... for X series
	private byte nTimeSecOfIOOut=5;	   //time of IO output, unit second, for X series
	private byte bSpeakerWhenAlarm=0;	   //0->disable; 1->enable, for x series
	private byte nTimeSecOfSpeaker=5;	   //unit: second, for x series
	//private byte[] md_name=new byte[64];	   //name of motion detect area 0, for x series

	private int[] md_x=new int[4];	 //md_x[0] is the horizontal coordinates of MD0, md_x[1] is MD1,...;	valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	private int[] md_y=new int[4];	 //md_y[0] is the vertical coordinates of MD0, md_y[1] is MD1,...;	valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	private int[] md_width=new int[4]; //md_width[0] is the width of MD0, md_width[1] is MD1,...;			valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	private int[] md_height=new int[4];//md_height[0] is the height of MD0, md_height[1] is MD1,...;		valid firmware>=V0.1.0.30 for M, 1.0.0.22 for X
	
	private byte nTriggerAlarmType=0;	//0=Trigger independently: Trigger when detecting by any kind of trigger; 1=Trigger jointly
	private byte bTemperatureAlarm=0;	//0->disable; 1->enable, for x series
	private byte bHumidityAlarm=0;		//0->disable; 1->enable, for x series
	//UCHAR reserve3[5];
	short nTempMinValueWhenAlarm=-10;  //trigger alarm when temperature < this value, [-100, 100],unit 0C
	short nTempMaxValueWhenAlarm=40;  //trigger alarm when temperature > this value, [-100, 100],unit 0C
	short nHumiMinValueWhenAlarm=20;  //trigger alarm when humidity < this value,	  [0, 100], unit %
	short nHumiMaxValueWhenAlarm=80; 
	
	public MSG_SET_ALARM_INFO_REQ() { reset(); }
	
	private void reset(){
		Arrays.fill(bMDEnable, (byte)0); 
		Arrays.fill(nMDSensitivity, (byte)0); 
		Arrays.fill(md_x, (byte)0);
		Arrays.fill(md_y, (byte)0);
		Arrays.fill(md_width, (byte)0);
		Arrays.fill(md_height, (byte)0);
		
		//32,32,352,352
		md_x[0]=32;
		md_x[1]=32;
		md_x[2]=32;
		md_x[3]=32;
		
		md_y[0]=32;
		md_y[1]=32;
		md_y[2]=32;
		md_y[3]=32;
		
		md_width[0]=320;
		md_width[1]=320;
		md_width[2]=320;
		md_width[3]=320;
		
		md_height[0]=320;
		md_height[1]=320;
		md_height[2]=320;
		md_height[3]=320;
	}
	public byte[] getBytes(){
		byte[] byts = new byte[MY_LEN],  bytTmp=null;
		int nPos=0;
		Arrays.fill(byts, (byte)0);
		
		System.arraycopy(bMDEnable, 0, byts, nPos, bMDEnable.length);
		nPos+=4;
		System.arraycopy(nMDSensitivity, 0, byts, nPos, nMDSensitivity.length);
		nPos+=4;
		
		bytTmp = Convert.intToByteArray_Little(bInputAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nInputAlarmMode);
		System.arraycopy(bytTmp, 0, byts, nPos,bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bIOLinkageWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		nPos+=4; //INT32 reserve1;
		
		bytTmp=Convert.intToByteArray_Little(nPresetbitWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bMailWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bSnapshotToSDWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bRecordToSDWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bSnapshotToFTPWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(bRecordToFTPWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		nPos+=8; //CHAR  reserve2[8];
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sun_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sun_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sun_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_mon_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_mon_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_mon_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_tue_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_tue_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_tue_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_wed_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_wed_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_wed_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_thu_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_thu_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_thu_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_fri_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_fri_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_fri_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sat_0);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sat_1);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		bytTmp=Convert.intToByteArray_Little(nAlarmTime_sat_2);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=4;
		
		byts[nPos]=(byte)nAudioAlarmSensitivity;	nPos+=1;
		byts[nPos]=(byte)nTimeSecOfIOOut;			nPos+=1;
		byts[nPos]=(byte)bSpeakerWhenAlarm;			nPos+=1;
		byts[nPos]=(byte)nTimeSecOfSpeaker;			nPos+=1;
		nPos+=64; //CHAR  md_name[64];	
		
		if(md_x!=null && md_x.length>=4) {
			bytTmp=Convert.intToByteArray_Little(md_x[0]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_x[1]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_x[2]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_x[3]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
		}else nPos+=16;
		
		if(md_y!=null && md_y.length>=4) {
			bytTmp=Convert.intToByteArray_Little(md_y[0]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_y[1]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_y[2]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_y[3]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
		}else nPos+=16;
		
		if(md_width!=null && md_width.length>=4) {
			bytTmp=Convert.intToByteArray_Little(md_width[0]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_width[1]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_width[2]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_width[3]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
		}else nPos+=16;
		
		if(md_height!=null && md_height.length>=4) {
			bytTmp=Convert.intToByteArray_Little(md_height[0]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_height[1]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_height[2]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
			
			bytTmp=Convert.intToByteArray_Little(md_height[3]);
			System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
			nPos+=4;
		}else nPos+=16;
		
		byts[nPos]=(byte)nTriggerAlarmType;  nPos+=1;
		byts[nPos]=(byte)bTemperatureAlarm;  nPos+=1;
		byts[nPos]=(byte)bHumidityAlarm;  	 nPos+=1;
		nPos+=5; //UCHAR reserve3[5];
		
		bytTmp=Convert.shortToByteArray_Little(nTempMinValueWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=2;
		
		bytTmp=Convert.shortToByteArray_Little(nTempMaxValueWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=2;
		
		bytTmp=Convert.shortToByteArray_Little(nHumiMinValueWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=2;
		
		bytTmp=Convert.shortToByteArray_Little(nHumiMaxValueWhenAlarm);
		System.arraycopy(bytTmp, 0, byts, nPos, bytTmp.length);
		nPos+=2;
		return byts;
	}
	public int setData(byte[] data){
		reset();
		if(data==null || data.length<MY_LEN) return -1;
		
		int nPos=0;
		byte[] bytTmp=null;
		System.arraycopy(data,nPos, bMDEnable, 0, bMDEnable.length);
		nPos+=4;
		System.arraycopy(data, nPos, nMDSensitivity, 0, nMDSensitivity.length);
		nPos+=4;
		
		bInputAlarm = Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nInputAlarmMode=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		bIOLinkageWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nPos+=4; //INT32 reserve1;
		
		nPresetbitWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		bMailWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;

		bSnapshotToSDWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		bRecordToSDWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		bSnapshotToFTPWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		bRecordToFTPWhenAlarm=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nPos+=8; //CHAR  reserve2[8];
		
		nAlarmTime_sun_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_sun_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_sun_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_mon_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_mon_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_mon_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_tue_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_tue_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_tue_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_wed_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_wed_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_wed_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_thu_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_thu_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_thu_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_fri_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_fri_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_fri_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAlarmTime_sat_0=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_sat_1=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		nAlarmTime_sat_2=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		
		nAudioAlarmSensitivity=data[nPos];	nPos+=1;
		nTimeSecOfIOOut=data[nPos];			nPos+=1;
		bSpeakerWhenAlarm=data[nPos];		nPos+=1;
		nTimeSecOfSpeaker=data[nPos];		nPos+=1;
		nPos+=64; //CHAR  md_name[64];	
		
		md_x[0]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_x[1]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_x[2]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_x[3]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		
		md_y[0]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_y[1]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_y[2]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_y[3]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		
		md_width[0]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_width[1]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_width[2]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_width[3]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		
		md_height[0]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_height[1]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_height[2]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		md_height[3]=Convert.byteArrayToInt_Little(data, nPos);	nPos+=4;
		
		nTriggerAlarmType=data[nPos];  nPos+=1;
		bTemperatureAlarm=data[nPos];  nPos+=1;
		bHumidityAlarm=data[nPos];     nPos+=1;
		nPos+=5;//UCHAR reserve3[5];
		
		nTempMinValueWhenAlarm=Convert.byteArrayToShort_Little(data, nPos);	nPos+=2;
		nTempMaxValueWhenAlarm=Convert.byteArrayToShort_Little(data, nPos);	nPos+=2;
		nHumiMinValueWhenAlarm=Convert.byteArrayToShort_Little(data, nPos);	nPos+=2;
		nHumiMaxValueWhenAlarm=Convert.byteArrayToShort_Little(data, nPos);	nPos+=2;
		return 0;
	}
	
	public boolean is_io_in_alarm() { return (bInputAlarm==1) ? true : false;     }
	public boolean is_io_in_level() { return (nInputAlarmMode==1) ? true : false; } //1 is open
	public boolean get_md_alarm(int nMDIndex){
		if(nMDIndex<0 || nMDIndex>=4) return false;
		else return (bMDEnable[nMDIndex]==1) ? true : false; 
	}
	public int get_md_sensitivity(int nMDIndex) {
		if(nMDIndex<0 || nMDIndex>=4) return -1;
		return nMDSensitivity[nMDIndex];
	}
	public int get_md_level(int nMDIndex) { //[0,9], 0->the highest, 9->the lowest;
		if(nMDIndex<0 || nMDIndex>=4) return MD_LEVEL_LOW;
		if(nMDSensitivity[nMDIndex]<=3) return MD_LEVEL_HIGH;
		else if(nMDSensitivity[nMDIndex]<=6) return MD_LEVEL_MID;
		else return MD_LEVEL_LOW;
	}
	public int get_md_x(int nMDIndex) {
		if(nMDIndex<0 || nMDIndex>=4) return -1;
		return md_x[nMDIndex];
	}
	public int get_md_y(int nMDIndex) {
		if(nMDIndex<0 || nMDIndex>=4) return -1;
		return md_y[nMDIndex];
	}
	public int get_md_width(int nMDIndex) {
		if(nMDIndex<0 || nMDIndex>=4) return -1;
		return md_width[nMDIndex];
	}
	public int get_md_height(int nMDIndex) {
		if(nMDIndex<0 || nMDIndex>=4) return -1;
		return md_height[nMDIndex];
	}
	
	public boolean is_audio_alarm(){ return nAudioAlarmSensitivity>0 ? true : false; }
	public int get_audio_level()   {  //[1,100] is sensitivity value. 1 is the lowest
		if(nAudioAlarmSensitivity<=0) return MD_LEVEL_LOW;
		if(nAudioAlarmSensitivity<34) return MD_LEVEL_LOW;
		else if(nAudioAlarmSensitivity<68) return MD_LEVEL_MID;
		else return MD_LEVEL_HIGH;
	}
	public int get_audio_sensitivity(){ return nAudioAlarmSensitivity; }
	
	public boolean is_temp_alarm() { return (bTemperatureAlarm==1) ? true : false; }
	public int get_temp_min() { return nTempMinValueWhenAlarm; }
	public int get_temp_max() { return nTempMaxValueWhenAlarm; }
	
	public boolean is_humi_alarm() { return (bHumidityAlarm==1) ? true : false;    }
	public int get_humi_min() { return nHumiMinValueWhenAlarm; }
	public int get_humi_max() { return nHumiMaxValueWhenAlarm; }
	
	public boolean is_trigger_alone() { return (nTriggerAlarmType==0) ? true : false; 		}
	public boolean is_trigger_join()  { return (nTriggerAlarmType==1) ? true : false; 		}

	public boolean is_pic_to_email()  { return (bMailWhenAlarm==1) ? true : false; 			}
	public boolean is_pic_to_ftp()    { return (bSnapshotToFTPWhenAlarm==1) ? true : false; }
	public boolean is_record_to_ftp() { return (bRecordToFTPWhenAlarm==1) ? true : false; 	}
	public boolean is_pic_to_sd() 	  { return (bSnapshotToSDWhenAlarm==1) ? true : false; 	}
	public boolean is_record_to_sd()  { return (bRecordToSDWhenAlarm==1) ? true : false; 	}
	public boolean is_io_out()        { return (bIOLinkageWhenAlarm==1) ? true : false;		}
	public int get_io_out_timelen()	  { return (int)(nTimeSecOfIOOut&0xFF); 				}
	public boolean is_presetbit_alarm(){ return (nPresetbitWhenAlarm==0) ? false : true;	}
	public int get_presetbit()		  {
		if(nPresetbitWhenAlarm<=0) return 1;
		else return nPresetbitWhenAlarm;
	}
	public boolean is_speaker_alarm() { return (bSpeakerWhenAlarm==1) ? true : false; 	}
	public int get_speaker_timelen()  { return (int)(nTimeSecOfSpeaker&0xFF); 			}
	
	
	
	public void set_io_in_alarm(boolean bEnable){ bInputAlarm= bEnable ? 1 : 0;   }
	public void set_io_in_level(boolean bOpen) 	{ nInputAlarmMode= bOpen ? 1 : 0; } //1 is open
	public void set_md_alarm(int nMDIndex, boolean bEnable){
		if(nMDIndex<0 || nMDIndex>=4) return;
		else bMDEnable[nMDIndex]= bEnable ? (byte)1 : (byte)0; 
	}
	public void set_md_level(int nMDIndex, int nLevel) { //[0,9], 0->the highest, 9->the lowest;
		if(nMDIndex<0 || nMDIndex>=4) return;
		if(nLevel==MD_LEVEL_HIGH) nMDSensitivity[nMDIndex]=1;
		else if(nLevel==MD_LEVEL_MID) nMDSensitivity[nMDIndex]=5;
		else nMDSensitivity[nMDIndex]=9;
	}
	public void set_md_sensitivity(int nMDIndex, int nSensitivity) {
		if(nMDIndex<0 || nMDIndex>=4) return;
		nMDSensitivity[nMDIndex]=(byte)nSensitivity;
	}
	public void set_md_xywh(int nMDIndex, int x,int y, int w,int h){
		if(nMDIndex<0 || nMDIndex>=4) return;
		md_x[nMDIndex]=x;
		md_y[nMDIndex]=y;
		md_width[nMDIndex]=w;
		md_height[nMDIndex]=h;
	}
	
	public void set_audio_alarm(boolean bEnable, int nLevel){//[1,100] is sensitivity value. 1 is the lowest
		if(bEnable){
			if(nLevel==MD_LEVEL_LOW) nAudioAlarmSensitivity=(byte)10;
			else if(nLevel==MD_LEVEL_MID) nAudioAlarmSensitivity=(byte)50;
			else nAudioAlarmSensitivity=(byte)90;
		}else nAudioAlarmSensitivity=(byte)0;
	}
	public void set_audio(boolean bEnable, int nSensitivity){//[1,100] is sensitivity value. 1 is the lowest
		if(bEnable){
			nAudioAlarmSensitivity=(byte)nSensitivity;
		}else nAudioAlarmSensitivity=(byte)0;
	}

	public void set_alarm_time_all_defence(){
		nAlarmTime_sun_0=-1;
		nAlarmTime_sun_1=-1;
		nAlarmTime_sun_2=-1;
		nAlarmTime_mon_0=-1;
		nAlarmTime_mon_1=-1;
		nAlarmTime_mon_2=-1;
		nAlarmTime_tue_0=-1;
		nAlarmTime_tue_1=-1;
		nAlarmTime_tue_2=-1;
		nAlarmTime_wed_0=-1;
		nAlarmTime_wed_1=-1;
		nAlarmTime_wed_2=-1;
		nAlarmTime_thu_0=-1;
		nAlarmTime_thu_1=-1;
		nAlarmTime_thu_2=-1;
		nAlarmTime_fri_0=-1;
		nAlarmTime_fri_1=-1;
		nAlarmTime_fri_2=-1;
		nAlarmTime_sat_0=-1;
		nAlarmTime_sat_1=-1;
		nAlarmTime_sat_2=-1;
	}
	
	public void set_temp_alarm(boolean bEnable) { bTemperatureAlarm=bEnable ? (byte)1 : (byte)0; }
	public void set_temp_min(int nValue) { nTempMinValueWhenAlarm=(short)nValue; }
	public void set_temp_max(int nValue) { nTempMaxValueWhenAlarm=(short)nValue; }
	public void set_humi_alarm(boolean bEnable) { bHumidityAlarm=bEnable ? (byte)1 : (byte)0; }
	public void set_humi_min(int nValue) { nHumiMinValueWhenAlarm=(short)nValue; }
	public void set_humi_max(int nValue) { nHumiMaxValueWhenAlarm=(short)nValue; }

	public void set_trigger_alone(boolean bEnable) { nTriggerAlarmType=bEnable ? (byte)0 : (byte)1; 		}
	public void set_trigger_join(boolean bEnable)  { nTriggerAlarmType=bEnable ? (byte)1 : (byte)0; 		}
	public void set_pic_to_email(boolean bEnable)  { bMailWhenAlarm=bEnable ? (byte)1 : (byte)0; 			}
	public void set_pic_to_ftp(boolean bEnable)    { bSnapshotToFTPWhenAlarm=bEnable ? (byte)1 : (byte)0; 	}
	public void set_record_to_ftp(boolean bEnable) { bRecordToFTPWhenAlarm=bEnable ? (byte)1 : (byte)0; 	}
	public void set_pic_to_sd(boolean bEnable) 	   { bSnapshotToSDWhenAlarm=bEnable ? (byte)1 : (byte)0; 	}
	public void set_record_to_sd(boolean bEnable)  { bRecordToSDWhenAlarm=bEnable ? (byte)1 : (byte)0; 		}
	public void set_io_out(boolean bEnable)        { bIOLinkageWhenAlarm=bEnable ? (byte)1 : (byte)0; 		}
	public void set_io_out_timelen(int nTimeLen)   { nTimeSecOfIOOut=(byte)(nTimeLen&0xFF); 				}
	public void set_presetbit_alarm(boolean bEnable, int nValue){
		if(bEnable){
			if(nValue<=0) nPresetbitWhenAlarm=1;
			else nPresetbitWhenAlarm=nValue;
		}else nPresetbitWhenAlarm=0;
	}
	public void set_speaker_alarm(boolean bEnable) { bSpeakerWhenAlarm=bEnable ? (byte)1 : (byte)0; }
	public void set_speaker_timelen(int nTimeLen)  { nTimeSecOfSpeaker=(byte)(nTimeLen&0xFF);		}

	
	@Override
	public String toString() {
		String str;
		str=String.format("bMDEnable(%d,%d,%d,%d) nMDSensitivity(%d,%d,%d,%d) bInputAlarm=%d nInputAlarmMode=%d bIOLinkageWhenAlarm=%d nPresetbitWhenAlarm=%d bMailWhenAlarm=%d bSnapshotToSDWhenAlarm=%d "
				+ "bRecordToSDWhenAlarm=%d bSnapshotToFTPWhenAlarm=%d bRecordToFTPWhenAlarm=%d nAlarmTime_sun_0=%d nAlarmTime_sat_2=%d nAudioAlarmSensitivity=%d nTimeSecOfIOOut=%d bSpeakerWhenAlarm=%d nTimeSecOfSpeaker=%d "
				+ "nTriggerAlarmType=%d bTemperatureAlarm=%d bHumidityAlarm=%d nTempMinValueWhenAlarm=%d nTempMaxValueWhenAlarm=%d nHumiMinValueWhenAlarm=%d nHumiMaxValueWhenAlarm=%d", 
				bMDEnable[0],bMDEnable[1],bMDEnable[2],bMDEnable[3], 
				nMDSensitivity[0],nMDSensitivity[1],nMDSensitivity[2],nMDSensitivity[3],
				bInputAlarm, nInputAlarmMode, bIOLinkageWhenAlarm, nPresetbitWhenAlarm, bMailWhenAlarm, bSnapshotToSDWhenAlarm, 
				bRecordToSDWhenAlarm,bSnapshotToFTPWhenAlarm, bRecordToFTPWhenAlarm, nAlarmTime_sun_0, nAlarmTime_sat_2,
				nAudioAlarmSensitivity,nTimeSecOfIOOut,bSpeakerWhenAlarm,nTimeSecOfSpeaker,nTriggerAlarmType,bTemperatureAlarm, bHumidityAlarm,
				nTempMinValueWhenAlarm,nTempMaxValueWhenAlarm,nHumiMinValueWhenAlarm, nHumiMaxValueWhenAlarm);
		return str;
	}
}
