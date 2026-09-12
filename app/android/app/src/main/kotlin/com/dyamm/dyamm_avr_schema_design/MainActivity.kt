package com.dyamm.dyamm_avr_schema_design

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// Phase 1 channel: ATmega32 lifecycle + GPIO observation.
// Firmware reaches native as a file path (Dart stages bytes first).
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "simavr/emulator"
        ).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "isAvailable" -> result.success(SimavrNative.isAvailable())
                    "init" -> result.success(SimavrNative.init())
                    "loadHexBytes" -> {
                        val handle = call.argument<Number>("handle")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing handle", null)
                        val bytes = call.argument<ByteArray>("bytes")
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing bytes", null)
                        result.success(
                            SimavrNative.nativeLoadHexBytes(handle, bytes))
                    }
                    "loadHex" -> {
                        val handle = call.argument<Number>("handle")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing handle", null)
                        val path = call.argument<String>("path")
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing path", null)
                        result.success(SimavrNative.nativeLoadHex(handle, path))
                    }
                    "runCycles" -> {
                        val handle = call.argument<Number>("handle")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing handle", null)
                        val cycles = call.argument<Number>("cycles")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing cycles", null)
                        result.success(
                            SimavrNative.nativeRunCycles(handle, cycles))
                    }
                    "getPortB" -> {
                        val handle = call.argument<Number>("handle")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing handle", null)
                        result.success(SimavrNative.nativeGetPortB(handle))
                    }
                    "terminate" -> {
                        val handle = call.argument<Number>("handle")?.toLong()
                            ?: return@setMethodCallHandler result.error(
                                "ARG", "missing handle", null)
                        SimavrNative.nativeTerminate(handle)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("NATIVE", e.message, null)
            }
        }
    }
}
