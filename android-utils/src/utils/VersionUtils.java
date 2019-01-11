package utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;

/**
 * @brief This class provides some functionality to retrieve the version codes
 *        of the application
 * @author Matthias
 * 
 */
public class VersionUtils {

	public static final String TAG = VersionUtils.class.getName();

	/**
	 * Returns the version code of the installed application
	 * 
	 * @param context
	 * @return
	 */
	public static int getVersionCode(Context context) {
		PackageInfo manager = null;
		try {
			manager = context.getPackageManager().getPackageInfo(
					context.getPackageName(), 0);
		} catch (NameNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return manager.versionCode;
	}

	/**
	 * Returns the version name of the installed application
	 * 
	 * @param context
	 * @return
	 */
	public static String getVersionName(Context context) {
		PackageInfo manager = null;
		try {
			manager = context.getPackageManager().getPackageInfo(
					context.getPackageName(), 0);
		} catch (NameNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return manager.versionName;
	}

	public static final int KITKAT_API_LEVEL = 19;
	public static final int DONUT_API_LEVEL = 4;
	public static final int ICS_API_LEVEL = 14;
	public static final int JB_API_LEVEL = 16;

	public static boolean isApiLevelAtLeast(Context context, int apiLevel) {
		return (android.os.Build.VERSION.SDK_INT >= apiLevel) ? true : false;

	}

}