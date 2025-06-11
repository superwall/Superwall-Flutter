package com.superwall.superwallkit_flutter

object BreadCrumbs {
    private val logBuilder = StringBuilder()

    fun append(debugString: String) {
        synchronized(logBuilder) {
            logBuilder.append(debugString).append("\n")
        }
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
