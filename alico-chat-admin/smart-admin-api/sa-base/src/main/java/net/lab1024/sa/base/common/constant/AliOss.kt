package net.lab1024.sa.base.common.constant

object AliOss {
    var FILE_DOMAIN = ""

    fun String.addAliOssDomain(): String {
        if (this.startsWith("http")) return this
        return "$FILE_DOMAIN/$this"
    }
}