package com.example.app_security

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class AppSecurityPlugin : FlutterPlugin, ActivityAware {

  private var activity: Activity? = null
  private var appSecurityApiImpl: AppSecurityApiImpl? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    appSecurityApiImpl = AppSecurityApiImpl(flutterPluginBinding.applicationContext)
    AppSecurityApi.setUp(
      flutterPluginBinding.binaryMessenger,
      appSecurityApiImpl
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AppSecurityApi.setUp(binding.binaryMessenger, null)
    appSecurityApiImpl = null
  }

  // ActivityAware overrides
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    appSecurityApiImpl?.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
    appSecurityApiImpl?.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }
}
