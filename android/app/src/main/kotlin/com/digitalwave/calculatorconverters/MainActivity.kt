package com.digitalwave.calculatorconverters

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.digitalwave.calculatorconverters/app_share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "shareApp" || call.method == "shareApk") {
                try {
                    val apkFile = File(applicationInfo.sourceDir)
                    val cacheApk = File(cacheDir, "Calculator_Converters.apk")

                    // Copy installed APK file to cache directory with clean filename
                    FileInputStream(apkFile).use { input ->
                        FileOutputStream(cacheApk).use { output ->
                            input.copyTo(output)
                        }
                    }

                    val uri = FileProvider.getUriForFile(
                        context,
                        "${context.packageName}.fileprovider",
                        cacheApk
                    )

                    val shareIntent = Intent(Intent.ACTION_SEND).apply {
                        type = "application/vnd.android.package-archive"
                        putExtra(Intent.EXTRA_STREAM, uri)
                        putExtra(Intent.EXTRA_SUBJECT, "Calculator & Converters App")
                        putExtra(Intent.EXTRA_TEXT, "Check out Calculator & Converters app!")
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }

                    startActivity(Intent.createChooser(shareIntent, "Share Calculator & Converters APK"))
                    result.success(true)
                } catch (e: Exception) {
                    result.error("SHARE_ERROR", e.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
