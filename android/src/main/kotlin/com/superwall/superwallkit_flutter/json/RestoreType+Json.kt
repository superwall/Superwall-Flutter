import com.superwall.sdk.store.transactions.RestoreType

fun RestoreType.pigeonify(): PRestoreType =
    when (this) {
        is RestoreType.ViaPurchase ->
            PViaPurchase(
                storeTransaction = transaction?.pigeonify(),
            )
        is RestoreType.ViaRestore -> PViaRestore()
    }
