package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

public class AssetCacheHelper {

	public static final String TAG = AssetCacheHelper.class.getName();

	public static File getCacheDir(Context ctx) {
		File dir = ctx.getCacheDir();
		dir.mkdirs();
		return dir;
	}
	
	public static File getExternalCacheDir(Context ctx) {
		File dir = ctx.getExternalCacheDir();
		dir.mkdirs();
		return dir;
	}
	
	
	public static File getAbosoluteFile(String relativePath, Context context) {
		Log.d(TAG, context.getExternalCacheDir().getAbsolutePath());
		Log.d(TAG, Environment.getExternalStorageDirectory()
				.getAbsolutePath());
		Log.d(TAG, Environment.getExternalStorageDirectory()
				.getAbsolutePath());
		Log.d(TAG, context.getFilesDir().getAbsolutePath());
		if (Environment.MEDIA_MOUNTED.equals(Environment
				.getExternalStorageState())) {
			return new File(context.getExternalFilesDir(null), relativePath);
		} else {
			return new File(context.getFilesDir(), relativePath);
		}
	}

	public static File getCachedFileFromAsset(Context ctx, String assetFilename) {
		File tmpFile = null;
		InputStream fis = null;
		try {
			fis = ctx.getAssets().open(assetFilename);
			// We'll create a file in the application's cache directory
			// File dir = Environment.getExternalStorageDirectory();
			File dir = ctx.getCacheDir();
			dir.mkdirs();
			tmpFile = new File(dir, assetFilename);
			boolean exists = tmpFile.exists();
			if (!exists) {
				writeCacheFile(tmpFile, fis);
			}
			// Read your file here
		} catch (IOException e) {
			Log.e(TAG, "Failed reading asset", e);
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (IOException e) {
				}
			}
		}
		return tmpFile;
	}

	private static void writeCacheFile(File destTempFile, InputStream fis) {
		FileOutputStream fos = null;
		try {
			// Write the asset file to the temporary location
			fos = new FileOutputStream(destTempFile);
			byte[] buffer = new byte[1024];
			int bufferLen;
			while ((bufferLen = fis.read(buffer)) != -1) {
				fos.write(buffer, 0, bufferLen);
			}
		} catch (IOException e) {
			Log.e(TAG, "Could not write cache file", e);
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
				}
			}
		}
	}

	public static InputStream readCacheFile(String fName, Context ctx) {
		File dir = ctx.getCacheDir();
		dir.mkdirs();
		File tmpFile = new File(dir, fName);
		try {
			return new FileInputStream(tmpFile);
		} catch (FileNotFoundException e) {
			Log.d(TAG, "Could not read Cache File");
		}
		return null;
	}

	public static InputStream readExternalCacheFile(String fName, Context ctx) {
		File dir = ctx.getExternalCacheDir();
		dir.mkdirs();
		File tmpFile = new File(dir, fName);
		try {
			return new FileInputStream(tmpFile);
		} catch (FileNotFoundException e) {
			Log.d(TAG, "Could not read Cache File");
		}
		return null;
	}
	
	public static void writeCacheFile(String fileName, InputStream fis,
			Context ctx) {
		// We'll create a file in the application's cache directory
		// File dir = Environment.getExternalStorageDirectory();
		File dir = ctx.getCacheDir();
		dir.mkdirs();
		File tmpFile = new File(dir, fileName);
		// We'll create a file in the application's cache directory
		// File dir = Environment.getExternalStorageDirectory();
		writeCacheFile(tmpFile, fis);
	}
	
	
	public static void writeExternalCacheFile(String fileName, InputStream fis,
			Context ctx){
		// We'll create a file in the application's cache directory
		// File dir = Environment.getExternalStorageDirectory();
		File dir = ctx.getExternalCacheDir();
		dir.mkdirs();
		File tmpFile = new File(dir, fileName);
		// We'll create a file in the application's cache directory
		// File dir = Environment.getExternalStorageDirectory();
		writeCacheFile(tmpFile, fis);
	}

	public static InputStream getFileFromAsset(Context ctx, String assetFilename) {
		InputStream fis = null;
		try {
			fis = ctx.getAssets().open(assetFilename);
		} catch (IOException e) {
			Log.e(TAG, "Failed reading asset", e);
		}
		return fis;

	}

	public static void clearCache(Context context) {
		File cache = context.getCacheDir();
		File[] files = cache.listFiles();
		for (int i = 0; i < files.length; i++) {
			files[i].delete();
		}
	}
	
	
	public static void clearExternalCache(Context context) {
		File cache = context.getExternalCacheDir();
		File[] files = cache.listFiles();
		for (int i = 0; i < files.length; i++) {
			files[i].delete();
		}
	}

}
