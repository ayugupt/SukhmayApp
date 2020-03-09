package com.example.sukhmay;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.Intent;

import androidx.core.content.ContextCompat;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class MainActivity extends FlutterActivity {

  private Intent forService;
  /*DatabaseReference database;
  FirebaseAuth auth = FirebaseAuth.getInstance();
  LocationManager locationManager;
  String uid;*/

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    //uid = auth.getUid();

    //locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    /*if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 5, listener);
    }*/


    forService =  new Intent(MainActivity.this, MyService.class);
    //startService();


    new MethodChannel(getFlutterView(), "com.example.sukhmay.messages").setMethodCallHandler(new MethodChannel.MethodCallHandler(){
        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result){
           if(methodCall.method.equals("startService"))
           {
              startService();
              result.success(MyService.victimUid);
           }
        }
    });
  }

    /*LocationListener listener = new LocationListener() {
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
    };*/


  void startService()
  {
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
      startForegroundService(forService);
   }
   else
   {
     startService(forService);
   }
     /* if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
          locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 5, listener);
      }*/

  }
}
