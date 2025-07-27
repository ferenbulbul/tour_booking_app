package com.tourbooking.app

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent

class MainActivity: FlutterActivity() {
  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    // Bu satır çok önemli: FlutterActivity'ye yeni Intent'i iletir
    setIntent(intent)
  }
}
