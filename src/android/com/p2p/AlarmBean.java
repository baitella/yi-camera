package com.p2p;

import java.io.Serializable;
import java.util.Arrays;

public class AlarmBean implements Serializable {
	private static final long serialVersionUID = 1L;
	private String did;           //did 
	private byte[] motion_armed=new byte[4];     //0->disable; 1->enable 
	private byte[] motion_sensitivity=new byte[4];//[0,9],0->the highest, 9->the lowest 
	private int input_armed; //0->disable; 1->enable 
	private int ioin_level; 
	private int ioout_level;
	private int iolinkage; //0->disable linkage; 1->enable linkage 
	private int alermpresetsit; //[0,8]; 0->disable; >0 enable, position index from 1 to 8 
	private int mail; //0->disable; 1->enable 
	private int snapshot; //0->disable; 1->enable 
	private int record;  //0->disable; 1->enable 
	private int nAudioAlarmSensitivity;  //0->disable; 1->enable 
	private int ftpsnapshot; //0->disable; 1->enable 
	private int ftprecord; //0->disable; 1->enable 
	
	private int upload_interval;  //upload interval
	private int schedule_enable;
	private int schedule_sun_0;
	private int schedule_sun_1;
	private int schedule_sun_2;
	private int schedule_mon_0;
	private int schedule_mon_1;
	private int schedule_mon_2;
	private int schedule_tue_0;
	private int schedule_tue_1;
	private int schedule_tue_2;
	private int schedule_wed_0;
	private int schedule_wed_1;
	private int schedule_wed_2;

	private int schedule_thu_0;
	private int schedule_thu_1;
	private int schedule_thu_2;
	private int schedule_fri_0;
	private int schedule_fri_1;
	private int schedule_fri_2;
	private int schedule_sat_0;
	private int schedule_sat_1;
	private int schedule_sat_2;
	private int[] md_x=new int[4];
	private int[] md_y=new int[4];
	private int[] md_w=new int[4];
	private int[] md_h=new int[4];

	public AlarmBean() {
		Arrays.fill(motion_armed, (byte)0);
		Arrays.fill(motion_sensitivity, (byte)0);
		Arrays.fill(md_x, 0);
		Arrays.fill(md_y, 0);
		Arrays.fill(md_w, 0);
		Arrays.fill(md_h, 0);
	}
	public int getnAudioAlarmSensitivity() { return nAudioAlarmSensitivity; }
	public void setnAudioAlarmSensitivity(int nAudioAlarmSensitivity) { this.nAudioAlarmSensitivity = nAudioAlarmSensitivity; }

	public int getFtpsnapshot(){ return ftpsnapshot; }
	public void setFtpsnapshot(int ftpsnapshot) { this.ftpsnapshot = ftpsnapshot; }
	public int getFtprecord()  { return ftprecord; 	}
	public void setFtprecord(int ftprecord) { this.ftprecord = ftprecord; 	}
	public String getDid()     { return did; 	}
	public void setDid(String did) { this.did = did;  }
	public byte[] getMotion_armed(){ return motion_armed; }
	
	public void setMotion_armed0(byte motion_armed) { this.motion_armed[0] = motion_armed;}
	public void setMotion_armed1(byte motion_armed) { this.motion_armed[1] = motion_armed;}
	public void setMotion_armed2(byte motion_armed) { this.motion_armed[2] = motion_armed;}
	public void setMotion_armed3(byte motion_armed) { this.motion_armed[3] = motion_armed;}
	
	public byte[] getMotion_sensitivity() { return motion_sensitivity;	}
	public void setMotion_sensitivity0(byte motion_sensitivity) { this.motion_sensitivity[0] = motion_sensitivity;	}
	public void setMotion_sensitivity1(byte motion_sensitivity) { this.motion_sensitivity[1] = motion_sensitivity;	}
	public void setMotion_sensitivity2(byte motion_sensitivity) { this.motion_sensitivity[2] = motion_sensitivity;	}
	public void setMotion_sensitivity3(byte motion_sensitivity) { this.motion_sensitivity[3] = motion_sensitivity;	}
	
	public int[] getmd_x(){ return md_x; }
	public void setmd_x(int x0,int x1,int x2,int x3){
		md_x[0]=x0;
		md_x[1]=x1;
		md_x[2]=x2;
		md_x[3]=x3;
	}
	
