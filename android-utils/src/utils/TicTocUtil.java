package utils;

import java.util.Date;
import java.util.HashMap;

import android.util.Log;

public class TicTocUtil {
	
	public static final String TAG = TicTocUtil.class.getName();
	
	private static HashMap<String, Long> mTics = new HashMap<String, Long>();
	
	public static void tic(String tag){
//		Log.d(TAG, "tic(): " + tag);
		mTics.put(tag, Long.valueOf(new Date().getTime()));
	}
	
	public static void toc(String tag){
		long toc = new Date().getTime();
		Log.d(TAG, "toc(): " + tag + " => " +(toc - mTics.get(tag).longValue()) + "ms");
	}

}
