package com.beside.moa.share


import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.compose.foundation.layout.Column
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import com.beside.moa.R
import io.flutter.embedding.android.FlutterActivity


class ShareActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // todo flutter 에서 ui를 전달받아서 띄워줘야함 
        setContentView(R.layout.activity_share)
        handleIntent(intent, true)
    }

    private fun handleIntent(intent: Intent, initial: Boolean) {
        val value = intent.getStringExtra(Intent.EXTRA_TEXT)
        Log.d("TAG", "The value is: $value")

//        when {
//            (intent.type?.startsWith("text") != true)
//                    && (intent.action == Intent.ACTION_SEND
//                    || intent.action == Intent.ACTION_SEND_MULTIPLE) -> { // Sharing images or videos
//
//                val value = getMediaUris(intent)
//                if (initial) initialMedia = value
//                latestMedia = value
//                eventSinkMedia?.success(latestMedia?.toString())
//            }
//            (intent.type == null || intent.type?.startsWith("text") == true)
//                    && intent.action == Intent.ACTION_SEND -> { // Sharing text
//                val value = intent.getStringExtra(Intent.EXTRA_TEXT)
//                if (initial) initialText = value
//                latestText = value
//                eventSinkText?.success(latestText)
//            }
//            intent.action == Intent.ACTION_VIEW -> { // Opening URL
//                val value = intent.dataString
//                if (initial) initialText = value
//                latestText = value
//                eventSinkText?.success(latestText)
//            }
//        }
    }


}

