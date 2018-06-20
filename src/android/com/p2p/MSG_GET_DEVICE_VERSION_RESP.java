package com.p2p;

import java.util.Arrays;

public class MSG_GET_DEVICE_VERSION_RESP {
	public static final int MY_LEN = 352;
	
	byte[] chP2papi_ver = new byte[32]; 	// CameraPlugin version
	byte[] chFwp2p_app_ver = new byte[32]; 	// P2P firmware version
	byte[] chFwp2p_app_buildtime = new byte[32]; 	// P2P firmware build time
	byte[] chFwddns_app_ver = new byte[32]; 		// firmware version
	byte[] chFwhard_ver = new byte[32]; // the device hard version
	byte[] chVendor = new byte[32]; 	// factory name
	byte[] chProduct = new byte[32]; 	// product mode
	byte[] product_series = new byte[4];// product main category, L series:
										// product_series[0]='L'; M
										// series:product_series[0]='M',product_series[1]='1';
	int  imn_ver_of_device=0;
	byte is_push_function=(byte)0;
	//byte[] reserve1 = new byte[3];
	byte[] imn_server_port=new byte[96]; //e.g.: domain_or_ip1:port1|domain_or_ip2:port2|...
	//byte[] reserve = new byte[20];
	
	public MSG_GET_DEVICE_VERSION_RESP(byte[] data) {
		reset();
		if(data.length<MY_LEN) return;
		
		int nPos=0;
		System.arraycopy(data, nPos,  chP2papi_ver, 0, chP2papi_ver.length);
		nPos+=chP2papi_ver.length;
		System.arraycopy(data, nPos, chFwp2p_app_ver, 0, chFwp2p_app_ver.length);
		nPos+=chFwp2p_app_ver.length;
		System.arraycopy(data, nPos, chFwp2p_app_buildtime, 0, chFwp2p_app_buildtime.length);
		nPos+=chFwp2p_app_buildtime.length;
		
		System.arraycopy(data, nPos, chFwddns_app_ver, 0, chFwddns_app_ver.length);
		nPos+=chFwddns_app_ver.length;
		System.arraycopy(data, nPos, chFwhard_ver, 0, chFwhard_ver.length);
		nPos+=chFwhard_ver.length;
		System.arraycopy(data, nPos, chVendor, 0, chVendor.length);
		nPos+=chVendor.length;
		System.arraycopy(data, nPos, chProduct, 0, chProduct.length);
		nPos+=chProduct.length;
		System.arraycopy(data, nPos, product_series, 0, product_series.length);
		nPos+=product_series.length;
		imn_ver_of_device=Convert.byteArrayToInt_Little(data, nPos);
		nPos+=4;
		is_push_function=data[nPos];
		nPos+=1;
		nPos+=3;
		System.arraycopy(data, nPos, imn_server_port, 0, imn_server_port.length);
	}

	private void reset()
	{
		Arrays.fill(chP2papi_ver, (byte)0);
		Arrays.fill(chFwp2p_app_ver, (byte)0);
		Arrays.fill(chFwp2p_app_buildtime, (byte)0);
		Arrays.fill(chFwddns_app_ver, (byte)0);
		Arrays.fill(chFwhard_ver, (byte)0);
		Arrays.fill(chVendor, (byte)0);
		Arrays.fill(chProduct, (byte)0);
		Arrays.fill(product_series, (byte)0);
		Arrays.fill(imn_server_port, (byte)0);
	}
	
	public String getAPIVer() 		{	return Convert.bytesToString(chP2papi_ver); 		}

	public String getP2PAppVer() 	{	return Convert.bytesToString(chFwp2p_app_ver); 		}
	public String getP2PBuildTime() {	return Convert.bytesToString(chFwp2p_app_buildtime);}
	public String getFwddnsVer() 	{	return Convert.bytesToString(chFwddns_app_ver); 	}
	
	public String getProductSeriesStr(){ return Convert.bytesToString(product_series); 		}
	public int getProductSeriesInt(){
		int nSeries=(product_series[0]&0xFF)<<8 | ((product_series[1]-0x30)&0xFF);
		return nSeries;
	}
	public int getProductSeriesInt2(){
		int nSeries=(product_series[0]&0xFF);
		return nSeries;
	}
	public int getimn_ver_of_device()	{ return imn_ver_of_device; 			}
	public int IsPushFunction() 		{ return (int)(is_push_function&0xFF); 	}
	public String getImnServerPort() 	{ return Convert.bytesToString(imn_server_port); 	}
	public String getVendor()			{ return Convert.bytesToString(chVendor);			}
	public String getProductMode()		{ return Convert.bytesToString(chProduct);			}
	
}
