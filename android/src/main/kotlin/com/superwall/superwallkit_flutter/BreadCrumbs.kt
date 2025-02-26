package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BridgeInstance

object BreadCrumbs {
    private val logBuilder = StringBuilder()

    fun append(debugString: String) {
        logBuilder.append(debugString).append("\n")
    }

    fun logs(): String {
        val output = StringBuilder()

        output.append("\n=======LOGS START========\n")
        output.append(logBuilder)
        output.append("=======LOGS END==========\n")
        return output.toString()
    }

    fun clear() {
        logBuilder.clear()
    }
}

fun MutableMap<String, BridgeInstance>.toFormattedString(): String {
    return this.entries.joinToString(separator = "\n") { (key: String, value: BridgeInstance) ->
        "Key: $key, Value: $value"
    }
}