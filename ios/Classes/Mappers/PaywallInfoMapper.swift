import SuperwallKit
import Foundation

class PaywallInfoMapper {
    static func toPPaywallInfo(_ info: PaywallInfo) -> PPaywallInfo {
        var productArray: [PProduct]? = nil
        if !info.products.isEmpty {
            productArray = info.products.map { product in
                PProduct(
                    id: product.id,
                    name: product.name,
                    entitlements: product.entitlements.map { PEntitlement(id: $0.id) }
                )
            }
        }
        
        return PPaywallInfo(
            identifier: info.identifier,
            name: info.name,
            experiment: info.experiment.map { 
                PExperiment(
                    id: $0.id,
                    groupId: $0.groupId,
                    variant: PVariant(
                        id: $0.variant.id,
                        type: $0.variant.type == .treatment ? .treatment : .holdout,
                        paywallId: $0.variant.paywallId
                    )
                )
            },
            productIds: Array(info.productIds),
            products: productArray,
            url: info.url.absoluteString,
            presentedByPlacementWithName: info.presentedByPlacementWithName,
            presentedByPlacementWithId: info.presentedByPlacementWithId,
            presentedByPlacementAt: info.presentedByPlacementAt,
            presentedBy: info.presentedBy,
            presentationSourceType: info.presentationSourceType,
            responseLoadStartTime: info.responseLoadStartTime,
            responseLoadCompleteTime: info.responseLoadCompleteTime,
            responseLoadFailTime: info.responseLoadFailTime,
            responseLoadDuration: info.responseLoadDuration,
            webViewLoadStartTime: info.webViewLoadStartTime,
            webViewLoadCompleteTime: info.webViewLoadCompleteTime,
            webViewLoadFailTime: info.webViewLoadFailTime,
            webViewLoadDuration: info.webViewLoadDuration,
            productsLoadStartTime: info.productsLoadStartTime,
            productsLoadCompleteTime: info.productsLoadCompleteTime,
            productsLoadFailTime: info.productsLoadFailTime,
            productsLoadDuration: info.productsLoadDuration,
            paywalljsVersion: info.paywalljsVersion,
            isFreeTrialAvailable: info.isFreeTrialAvailable,
            featureGatingBehavior: info.featureGatingBehavior == .gated ? .gated : .nonGated,
            closeReason: convertCloseReason(info.closeReason),
            localNotifications: info.localNotifications.map { convertLocalNotification($0) },
            computedPropertyRequests: info.computedPropertyRequests.map { convertComputedPropertyRequest($0) },
            surveys: info.surveys.map { convertSurvey($0) }
        )
    }
    
    private static func convertCloseReason(_ reason: PaywallCloseReason) -> PPaywallCloseReason {
        switch reason {
        case .systemLogic:
            return .systemLogic
        case .forNextPaywall:
            return .forNextPaywall
        case .webViewFailedToLoad:
            return .webViewFailedToLoad
        case .manualClose:
            return .manualClose
        case .none:
            return .none
        @unknown default:
            return .none
        }
    }
    
    private static func convertLocalNotification(_ notification: LocalNotification) -> PLocalNotification {
        let type: PLocalNotificationType
        switch notification.type {
        case .trialStarted:
            type = .trialStarted
        default:
            type = .unsupported
        }
        
        return PLocalNotification(
            id: 0,
            type: type,
            title: notification.title,
            subtitle: notification.subtitle,
            body: notification.body,
            delay: Int64(notification.delay)
        )
    }
    
    private static func convertComputedPropertyRequest(_ request: ComputedPropertyRequest) -> PComputedPropertyRequest {
        let type: PComputedPropertyRequestType
        
        switch request.type {
        case .minutesSince:
            type = .minutesSince
        case .hoursSince:
            type = .hoursSince
        case .daysSince:
            type = .daysSince
        case .monthsSince:
            type = .monthsSince
        case .yearsSince:
            type = .yearsSince
        @unknown default:
            type = .minutesSince
        }
        
        return PComputedPropertyRequest(
            type: type,
            eventName: request.placementName
        )
    }
    
    private static func convertSurvey(_ survey: Survey) -> PSurvey {
        let condition: PSurveyShowCondition
        switch survey.presentationCondition {
        case .onManualClose:
            condition = .onManualClose
        case .onPurchase:
            condition = .onPurchase
        @unknown default:
            condition = .onManualClose
        }
        
        return PSurvey(
            id: survey.id,
            assignmentKey: survey.assignmentKey,
            title: survey.title,
            message: survey.message,
            options: survey.options.map { PSurveyOption(id: $0.id, text: $0.title) },
            presentationCondition: condition,
            presentationProbability: survey.presentationProbability,
            includeOtherOption: survey.includeOtherOption,
            includeCloseOption: survey.includeCloseOption
        )
    }
} 