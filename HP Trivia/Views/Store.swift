//
//  Store.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 2/6/25.
//

import Foundation
import StoreKit


enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    @Published var purchasedIDs = Set<String>()
    
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
    }  // init
    
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            products.sort {
                $0.displayName < $1.displayName
            }  // product.sort
        } catch {
            print("Couldn't fetch products: \(error.localizedDescription)")
        }  // do..catch
    }  // loadProducts
    
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
                // Purchase was successful but now have to verify receipt - A valid purchase.
                case .success(let verificationResult):
                    switch verificationResult {
                        case .unverified(let signedType, let verificationError):
                            print("Error on \(signedType): \(verificationError)")
                        case .verified(let signedType):
                            purchasedIDs.insert(signedType.productID)
                    }  // switch
                                
                // User cancelled or parent disapproved child's purchase request.
                case .userCancelled:
                    break
                
                // Waiting for approval
                case .pending:
                    break
                
            @unknown default:
                break
            }  // switch
        } catch {
            print("Couldn't purchase that product: \(error.localizedDescription)")
        }  // do..catch
        
    }  // purchase(_ product)
    
    
    private func checkPurchase() async {
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    if signedType.revocationDate == nil {
                        purchasedIDs.insert(signedType.productID)
                    } else {
                        purchasedIDs.remove(signedType.productID)
                    }  // if..else
            }  // switch
        }  // for
    }  // checkPurchase
    
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchase()
            }  // for await
        }  // Task
        
    }  // watchForUpdates
    
    
}  // class Store
