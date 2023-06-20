package com.beside.moa.share

import android.os.Bundle
import android.widget.FrameLayout
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.activity.compose.setContent
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.FragmentActivity
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor


class ShareActivity: FragmentActivity() {
    private lateinit var flutterView: FlutterView
    private val CHANNEL = "com.beside.moa/share"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create a FrameLayout to hold the Flutter view
        val flutterContainer = FrameLayout(this)

        // Create a FlutterEngine and connect it to the Flutter view
        val flutterEngine = FlutterEngine(this)

        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "showOverlay"
            )
        )
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//                call, result ->
//            if(call.method == "shareSheet"){
//                result.success("shareSheet")
//            }
//            else{
//                result.success("")
//            }
//        }


//        setContentView(R.layout.flutter_view_layout)
//        flutterView = findViewById(R.id.flutter_view)
//        flutterView.attachToFlutterEngine(flutterEngine)

//        var rootView = window.decorView.rootView as ViewGroup
        // Add the FrameLayout as an overlay view to the Android app
//        rootView.addView(flutterContainer)

//        GeneratedPluginRegistrant.registerWith(flutterEngine)
        setContent {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .clickable(
                        onClick = {
                            this.finish()
                            flutterView.detachFromFlutterEngine()
                        },
                    ),
                contentAlignment = Alignment.BottomEnd
            ){
                Box(
                    modifier= Modifier
                        .clip(RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp))
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(Color.White)
                            .padding(15.dp)
                    ) {
                        IconButton(
                            onClick = {
                                this@ShareActivity.finish()
                            },
                            modifier = Modifier.padding(8.dp)
                        ) {
                            Icon(Icons.Filled.Close, contentDescription = "Close")
                        }
                        AndroidView(
                            factory = { context ->
                                flutterView = FlutterView(context)
                                flutterView.attachToFlutterEngine(flutterEngine)

                                flutterView
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(360.dp),
                        )
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterView.detachFromFlutterEngine()
    }

    @Composable
    fun BottomSheetContent() {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .clickable(
                    onClick = {
                        this.finish()
                    },
                ),
            contentAlignment = Alignment.BottomEnd
        ){
            Box(
                modifier= Modifier
                    .clip(RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp))
                    .background(Color.Blue)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color.White)
                        .padding(16.dp)
                ) {
                    Text(text = "Bottom Sheet Content", fontSize = 16.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    Button(
                        onClick = {
                            this@ShareActivity.finish()
                        },
                        modifier = Modifier.align(Alignment.End)
                    ) {
                        Text(text = "Close")
                    }
                }
            }

        }
    }
}
