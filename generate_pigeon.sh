flutter pub run pigeon \
  --input pigeons/platform_app_security.dart \
  --dart_out lib/app_security_api.dart \
  --kotlin_out android/src/main/kotlin/com/example/app_security/AppSecurityApi.kt \
  --kotlin_package com.example.app_security \
  --swift_out ios/Classes/AppSecurityApi.swift
