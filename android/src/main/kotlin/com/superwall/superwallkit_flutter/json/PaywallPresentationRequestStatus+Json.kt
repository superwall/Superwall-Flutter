package com.superwall.superwallkit_flutter.json

import PPaywallPresentationRequestStatusReason
import PPaywallPresentationRequestStatusType
import PStatusReasonDebuggerPresented
import PStatusReasonHoldout
import PStatusReasonNoAudienceMatch
import PStatusReasonNoConfig
import PStatusReasonNoPaywallVc
import PStatusReasonNoPresenter
import PStatusReasonPaywallAlreadyPresented
import PStatusReasonPlacementNotFound
import PStatusReasonSubsStatusTimeout
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatus
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatusReason
import pigeonify

fun PaywallPresentationRequestStatus.pigeonify(): PPaywallPresentationRequestStatusType =
    when (this) {
        PaywallPresentationRequestStatus.Presentation -> PPaywallPresentationRequestStatusType.PRESENTATION
        PaywallPresentationRequestStatus.NoPresentation -> PPaywallPresentationRequestStatusType.NO_PRESENTATION
        PaywallPresentationRequestStatus.Timeout -> PPaywallPresentationRequestStatusType.TIMEOUT
    }

fun PaywallPresentationRequestStatusReason.pigeonify(): PPaywallPresentationRequestStatusReason =
    when (this) {
        is PaywallPresentationRequestStatusReason.DebuggerPresented ->
            PStatusReasonDebuggerPresented()
        is PaywallPresentationRequestStatusReason.Holdout ->
            PStatusReasonHoldout(experiment.pigeonify())
        is PaywallPresentationRequestStatusReason.NoAudienceMatch ->
            PStatusReasonNoAudienceMatch()
        is PaywallPresentationRequestStatusReason.PlacementNotFound ->
            PStatusReasonPlacementNotFound()
        is PaywallPresentationRequestStatusReason.NoPaywallView ->
            PStatusReasonNoPaywallVc()
        is PaywallPresentationRequestStatusReason.NoPresenter ->
            PStatusReasonNoPresenter()
        is PaywallPresentationRequestStatusReason.NoConfig ->
            PStatusReasonNoConfig()
        is PaywallPresentationRequestStatusReason.PaywallAlreadyPresented ->
            PStatusReasonPaywallAlreadyPresented()
        else ->
            PStatusReasonSubsStatusTimeout()
    }
