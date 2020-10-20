package com.example.leo_app;

import android.content.Intent;
import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import android.util.Log;

public class MainActivity extends FlutterActivity {

  private String sharedText;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
//     GeneratedPluginRegistrant.registerWith(this);
    Intent intent = new Intent(Intent.ACTION_SEND); // getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    Log.d("---1------1------1---","1");
    Log.d("should be action send", action);
//    Log.d("should be action send", type);

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        handleSendText(intent); // Handle text being sent
      }
    }

    new MethodChannel(getFlutterView(), "app.channel.shared").setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, MethodChannel.Result result) {
          if (call.method.contentEquals("getSharedText")) {
            result.success(sharedText);
            sharedText = null;
          }
        }
      });
  }

  void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    Log.d("-------URL--------", sharedText);
  }
}

// public class MainActivity extends FlutterActivity {

//   private String url;
//   private String title;

//   @Override
//   protected void onCreate(Bundle savedInstanceState) {
//     super.onCreate(savedInstanceState);
//     // GeneratedPluginRegistrant.registerWith(this);

//     new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
//       new MethodCallHandler() {
//         @Override
//         public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//           if (call.method.contentEquals("getPageData")) {
            
//             Map<String, String> pageInfo = new HashMap<>();
//             pageInfo.put("url", url);
//             pageInfo.put("title", title);

//             result.success(pageInfo);

//             url = null;
//             title = null;
//           }
//         }
//       }
//     );
//   }

//   @Override
//   protected void onResume() {
//     super.onResume();
//     intentHandler();
//   }

//   void intentHandler() {
//     Intent intent = getIntent();
//     String action = intent.getAction();
//     String type = intent.getType();

//     if (Intent.ACTION_SEND.equals(action) && type != null) {
//       if ("text/plain".equals(type)) {
//         // intentHandler(intent); // Handle text being sent
//         Bundle bundle = intent.getExtras();
//         url = intent.getStringExtra(Intent.EXTRA_TEXT);
//         title = intent.getStringExtra(Intent.EXTRA_SUBJECT);
//       }
//     }
//   }
// }