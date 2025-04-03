package com.superwall.superwallkit_flutter

import android.app.Activity
import android.app.Application
import android.os.Debug
import android.util.Log
import com.superwall.sdk.misc.runOnUiThread
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import java.util.WeakHashMap
import java.util.concurrent.atomic.AtomicInteger
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class SuperwallkitFlutterPlugin : FlutterPlugin, ActivityAware {
    var currentActivity: Activity? = null
    var host: SuperwallHost? = null

    companion object {
        private var instance: SuperwallkitFlutterPlugin? = null
        val reattachementCount = AtomicInteger(0)
        val lock = Object()
        val currentActivity: Activity?
            get() = instance?.currentActivity
    }

    init {
        if (BuildConfig.DEBUG && BuildConfig.WAIT_FOR_DEBUGGER) {
            Debug.waitForDebugger()
        }

        // Only allow instance to get set once.
        if (instance == null) {
            instance = this
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        synchronized(lock) {
            if (host == null)
                host = SuperwallHost(
                    binaryMessenger = { flutterPluginBinding.binaryMessenger},
                    context = { flutterPluginBinding?.applicationContext as Application }
                )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        host = null
    }

    //region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        currentActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        currentActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        currentActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        currentActivity = null
    }

    //endregion
}
