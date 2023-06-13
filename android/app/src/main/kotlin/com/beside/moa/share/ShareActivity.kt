package com.beside.moa.share

import android.os.Bundle
import android.util.Base64
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.AlertDialog
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.fragment.app.FragmentActivity
import java.nio.charset.Charset


class ShareActivity : FragmentActivity(){




//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_CHANNEL).setMethodCallHandler {
//            call, result ->
//            if (call.method == "shareSheet") {
//              shareSheet(result)
//            } else {
//                result.notImplemented()
//            }
//        }
//    }

    override fun onCreate(savedInstanceState: Bundle?) {
        setContent {
            BottomSheetContent()
        }
//        handleIntent(intent, true)
        super.onCreate(savedInstanceState)
    }

    @Composable
    fun ShowPopup() {
      var isPopupVisible by remember { mutableStateOf(true) }
      if(isPopupVisible){
        AlertDialog(
            onDismissRequest = {
                this.finish()
            },
            title = { Text(text = "Popup Title") },
            text = { Text(text = "This is a simple popup.") },
            confirmButton = {
                Button(onClick = {
                    this.finish()
                }) {
                    Text(text = "OK")
                }
            }
        )
      }
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
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color.White)
                    .padding(16.dp),
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
