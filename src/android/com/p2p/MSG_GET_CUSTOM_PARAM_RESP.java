package com.p2p;

import java.util.Arrays;

public class MSG_GET_CUSTOM_PARAM_RESP {
	byte result;
    byte[] chParamName = new byte[32]; 
    byte[] chParamValue= new byte[64];
    
    private void reset(){
    	result=(byte)0;
    	Arrays.fill(chParamName, (byte)0);
    	Arrays.fill(chParamValue,(byte)0);
    }
    
    public MSG_GET_CUSTOM_PARAM_RESP(byte[] data) {
    	reset();
		result=data[0];
		System.arraycopy(data, 8, chParamName, 0, chParamName.length);
		System.arraycopy(data, 40, chParamValue, 0, chParamValue.length);
	}
    
    public int getResult(){
    	return (int)(result&0xFF);
    }
    public String getParamName(){
    	return Convert.bytesToString(chParamName);
    }
    
    public String getParamValue(){
    	return Convert.bytesToString(chParamValue);
    }
}
