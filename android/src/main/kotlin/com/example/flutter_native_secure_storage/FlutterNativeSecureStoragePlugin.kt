package com.example.flutter_native_secure_storage

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterNativeSecureStoragePlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var cryptoHelper: CryptoHelper   // ✅ DECLARED

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        context = flutterPluginBinding.applicationContext
        cryptoHelper = CryptoHelper(context)           // ✅ INITIALIZED

        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_native_secure_storage"
        )
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {

                "write" -> {
                    val key = call.argument<String>("key")!!
                    val value = call.argument<String>("value")!!
                    cryptoHelper.encryptAndStore(key, value)
                    result.success(null)
                }

                "read" -> {
                    val key = call.argument<String>("key")!!
                    val value = cryptoHelper.decrypt(key)
                    result.success(value)
                }

                "delete" -> {
                    val key = call.argument<String>("key")!!
                    cryptoHelper.delete(key)
                    result.success(null)
                }

                "clear" -> {
                    cryptoHelper.clear()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error(
                "SECURE_STORAGE_ERROR",
                e.message ?: "Unknown error",
                null
            )
        }
    }

    override fun onDetachedFromEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel.setMethodCallHandler(null)
    }
}
