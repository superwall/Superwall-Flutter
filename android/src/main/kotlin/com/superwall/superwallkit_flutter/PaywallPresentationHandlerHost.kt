package com.superwall.superwallkit_flutter

import PCustomCallback
import PCustomCallbackResult
import PCustomCallbackResultStatus
import PDeclinedPaywallResult
import PPaywallPresentationHandlerGenerated
import PPaywallSkippedReason
import PPurchasedPaywallResult
import PRestoredPaywallResult
import com.superwall.sdk.paywall.presentation.CustomCallback
import com.superwall.sdk.paywall.presentation.CustomCallbackResult
import com.superwall.sdk.paywall.presentation.CustomCallbackResultStatus
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult
import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class PaywallPresentationHandlerHost(
    setup: () -> PPaywallPresentationHandlerGenerated,
) {
    val backingHandler = setup()
    val handler =
        PaywallPresentationHandler().apply {
            onPresent {
                backingHandler.onPresent(PaywallInfoMapper.toPPaywallInfo(it), {})
            }
            onDismiss { info, result ->
                backingHandler.onDismiss(
                    PaywallInfoMapper.toPPaywallInfo(info),
                    when (result) {
                        is PaywallResult.Purchased -> PPurchasedPaywallResult(result.productId)
                        is PaywallResult.Declined -> PDeclinedPaywallResult()
                        is PaywallResult.Restored -> PRestoredPaywallResult()
                    },
                    {},
                )
            }
            onError {
                backingHandler.onError(it.localizedMessage ?: it.message ?: "Unknown error", {})
            }
            onSkip {
                backingHandler.onSkip(
                    when (it) {
                        is PaywallSkippedReason.Holdout -> PPaywallSkippedReason.HOLDOUT
                        is PaywallSkippedReason.NoAudienceMatch -> PPaywallSkippedReason.NO_AUDIENCE_MATCH
                        is PaywallSkippedReason.PlacementNotFound -> PPaywallSkippedReason.PLACEMENT_NOT_FOUND
                        else -> PPaywallSkippedReason.NO_AUDIENCE_MATCH
                    },
                    {},
                )
            }
            onCustomCallback { callback ->
                // Convert SDK's CustomCallback to Pigeon's PCustomCallback
                val pCallback = PCustomCallback(
                    name = callback.name,
                    variables = callback.variables?.mapValues { it.value as Object }
                )

                // Pigeon FlutterApi calls are @UiThread, so switch to Main dispatcher
                val pResult = withContext(Dispatchers.Main) {
                    suspendCoroutine<PCustomCallbackResult> { continuation ->
                        backingHandler.onCustomCallback(pCallback) { result ->
                            val callbackResult = result.getOrNull() ?: PCustomCallbackResult(
                                status = PCustomCallbackResultStatus.FAILURE,
                                data = null
                            )
                            continuation.resume(callbackResult)
                        }
                    }
                }

                // Convert Pigeon's PCustomCallbackResult to SDK's CustomCallbackResult
                CustomCallbackResult(
                    status = when (pResult.status) {
                        PCustomCallbackResultStatus.SUCCESS -> CustomCallbackResultStatus.SUCCESS
                        PCustomCallbackResultStatus.FAILURE -> CustomCallbackResultStatus.FAILURE
                    },
                    data = pResult.data?.mapValues { it.value as Any }
                )
            }
        }
}
