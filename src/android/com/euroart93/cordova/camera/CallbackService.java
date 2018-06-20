package com.euroart93.cordova.camera;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import com.p2p.SEP2P_AppSDK;
import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.widget.RemoteViews;

@SuppressLint("SimpleDateFormat")
public class CallbackService extends Service {
	private NotificationManager mCustomMgr;
	private Notification mNotify2;
	private static LinkedList<IMsg> m_listIMsg = new LinkedList<IMsg>();
	private static LinkedList<IStream> m_listIStream = new LinkedList<IStream>();
	class ControllerBinder extends Binder {
		public CallbackService getBridgeService() {
			return CallbackService.this;
		}
	}
	@Override
	public IBinder onBind(Intent intent) {
		System.out.println("CallbackService] onBind()");
		return new ControllerBinder();
	}
	@Override
	public void onCreate() {
		super.onCreate();
		mCustomMgr = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		System.out.println("Build.VERSION.SDK_INT="+Build.VERSION.SDK_INT);
		SEP2P_AppSDK.SetCallbackContext(this, Build.VERSION.SDK_INT);
	}
	@Override
	public void onDestroy() {
		super.onDestroy();
		// mCustomMgr.cancel(R.drawable.ic_launcher);
		System.out.println("CallbackService] onDestroy()");
	}
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		System.out.println("CallbackService] onStartCommand()");
		// startForeground(R.drawable.ic_launcher,getNotification(getResources().getString(R.string.app_name), "", false));
		return super.onStartCommand(intent, flags, startId);
	}
	@SuppressWarnings("deprecation")
	private Notification getNotification(String content, String did, boolean isAlarm) {
		Date date = new Date();
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String strDate = f.format(date);
		String titlePrompt = "";
		String title = "";
		PendingIntent pendingIntent = null;
		Intent intent = null;
		if (isAlarm) {

		} else {
			// titlePrompt = getResources().getString(R.string.app_name) + " " + content;
			// title = getResources().getString(R.string.app_name);
			intent = new Intent(Intent.ACTION_MAIN);
			intent.addCategory(Intent.CATEGORY_LAUNCHER);
			// intent.setClass(this, MainActivity.class);
		}
		// mNotify2 = new Notification(R.drawable.ic_launcher, titlePrompt, System.currentTimeMillis());
		mNotify2.flags = Notification.FLAG_ONGOING_EVENT;
		// pendingIntent = PendingIntent.getActivity(this, R.drawable.ic_launcher, intent, PendingIntent.FLAG_UPDATE_CURRENT);

		// RemoteViews views = new RemoteViews(getPackageName(), R.layout.notification_layout);
		mNotify2.contentIntent = pendingIntent;
		// mNotify2.contentView = views;
		// mNotify2.contentView.setTextViewText(R.id.no_title, title);
		// mNotify2.contentView.setTextViewText(R.id.no_content, content);
		// mNotify2.contentView.setTextViewText(R.id.no_time, strDate);
		// mNotify2.contentView.setImageViewResource(R.id.no_img, R.drawable.ic_launcher);

		if (isAlarm) {
			mNotify2.defaults = Notification.DEFAULT_ALL;
			mCustomMgr.notify(0, mNotify2);
		}
		return mNotify2;
	}

	// --callback method-----------------------------------
	void onLANSearchCallback(byte[] pData, int nDataSize) {
		if (iLanSearch != null) iLanSearch.onLANSearch(pData, nDataSize);
	}
	void onRecvMsgCallback(String pDID, int nMsgType, byte[] pMsg, int nMsgSize, int pUserData) {
		synchronized (m_listIMsg) {
			IMsg curImsg = null;
			for (int i = 0; i < m_listIMsg.size(); i++) {
				curImsg = m_listIMsg.get(i);
				curImsg.onMsg(pDID, nMsgType, pMsg, nMsgSize, pUserData);
			}
		}
	}
	void onEventCallback(String pDID, int nEventType, byte[] pEventData, int nEventDataSize, int pUserData)
	{
		if (iEvent != null) iEvent.onEvent(pDID, nEventType, pUserData);
	}

	// --interface-----------------------------------------
	private static ILANSearch iLanSearch = null;
	public static void setLANSearchInterface(ILANSearch ilan) {
		iLanSearch = ilan;
	}
	public interface ILANSearch {
		void onLANSearch(byte[] pData, int nDataSize);
	}

	void onStreamCallback(String pDID, byte[] pData, int nDataSize, int pUserData) {
		synchronized (m_listIStream) {
			IStream curIstream = null;
			for (int i = 0; i < m_listIStream.size(); i++) {
				curIstream = m_listIStream.get(i);
				if(curIstream != null) curIstream.onStream(pDID, pData, nDataSize, pUserData);
			}
		}
	}

	// IStream------
	public interface IStream {
		void onStream(String pDID, byte[] pData, int nDataSize, int pUserData);
	}
	// IStream---------
	public static void regIStream(IStream istream) {
		synchronized (m_listIStream) {
			if(istream != null && !m_listIStream.contains(istream)){
				m_listIStream.addLast(istream);
			}
		}
	}
	public static void unregIStream(IStream istream) {
		synchronized (m_listIStream) {
			if (istream != null && !m_listIStream.isEmpty()) {
				for (int i = 0; i < m_listIStream.size(); i++) {
					if (m_listIStream.get(i) == istream) {
						m_listIStream.remove(i);
						break;
					}
				}
			}
		}
	}

	// IMsg---------
	public static void regIMsg(IMsg imsg) {
		synchronized (m_listIMsg) {
			if (imsg != null && !m_listIMsg.contains(imsg))m_listIMsg.addLast(imsg);
		}
	}
	public static void unregIMsg(IMsg imsg) {
		synchronized (m_listIMsg) {
			if (imsg != null && !m_listIMsg.isEmpty()) {
				for (int i = 0; i < m_listIMsg.size(); i++) {
					if (m_listIMsg.get(i) == imsg) {
						m_listIMsg.remove(i);
						break;
					}
				}
			}
		}
	}
	public interface IMsg {
		void onMsg(String pDID, int nMsgType, byte[] pMsg, int nMsgSize, int pUserData);
	}
	// IEvent-------
	private static IEvent iEvent = null;
	public static void setEventInterface(IEvent ie) {
		iEvent = ie;
	}
	public interface IEvent {
		void onEvent(String pDID, int nEventType, int pUserData);
	}
}
