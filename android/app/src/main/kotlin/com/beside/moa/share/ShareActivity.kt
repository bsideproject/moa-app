package com.beside.moa.share

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class ShareActivity: FlutterActivity() {
    private val CHANNEL = "com.beside.moa/share"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "shareSheet"){
                result.success("shareSheet")
            }
            else{
                result.success("")
            }
        }
    }
}