	public int[] getmd_y(){ return md_y; }
	public void setmd_y(int y0,int y1,int y2,int y3){
		md_x[0]=y0;
		md_x[1]=y1;
		md_x[2]=y2;
		md_x[3]=y3;
	}
	
	public int[] getmd_w(){ return md_w; }
	public void setmd_w(int w0,int w1,int w2,int w3){
		md_w[0]=w0;
		md_w[1]=w1;
		md_w[2]=w2;
		md_w[3]=w3;
	}
	
	public int[] getmd_h(){ return md_h; }
	public void setmd_h(int h0,int h1,int h2,int h3){
		md_h[0]=h0;
		md_h[1]=h1;
		md_h[2]=h2;
		md_h[3]=h3;
	}
	
	public int getInput_armed() { return input_armed; }
	public void setInput_armed(int input_armed) { this.input_armed = input_armed; }
	public int getIoin_level() { return ioin_level; }
	public int getIoout_level() { return ioout_level; }

	public void setIoout_level(int ioout_level) { this.ioout_level = ioout_level; }
	public void setIoin_level(int ioin_level) {	this.ioin_level = ioin_level; }

	public int getIolinkage() {
		return iolinkage;
	}

	public void setIolinkage(int iolinkage) {
		this.iolinkage = iolinkage;
	}

	public int getAlermpresetsit() {
		return alermpresetsit;
	}

	public void setAlermpresetsit(int alermpresetsit) {
		this.alermpresetsit = alermpresetsit;
	}

	public int getMail() {
		return mail;
	}

	public void setMail(int mail) {
		this.mail = mail;
	}

	public int getSnapshot() {
		return snapshot;
	}

	public void setSnapshot(int snapshot) {
		this.snapshot = snapshot;
	}

	public int getRecord() {
		return record;
	}

	public void setRecord(int record) {
		this.record = record;
	}

	public int getUpload_interval() {
		return upload_interval;
	}

	public void setUpload_interval(int upload_interval) {
		this.upload_interval = upload_interval;
	}

	public int getSchedule_enable() {
		return schedule_enable;
	}

	public void setSchedule_enable(int schedule_enable) {
		this.schedule_enable = schedule_enable;
	}

	public int getSchedule_sun_0() {
		return schedule_sun_0;
	}

	public void setSchedule_sun_0(int schedule_sun_0) {
		this.schedule_sun_0 = schedule_sun_0;
	}

	public int getSchedule_sun_1() {
		return schedule_sun_1;
	}

	public void setSchedule_sun_1(int schedule_sun_1) {
		this.schedule_sun_1 = schedule_sun_1;
	}

	public int getSchedule_sun_2() {
		return schedule_sun_2;
	}

	public void setSchedule_sun_2(int schedule_sun_2) {
		this.schedule_sun_2 = schedule_sun_2;
	}

	public int getSchedule_mon_0() {
		return schedule_mon_0;
	}

	public void setSchedule_mon_0(int schedule_mon_0) {
		this.schedule_mon_0 = schedule_mon_0;
	}

	public int getSchedule_mon_1() {
		return schedule_mon_1;
	}

	public void setSchedule_mon_1(int schedule_mon_1) {
		this.schedule_mon_1 = schedule_mon_1;
	}

	public int getSchedule_mon_2() {
		return schedule_mon_2;
	}

	public void setSchedule_mon_2(int schedule_mon_2) {
		this.schedule_mon_2 = schedule_mon_2;
	}

	public int getSchedule_tue_0() {
		return schedule_tue_0;
	}

	public void setSchedule_tue_0(int schedule_tue_0) {
		this.schedule_tue_0 = schedule_tue_0;
	}

	public int getSchedule_tue_1() {
		return schedule_tue_1;
	}

	public void setSchedule_tue_1(int schedule_tue_1) {
		this.schedule_tue_1 = schedule_tue_1;
	}

	public int getSchedule_tue_2() {
		return schedule_tue_2;
	}

	public void setSchedule_tue_2(int schedule_tue_2) {
		this.schedule_tue_2 = schedule_tue_2;
	}

	public int getSchedule_wed_0() {
		return schedule_wed_0;
	}

