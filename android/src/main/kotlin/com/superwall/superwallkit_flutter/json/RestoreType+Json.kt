import com.superwall.sdk.store.transactions.RestoreType

fun RestoreType.toJson(): Map<String, Any?> {
    return when (this) {
        is RestoreType.ViaPurchase -> mapOf(
            "type" to "viaPurchase",
            "storeTransaction" to transaction?.toJson()
        )
        is RestoreType.ViaRestore -> mapOf("type" to "viaRestore")
    }
}