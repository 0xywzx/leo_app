// package com.example.leo_app;

// import android.content.Intent;
// import android.os.Bundle;
// import android.app.Activity;
// import android.view.View;

// import java.nio.ByteBuffer;

// import io.flutter.app.FlutterActivity;
// import io.flutter.plugin.common.ActivityLifecycleListener;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
// import io.flutter.plugins.GeneratedPluginRegistrant;

// public class SendActivity extends Activity {

//   // private String sharedText;

//   @Override
//   protected void onCreate(Bundle savedInstanceState) {
//     super.onCreate(savedInstanceState);
//     setContentView(R.layout.activity_send);
//     // GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
//     Intent intent = getIntent();
//     String action = intent.getAction();
//     String type = intent.getType();

//   //   if (Intent.ACTION_SEND.equals(action) && type != null) {
//   //     if ("text/plain".equals(type)) {
//   //       handleSendText(intent); // Handle text being sent
//   //     }
//   //   }

//   //   new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
//   //     new MethodCallHandler() {
//   //       @Override
//   //       public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//   //         if (call.method.contentEquals("getSharedText")) {
//   //           result.success(sharedText);
//   //           sharedText = null;
//   //         }
//   //       }
//   //     }
//   //   );
//   }

//   // void handleSendText(Intent intent) {
//   //   sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
//   // }
// }