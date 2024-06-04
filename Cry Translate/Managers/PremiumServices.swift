import UIKit

class PremiumServices{

    class func checkPremium(premiumID:String,completionHandler: @escaping (Bool) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "4ab048137e894322901b1ff7d65aca0d")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = premiumID
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .nonRenewing(validDuration: 0), // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    completionHandler(true)
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    completionHandler(false)
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    completionHandler(false)
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
                completionHandler(false)
            }
        }

    }

    class func buyPremium(premiumID:String,completionHandler: @escaping (Bool) -> Void) {
        SwiftyStoreKit.purchaseProduct(premiumID, atomically: true) { result in
            switch result {
            case .success(let product):
                print("Purchase Success: \(product.productId)")
                completionHandler(true)
            case .error(let error):
                print("Purchase Failed: \(error.localizedDescription)")
                completionHandler(false)
            }
        }
    }

}
