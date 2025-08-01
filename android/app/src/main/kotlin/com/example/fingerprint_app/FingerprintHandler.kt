package com.example.fingerprint_app

import android.content.Context
import com.digitalpersona.uareu.Reader
import com.digitalpersona.uareu.ReaderCollection
import com.digitalpersona.uareu.UareUException
import com.digitalpersona.uareu.UareUGlobal
import io.flutter.plugin.common.MethodChannel

class FingerprintHandler(private val context: Context) {
    private var readers: ReaderCollection? = null

    init {
        initializeSDK()
    }

    private fun initializeSDK() {
        try {
            // Initialize your fingerprint SDK
            readers = Globals().getReaders(context)
        } catch (e: Exception) {
            e.printStackTrace()
            readers = null
        }
    }

    fun getReaders(result: MethodChannel.Result) {
        try {
            val readersList = mutableListOf<String>()
            readers?.let { readerCollection ->
                for (i in 0 until readerCollection.size) {
                    val readerName = readerCollection[i].GetDescription().name
                    readersList.add(readerName)
                }
            }
            System.out.println("[getReaders] result: $readersList");
            result.success(readersList)
        } catch (e: Exception) {
            result.error("SDK_ERROR", "Failed to get readers: ${e.message}", null)
        }
    }

    fun initializeReader(readerIndex: Int, result: MethodChannel.Result) {
        try {
            readers?.let { readerCollection ->
                if (readerIndex >= 0 && readerIndex < readerCollection.size) {
                    val reader = readerCollection[readerIndex]

                    // Open reader with cooperative priority
                    reader.Open(Reader.Priority.EXCLUSIVE)

                    // Close reader after initialization
                    reader.Close()

                    result.success(true)
                } else {
                    result.error("INVALID_INDEX", "Reader index out of bounds", null)
                }
            } ?: run {
                result.error("NO_READERS", "No readers available", null)
            }
        } catch (e: Exception) {
            result.error("INIT_ERROR", "Failed to initialize reader: ${e.message}", null)
        }
    }

    fun getReaderInfo(readerIndex: Int, result: MethodChannel.Result) {
        try {
            readers?.let { readerCollection ->
                if (readerIndex >= 0 && readerIndex < readerCollection.size) {
                    val reader = readerCollection[readerIndex]
                    val description = reader.GetDescription()

                    val readerInfo = mapOf(
                        "name" to description.name,
                        "index" to readerIndex,
                        "id" to description.id.toString(),
                        "version" to description.version
                    )

                    result.success(readerInfo)
                } else {
                    result.error("INVALID_INDEX", "Reader index out of bounds", null)
                }
            } ?: run {
                result.error("NO_READERS", "No readers available", null)
            }
        } catch (e: Exception) {
            result.error("INFO_ERROR", "Failed to get reader info: ${e.message}", null)
        }
    }

    fun hasReaders(result: MethodChannel.Result) {
        try {
            val hasReaders = (readers?.size ?: 0) > 0
            result.success(hasReaders)
        } catch (e: Exception) {
            result.error("CHECK_ERROR", "Failed to check readers: ${e.message}", null)
        }
    }
}