package utils;


import com.example.utils.R;

import android.app.NotificationManager;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.app.NotificationCompat;
import android.widget.Toast;

public class NotifierUtil {
	
	/**
	 * Show a notification while this service is running.
	 */
	public static void showNotification(final Context context, final int icon,
			final CharSequence text) {
		// In this sample, we'll use the same text for the ticker and the
		// expanded notification

		// Set the icon, scrolling text and timestamp
		// Notification notification = new Notification(
		// R.drawable.stat_notify_sync,
		// context.getText(de.htwg.konstanz.uclab.safesa.R.string.app_name),
		// System.currentTimeMillis());

		NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
				context)
				.setSmallIcon(icon)
				.setContentTitle(
						context.getText(R.string.app_name))
				.setContentText(text);
		mBuilder.build();

		// The PendingIntent to launch our activity if the user selects this
		// notification
		// PendingIntent contentIntent = PendingIntent.getActivity(this, 0,
		// new Intent(this, StatusDetectionService.class), 0);

		// Set the info for the views that show in the notification panel.
		// notification.setLatestEventInfo(context, "", text, null);

		// Send the notification.
		// We use a string id because it is a unique number. We use it later to
		// cancel.
		NotificationManager nM = (NotificationManager) context
				.getSystemService(Context.NOTIFICATION_SERVICE);
		nM.notify(1, mBuilder.build());
	}

	/**
	 * Create a toast in app.
	 * 
	 * @param Context context
	 * @param String text
	 */
	public static void showToast(final Context context, final String text) {
		// Handler for posting ui stuff
		Handler handler = new Handler(Looper.getMainLooper());
		
		handler.post(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(context, text, Toast.LENGTH_LONG).show();
			}
		});
	}
}
