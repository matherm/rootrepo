package utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Debug.MemoryInfo;
import android.util.Log;

public class BitmapHelper {

	public static final String TAG = BitmapHelper.class.getName();

	public static Bitmap decodeSampledBitmapFromResourceMemOpt(
			InputStream inputStream, int reqWidth, int reqHeight, Context ctx) {

		byte[] byteArr = new byte[0];
		byte[] buffer = new byte[1024];
		int len;
		int count = 0;

		try {
			while ((len = inputStream.read(buffer)) > -1) {
				if (len != 0) {
					if (count + len > byteArr.length) {
						byte[] newbuf = new byte[(count + len) * 2];
						System.arraycopy(byteArr, 0, newbuf, 0, count);
						byteArr = newbuf;
					}

					System.arraycopy(buffer, 0, byteArr, count, len);
					count += len;
				}
			}

			final BitmapFactory.Options options = new BitmapFactory.Options();
			options.inJustDecodeBounds = true;
			BitmapFactory.decodeByteArray(byteArr, 0, count, options);

			options.inSampleSize = calculateInSampleSize(options, reqWidth,
					reqHeight);
			options.inPurgeable = true;
			options.inInputShareable = true;
			options.inJustDecodeBounds = false;
			options.inPreferredConfig = Bitmap.Config.ARGB_8888;

			int[] pids = { android.os.Process.myPid() };
			ActivityManager activityManager = (ActivityManager) ctx
					.getSystemService(Context.ACTIVITY_SERVICE);
			MemoryInfo myMemInfo = activityManager.getProcessMemoryInfo(pids)[0];
			Log.e(TAG, "dalvikPss (decoding) = " + myMemInfo.dalvikPss);
			return BitmapFactory.decodeByteArray(byteArr, 0, count, options);
		} catch (Exception e) {
			e.printStackTrace();

			return null;
		}
	}
	
	
	public static Bitmap calculateBounds(InputStream is, BitmapFactory.Options options){
		options.inJustDecodeBounds = true;
		return BitmapFactory.decodeStream(is, null, options);
	}
	
	
	public static Bitmap decodeStream(InputStream is, BitmapFactory.Options options, int reqWidth, int reqHeight){
		options.inSampleSize = BitmapHelper.calculateInSampleSize(options, reqWidth,
				reqHeight);
		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;
		return BitmapFactory.decodeStream(is, null, options);
	}

	public static Bitmap decodeSampledBitmapFromPath(String path, int reqWidth,
			int reqHeight) {

		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(path, options);

		options.inSampleSize = calculateInSampleSize(options, reqWidth,
				reqHeight);

		// Decode bitmap with inSampleSize set
		options.inJustDecodeBounds = false;
		Bitmap bmp = BitmapFactory.decodeFile(path, options);
		return bmp;
	}
	
	public static File storeBitmapAsPNG(File dir, String destFilename,
			Bitmap bitmap) {
		File fBitmap = null;
		;
		FileOutputStream out = null;
		try {
			fBitmap = new File(dir, destFilename);
			out = new FileOutputStream(fBitmap);
			bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
			// bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
			return fBitmap;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				out.close();
			} catch (Throwable ignore) {
			}
		}
		return fBitmap;

	}


	public static int calculateInSampleSize(BitmapFactory.Options options,
			int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (height > reqHeight || width > reqWidth) {

			final int halfHeight = height / 2;
			final int halfWidth = width / 2;

			// Calculate the largest inSampleSize value that is a power of 2 and
			// keeps both
			// height and width larger than the requested height and width.
			while ((halfHeight / inSampleSize) > reqHeight
					&& (halfWidth / inSampleSize) > reqWidth) {
				inSampleSize *= 2;
			}
		}

		return inSampleSize;
	}
}
