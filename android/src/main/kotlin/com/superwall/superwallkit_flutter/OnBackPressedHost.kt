package com.superwall.superwallkit_flutter

import POnBackPressedGenerated
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper

class OnBackPressedHost(
    setup: () -> POnBackPressedGenerated,
) {
    private val backingHandler = setup()

    /**
     * The callback to be set on PaywallOptions.onBackPressed.
     * Notifies Flutter when back is pressed and returns false to allow default behavior.
     * Flutter can call Superwall.dismiss() if it wants to handle the dismissal.
     */
    val onBackPressed: (PaywallInfo?) -> Boolean = { paywallInfo ->
        // Notify Flutter about the back press (fire and forget)
        backingHandler.onBackPressed(
            paywallInfo?.let { PaywallInfoMapper.toPPaywallInfo(it) }
        ) { _ -> }

        // Always return false to let the default behavior happen
        true
    }
}
