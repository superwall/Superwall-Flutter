import com.superwall.sdk.logger.LogScope
import com.superwall.superwallkit_flutter.json.JsonExtensions

fun JsonExtensions.Companion.logScopeFromJson(json: String): LogScope? {
    return when (json) {
        "localizationmanager" -> LogScope.localizationManager
        "bouncebutton" -> LogScope.bounceButton
        "coredata" -> LogScope.coreData
        "configmanager" -> LogScope.configManager
        "identitymanager" -> LogScope.identityManager
        "debugmanager" -> LogScope.debugManager
        "debugviewcontroller" -> LogScope.debugView
        "localizationviewcontroller" -> LogScope.localizationView
        "gamecontrollermanager" -> LogScope.gameControllerManager
        "device" -> LogScope.device
        "network" -> LogScope.network
        "paywallevents" -> LogScope.paywallEvents
        "productsmanager" -> LogScope.productsManager
        "storekitmanager" -> LogScope.storeKitManager
        "placements" -> LogScope.placements
        "receipts" -> LogScope.receipts
        "superwallcore" -> LogScope.superwallCore
        "paywallpresentation" -> LogScope.paywallPresentation
        "transactions" -> LogScope.transactions
        "paywallviewcontroller" -> LogScope.paywallView
        "nativepurchasecontroller" -> LogScope.nativePurchaseController
        "cache" -> LogScope.cache
        "all" -> LogScope.all
        else -> null
    }
}