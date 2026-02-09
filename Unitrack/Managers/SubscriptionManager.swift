//
//  SubscriptionManager.swift
//  Unitrack
//

import SwiftUI
import Combine
import RevenueCat
import RevenueCatUI

@MainActor
class SubscriptionManager: NSObject, ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var isPremium: Bool = false
    @Published var customerInfo: CustomerInfo?
    @Published var offerings: Offerings?
    
    override private init() {
        super.init()
        
        // Initial check
        refresh()
        
        // Subscribe to customer info changes
        Purchases.shared.delegate = self
    }
    
    func refresh() {
        Purchases.shared.getCustomerInfo { [weak self] info, error in
            Task { @MainActor in
                self?.customerInfo = info
                self?.updateEntitlements(info)
            }
        }
        
        Purchases.shared.getOfferings { [weak self] offerings, error in
            Task { @MainActor in
                self?.offerings = offerings
            }
        }
    }
    
    func restorePurchases() async {
        do {
            let info = try await Purchases.shared.restorePurchases()
            self.customerInfo = info
            updateEntitlements(info)
        } catch {
            print("Restore failed: \(error.localizedDescription)")
        }
    }
    
    private func updateEntitlements(_ info: CustomerInfo?) {
        // Match the entitlement ID from RevenueCat Dashboard
        isPremium = info?.entitlements["Unitrack Pro"]?.isActive ?? false
    }
}

extension SubscriptionManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            updateEntitlements(customerInfo)
        }
    }
}
