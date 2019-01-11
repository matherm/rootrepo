package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.util.HashMap;

import net.sf.andpdf.nio.ByteBuffer;
import net.sf.andpdf.refs.HardReference;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import com.pdfjet.A4;
import com.pdfjet.Image;
import com.pdfjet.ImageType;
import com.pdfjet.PDF;
import com.pdfjet.Page;
import com.sun.pdfview.PDFFile;
import com.sun.pdfview.PDFImage;
import com.sun.pdfview.PDFPage;
import com.sun.pdfview.PDFPaint;

/**
 * 
 * This pdf utils allow loading PDFs as images and storing pages both as PNGs
 * and PDFs for further processing.
 * 
 * Used libraries: Open Source PDFJet (BSD License)
 * http://pdfjet.com/os/edition.html PDFViewer (LGPL)
 * https://github.com/jblough/Android-Pdf-Viewer-Library
 * 
 * 
 * @author Matthias
 * 
 */
public class PDFUtils {

	public static final String TAG = PDFUtils.class.getName();

	public static final float SCALE_SCREEN = 100f;
	public static final float SCALE_PRINT_1X = 1f;
	public static final float SCALE_PRINT_PNG_2X = 2f;
	public static final float SCALE_PRINT_PNG_3X = 3f;

	static {
		// Settings
		PDFImage.sShowImages = true; // show images
		PDFPaint.s_doAntiAlias = true; // make text smooth
		HardReference.sKeepCaches = false; // save images in cache
	}

	public static Bitmap loadPDFImageForDisplay(Context ctx, int pageNum,
			String assetFilename, int viewSize) {
		return loadPDFImage(ctx, pageNum, assetFilename, viewSize, SCALE_SCREEN);
	}

	public static Bitmap loadPDFImage(Context ctx, int pageNum,
			String assetFilename, float scale) {
		return loadPDFImage(ctx, pageNum, assetFilename, 0, scale);
	}

	private static HashMap<String, Integer> INTEGERCACHE = new HashMap<String, Integer>();

	public static int pageSize(Context ctx, String assetFilename) {
		PDFFile pdf;
		Integer pageSize = INTEGERCACHE.get(assetFilename);
		if (pageSize != null) {
			// Log.d(TAG, "Cache hit!");
		} else {
			try {
				pdf = loadFile(ctx, assetFilename);
				pageSize = pdf.getNumPages();
				INTEGERCACHE.put(assetFilename, pageSize);
			} catch (IOException e) {
				Log.e(TAG, "Could not load file and number of pages", e);
			}
		}
		return pageSize;
	}



