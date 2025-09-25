package com.example.sendtv

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** mDNS 服务注册插件 */
class MdnsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var nsdManager: NsdManager? = null
    private var registrationListener: NsdManager.RegistrationListener? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "mdns_service")
        channel.setMethodCallHandler(this)

        context = binding.applicationContext
        nsdManager = context?.getSystemService(Context.NSD_SERVICE) as NsdManager
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "advertiseService" -> {
                val name = call.argument<String>("name") ?: "Unknown"
                val type = call.argument<String>("type") ?: "_http._tcp."
                val port = call.argument<Int>("port") ?: 0

                advertiseService(name, type, port, result)
            }
            "stopAdvertise" -> {
                stopAdvertise(result)
            }
            else -> result.notImplemented()
        }
    }

    /** 发布服务 */
    private fun advertiseService(name: String, type: String, port: Int, result: MethodChannel.Result) {
        val serviceInfo = NsdServiceInfo().apply {
            serviceName = name
            serviceType = type   // ⚠️ 结尾必须有 "."
            this.port = port
        }

        registrationListener = object : NsdManager.RegistrationListener {
            override fun onServiceRegistered(info: NsdServiceInfo) {
                Log.d("MDNS", "✅ 服务注册成功: ${info.serviceName} @ ${info.port}")
                result.success(null)
            }

            override fun onRegistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                Log.e("MDNS", "❌ 服务注册失败: error=$errorCode")
                result.error("REGISTER_FAILED", "errorCode=$errorCode", null)
            }

            override fun onServiceUnregistered(serviceInfo: NsdServiceInfo) {
                Log.d("MDNS", "🛑 服务已注销: ${serviceInfo.serviceName}")
            }

            override fun onUnregistrationFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                Log.e("MDNS", "❌ 注销失败: error=$errorCode")
            }
        }

        nsdManager?.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener)
    }

    /** 停止发布 */
    private fun stopAdvertise(result: MethodChannel.Result) {
        try {
            registrationListener?.let {
                nsdManager?.unregisterService(it)
                Log.d("MDNS", "🛑 服务已停止广播")
            }
            registrationListener = null
            result.success(null)
        } catch (e: Exception) {
            result.error("STOP_FAILED", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        registrationListener?.let { nsdManager?.unregisterService(it) }
    }
}
