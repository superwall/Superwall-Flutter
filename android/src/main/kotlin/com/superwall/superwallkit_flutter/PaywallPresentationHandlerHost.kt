package com.superwall.superwallkit_flutter

import PCustomCallback
import PCustomCallbackResult
import PCustomCallbackResultStatus
import PPaywallPresentationHandlerGenerated
import com.superwall.sdk.paywall.presentation.CustomCallback
import com.superwall.sdk.paywall.presentation.CustomCallbackResult
import com.superwall.sdk.paywall.presentation.CustomCallbackResultStatus
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import com.superwall.superwallkit_flutter.utils.pigeonExperiment
import com.superwall.superwallkit_flutter.utils.toPigeon
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
                    result.toPigeon(),
                    {},
                )
            }
            onError {
                backingHandler.onError(it.localizedMessage ?: it.message ?: "Unknown error", {})
            }
            onSkip {
                backingHandler.onSkip(it.toPigeon(), it.pigeonExperiment(), {})
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
