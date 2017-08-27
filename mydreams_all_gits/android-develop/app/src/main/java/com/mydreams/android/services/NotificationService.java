package com.mydreams.android.services;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.widget.Toast;

import com.mydreams.android.Config;

public class NotificationService extends Service {

    public NotificationService() {

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String errorMessage = intent.getStringExtra(Config.INTENT_SERVER_ERR_MSG);
        Toast.makeText(getApplicationContext(), errorMessage, Toast.LENGTH_SHORT).show();
        return START_NOT_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    }
}