	public void setSchedule_wed_0(int schedule_wed_0) {
		this.schedule_wed_0 = schedule_wed_0;
	}

	public int getSchedule_wed_1() {
		return schedule_wed_1;
	}

	public void setSchedule_wed_1(int schedule_wed_1) {
		this.schedule_wed_1 = schedule_wed_1;
	}

	public int getSchedule_wed_2() {
		return schedule_wed_2;
	}

	public void setSchedule_wed_2(int schedule_wed_2) {
		this.schedule_wed_2 = schedule_wed_2;
	}

	public int getSchedule_thu_0() {
		return schedule_thu_0;
	}

	public void setSchedule_thu_0(int schedule_thu_0) {
		this.schedule_thu_0 = schedule_thu_0;
	}

	public int getSchedule_thu_1() {
		return schedule_thu_1;
	}

	public void setSchedule_thu_1(int schedule_thu_1) {
		this.schedule_thu_1 = schedule_thu_1;
	}

	public int getSchedule_thu_2() {
		return schedule_thu_2;
	}

	public void setSchedule_thu_2(int schedule_thu_2) {
		this.schedule_thu_2 = schedule_thu_2;
	}

	public int getSchedule_fri_0() {
		return schedule_fri_0;
	}

	public void setSchedule_fri_0(int schedule_fri_0) {
		this.schedule_fri_0 = schedule_fri_0;
	}

	public int getSchedule_fri_1() {
		return schedule_fri_1;
	}

	public void setSchedule_fri_1(int schedule_fri_1) {
		this.schedule_fri_1 = schedule_fri_1;
	}

	public int getSchedule_fri_2() {
		return schedule_fri_2;
	}

	public void setSchedule_fri_2(int schedule_fri_2) {
		this.schedule_fri_2 = schedule_fri_2;
	}

	public int getSchedule_sat_0() {
		return schedule_sat_0;
	}

	public void setSchedule_sat_0(int schedule_sat_0) {
		this.schedule_sat_0 = schedule_sat_0;
	}

	public int getSchedule_sat_1() {
		return schedule_sat_1;
	}

	public void setSchedule_sat_1(int schedule_sat_1) {
		this.schedule_sat_1 = schedule_sat_1;
	}

	public int getSchedule_sat_2() {
		return schedule_sat_2;
	}

	public void setSchedule_sat_2(int schedule_sat_2) {
		this.schedule_sat_2 = schedule_sat_2;
	}

	@Override
	public String toString() {
		return "AlermBean [did=" + did + ", motion_armed=" + motion_armed
				+ ", motion_sensitivity=" + motion_sensitivity
				+ ", input_armed=" + input_armed + ", ioin_level=" + ioin_level
				+ ", iolinkage=" + iolinkage + ", alermpresetsit="
				+ alermpresetsit + ", mail=" + mail + ", snapshot=" + snapshot
				+ ", record=" + record + ", upload_interval=" + upload_interval
				+ ", schedule_enable=" + schedule_enable + ", schedule_sun_0="
				+ schedule_sun_0 + ", schedule_sun_1=" + schedule_sun_1
				+ ", schedule_sun_2=" + schedule_sun_2 + ", schedule_mon_0="
				+ schedule_mon_0 + ", schedule_mon_1=" + schedule_mon_1
				+ ", schedule_mon_2=" + schedule_mon_2 + ", schedule_tue_0="
				+ schedule_tue_0 + ", schedule_tue_1=" + schedule_tue_1
				+ ", schedule_tue_2=" + schedule_tue_2 + ", schedule_wed_0="
				+ schedule_wed_0 + ", schedule_wed_1=" + schedule_wed_1
				+ ", schedule_wed_2=" + schedule_wed_2 + ", schedule_thu_0="
				+ schedule_thu_0 + ", schedule_thu_1=" + schedule_thu_1
				+ ", schedule_thu_2=" + schedule_thu_2 + ", schedule_fri_0="
				+ schedule_fri_0 + ", schedule_fri_1=" + schedule_fri_1
				+ ", schedule_fri_2=" + schedule_fri_2 + ", schedule_sat_0="
				+ schedule_sat_0 + ", schedule_sat_1=" + schedule_sat_1
				+ ", schedule_sat_2=" + schedule_sat_2 + "]";
	}

}
