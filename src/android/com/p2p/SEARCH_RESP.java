package com.p2p;

import java.util.Arrays;

public class SEARCH_RESP {
	public static final int MY_LEN=272;
	
	public static final int PRODUCT_TYPE_M1_TO_SEARCH=0x4D01;
	public static final int PRODUCT_TYPE_L_TO_SEARCH =0x0000;
	
	byte[] bytIpAddr =new byte[16];
	byte[] bytMacAddr=new byte[6];
	int	   nPort=0;
	byte[] bytDID=new byte[32];
	int    productType=0;
	
	public SEARCH_RESP(byte[] data){
		if(data==null || data.length<MY_LEN) {
			reset();
			return;
		}
		int iPos=0;
		System.arraycopy(data, iPos, bytIpAddr, 0, 16);
		iPos+=16;
		iPos+=64;
		System.arraycopy(data, iPos, bytMacAddr, 0, 6);
		iPos+=6;
		nPort=Convert.byteArrayToShort_Little(data, iPos)&0xFFFF;
		iPos+=2;
		
		System.arraycopy(data, iPos, bytDID, 0, 32);
		iPos+=32;
		iPos+=129;
		productType=((data[iPos]<<8)&0xFF | data[iPos+1]&0xFF);
	}
	
	private void reset(){
		Arrays.fill(bytIpAddr, (byte)0);
		Arrays.fill(bytMacAddr,(byte)0);
		nPort=0;
		Arrays.fill(bytDID, (byte)0);
		productType=0;
	}
	
	public String getIpAddr(){
		if(bytIpAddr==null) return "";
		else return Convert.bytesToString(bytIpAddr);
	}
	
	public String getMacAddr(){
		if(bytMacAddr==null) return "";
		else return Convert.bytesToString(bytMacAddr);
	}
	
	public int getPort()
	{
		return (nPort&0xFFFF);
	}
	public String getDID(){
		if(bytDID==null) return "";
		else return Convert.bytesToString(bytDID);
	}
	public int getProductType(){
		return (productType&0xFFFF);
	}
}
