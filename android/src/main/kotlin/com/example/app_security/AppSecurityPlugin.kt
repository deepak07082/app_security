package com.example.app_security

import android.content.Context
import com.example.app_security.AppSecurityApi
import com.example.app_security.AppSecurityApiImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin


class AppSecurityPlugin: FlutterPlugin {
 
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    AppSecurityApi.setUp(
      flutterPluginBinding.binaryMessenger,
      AppSecurityApiImpl(flutterPluginBinding.applicationContext)
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AppSecurityApi.setUp(binding.binaryMessenger, null)
  }
}