	public static void storePNGAsPDFPagePDFJET(File dir, InputStream src,
			String outFilename) {
		try {
			File outFile = new File(dir, outFilename);
			FileOutputStream fos = new FileOutputStream(outFile);
			PDF pdf = new PDF(fos);
			Image image = new Image(pdf, src, ImageType.PNG);
			Page page = new Page(pdf, A4.PORTRAIT);
//			image.getHeight();
//			page.getHeight();
			float pageWidth = page.getWidth();
			float imageWidth = image.getWidth();
			float scale = pageWidth / imageWidth;
			image.scaleBy(scale);
			image.setPosition(0, 0);
			image.drawOn(page);
			pdf.flush();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	
	public static void storeAllPNGSAsPDFPagePDFJET(File inDir, File dir,
			String outFilename) {
		try {
			File outFile = new File(dir, outFilename);
			FileOutputStream fos = new FileOutputStream(outFile);
			PDF pdf = new PDF(fos);
			File[] filesToProcess = inDir.listFiles();
			InputStream is;
			for (int i = 0; i < filesToProcess.length; i++) {
				is = new FileInputStream(filesToProcess[i]);
				Image image = new Image(pdf, is, ImageType.PNG);
				Page page = new Page(pdf, A4.PORTRAIT);
//				image.getHeight();
//				page.getHeight();
				float pageWidth = page.getWidth();
				float imageWidth = image.getWidth();
				float scale = pageWidth / imageWidth;
				image.scaleBy(scale);
				image.setPosition(0, 0);
				image.drawOn(page);
				is.close();
			}
			pdf.flush();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static void buildCache(Context ctx, String assetFilename,
			int viewSize, float scale) {
		try {
			int size = pageSize(ctx, assetFilename);
			// Get the first page from the pdf doc
			for (int i = 1; i < size + 1; i++) {
				File cachedFile = getCachedPNGFile(ctx, assetFilename, i);
				if (cachedFile.exists()) {
					Log.d(TAG, "buildCache() already cached: " + i);
				} else {
					loadPDFImage(ctx, i, assetFilename, viewSize, scale);
					Log.d(TAG, "buildCache() added to cache: " + i);
				}
			}

		} catch (Exception e) {
			Log.e(TAG, e.toString(), e);
		}

	}

	public static File getPNGPage(Context ctx, String assetFilename,
			int viewSize, float scale, int pageNum) {
		File page = null;
		try {
			File cachedFile = getCachedPNGFile(ctx, assetFilename, pageNum);
			if (cachedFile.exists()) {
				Log.d(TAG, "getPNGPage() Cached PNG returned");
				page = cachedFile;
			} else {
				// Cache
				Log.d(TAG, "getPNGPage() Bitmap cached as PNG");
				loadPDFImage(ctx, pageNum, assetFilename, viewSize, scale);
				page = getCachedPNGFile(ctx, assetFilename, pageNum);
			}
		} catch (Exception e) {
			Log.e(TAG, e.toString(), e);
		}
		return page;
	}


	private static Bitmap loadPDFImage(Context ctx, int pageNum,
			String assetFilename, int viewSize, float scale) {
		Bitmap page = null;
		try {
			PDFFile pdf = loadFile(ctx, assetFilename);
			File cachedFile = getCachedPNGFile(ctx, assetFilename, pageNum);
			if (cachedFile.exists()) {
				Bitmap cachedBitmap = BitmapFactory
						.decodeStream(new FileInputStream(cachedFile));
				Log.d(TAG, "loadPDFImage() Cached Bitmap returned");
				page = cachedBitmap;
			} else {
				// Get the first page from the pdf doc
				PDFPage PDFpage = pdf.getPage(pageNum, true);
				// final float scale = 1;
				// create a scaling value according to the WebView Width
				if (scale == SCALE_SCREEN) {
					scale = viewSize / PDFpage.getWidth() * 0.95f;
				}
				Log.d(TAG, "loadPDFImage() Bitmap cached as PNG " + pageNum
						+ " via Library: Width: " + (int) PDFpage.getWidth()
						+ " height: " + (int) PDFpage.getHeight() + " scale: "
						+ scale);

				// convert the page into a bitmap with a scaling value
				 page = PDFpage.getImage((int) (PDFpage.getWidth() * scale),
				 (int) (PDFpage.getHeight() * scale), null, true, true);
//				page = PDFpage.getImage((int) PDFpage.getWidth()/2,
//						(int) PDFpage.getHeight()/2, null, true, true);
				 //Cache
				writeCachedPNGFile(ctx, assetFilename, page, pageNum);
			}
		} catch (Exception e) {
			Log.e(TAG, e.toString(), e);
		}
		return page;
	}

	private static File getCachedPNGFile(Context ctx, String assetFilename,
			int pos) {
		return new File(ctx.getCacheDir(), pos + "_" + assetFilename + ".png");
	}

	private static File writeCachedPNGFile(Context ctx, String assetFilename,
			Bitmap bitmap, int pos) {
		return BitmapHelper.storeBitmapAsPNG(ctx.getCacheDir(), pos + "_" + assetFilename
				+ ".png", bitmap);
	}

	private static PDFFile loadFile(Context ctx, String assetFilename)
			throws IOException {
		File file = AssetCacheHelper.getCachedFileFromAsset(ctx, assetFilename);
		RandomAccessFile raf = new RandomAccessFile(file, "r");
		FileChannel channel = raf.getChannel();
		ByteBuffer bb = ByteBuffer.NEW(channel.map(
				FileChannel.MapMode.READ_ONLY, 0, channel.size()));
		raf.close();
		// create a pdf doc
		PDFFile pdf = new PDFFile(bb);
		return pdf;
	}
	
	

}
