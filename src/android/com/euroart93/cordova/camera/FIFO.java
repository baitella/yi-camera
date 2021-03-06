package com.euroart93.cordova.camera;

import java.util.LinkedList;

public class FIFO {
	public static final int MAXSIZE_CONTAIN = 262144;
	int bytSize = 0; // size in byte
	int nNum = 0;
	LinkedList<byte[]> listData = new LinkedList<byte[]>();

	public FIFO() {
	}
	public int getSize() {
		return bytSize;
	}
	public synchronized int getNum() {
		return nNum;
	}
	public synchronized boolean isEmpty() {
		return listData.isEmpty();
	}
	public synchronized void addLast(byte[] node, int nodeSizeInBytes) {
		// if(bytSize>MAXSIZE_CONTAIN) return;
		bytSize += nodeSizeInBytes;
		nNum++;
		byte[] bytNode = new byte[nodeSizeInBytes];
		System.arraycopy(node, 0, bytNode, 0, nodeSizeInBytes);
		listData.addLast(bytNode);
	}
	
	//----{{20150924----
	public synchronized byte[] getFirstNode(){
		if(listData.isEmpty()) return null;
		else {
			byte[] node = listData.getFirst();
			return node;
		}
	}
	//----}}20150924----
	
	public synchronized byte[] removeHead() {
		if (listData.isEmpty()) return null;
		else {
			byte[] node = listData.removeFirst();
			bytSize -= node.length;
			nNum--;
			return node;
		}
	}
	public synchronized void removeAll() {
		if (!listData.isEmpty())
			listData.clear();
		bytSize = 0;
		nNum = 0;
	}
}
