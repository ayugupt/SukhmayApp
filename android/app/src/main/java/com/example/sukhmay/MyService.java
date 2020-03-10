package com.example.sukhmay;

import android.Manifest;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import android.os.VibrationEffect;
import android.os.Vibrator;


public class MyService extends Service{

    DatabaseReference database;
    FirebaseAuth auth = FirebaseAuth.getInstance();
    LocationManager locationManager;
    String uid;
    Uri notification;
    Ringtone r;
    static String victimUid = "";

    NotificationCompat.Builder buildIt;
    NotificationManagerCompat notificationManager;

    int notificationId = 1321;


    @Override
    public void onCreate() {
        super.onCreate();

        uid = auth.getUid();
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        FirebaseDatabase.getInstance().getReference("Users/" + uid + "/helping").addChildEventListener(childListener);

        notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
        r = RingtoneManager.getRingtone(getApplicationContext(), notification);

        if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 10, listener);
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"messages")
                            .setContentText("This is running in background")
                            .setContentTitle("Flutter Background").setSmallIcon(R.drawable.launch_background);


             startForeground(101, builder.build());
        }

        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, 0);

         buildIt = new NotificationCompat.Builder(this, "help").setSmallIcon(R.drawable.launch_background)
                .setContentText("Help Needed!")
                .setContentTitle("Someone's in need of help").setPriority(NotificationCompat.PRIORITY_HIGH).setContentIntent(pendingIntent).setAutoCancel(true);

        notificationManager = NotificationManagerCompat.from(this);



    }

    ChildEventListener childListener = new ChildEventListener() {
        @Override
        public void onChildAdded(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {


            notificationManager.notify(notificationId, buildIt.build());
            //startForeground(101, buildIt.build());


            victimUid = dataSnapshot.getValue().toString();
            FirebaseDatabase.getInstance().getReference("SOS/" + victimUid).addChildEventListener(victimListener);
            if (Build.VERSION.SDK_INT >= 26) {
                ((Vibrator) getSystemService(VIBRATOR_SERVICE)).vibrate(VibrationEffect.createOneShot(2000, VibrationEffect.DEFAULT_AMPLITUDE));
            } else {
                ((Vibrator) getSystemService(VIBRATOR_SERVICE)).vibrate(150);
            }

        }

        @Override
        public void onChildChanged(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

        }

        @Override
        public void onChildRemoved(@NonNull DataSnapshot dataSnapshot) {

        }

        @Override
        public void onChildMoved(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

        }

        @Override
        public void onCancelled(@NonNull DatabaseError databaseError) {

        }
    };


    ChildEventListener victimListener = new ChildEventListener() {
        @Override
        public void onChildAdded(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

        }

        @Override
        public void onChildChanged(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

        }

        @Override
        public void onChildRemoved(@NonNull DataSnapshot dataSnapshot) {
           FirebaseDatabase.getInstance().getReference("Users/" + uid + "/helping").removeValue();
        }

        @Override
        public void onChildMoved(@NonNull DataSnapshot dataSnapshot, @Nullable String s) {

        }

        @Override
        public void onCancelled(@NonNull DatabaseError databaseError) {

        }
    };

    LocationListener listener = new LocationListener() {
        @Override
        public void onLocationChanged(Location location) {
            database = FirebaseDatabase.getInstance().getReference("Users/" + uid + "/Latitude");
            database.setValue(location.getLatitude());
            database = FirebaseDatabase.getInstance().getReference("Users/" + uid + "/Longitude");
            database.setValue(location.getLongitude());
        }

        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {

        }

        @Override
        public void onProviderEnabled(String s) {

        }

        @Override
        public void onProviderDisabled(String s) {

        }
    };



    @Nullable
    @Override
    public IBinder onBind(Intent intent){
        return null;
    }
}
