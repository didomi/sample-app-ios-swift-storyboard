//
//  CustomVendor.swift
//  Sample App Swift
//

import Foundation

class CustomVendor {
    static let shared = CustomVendor()
    
    func initialize() {
        print("Didomi Sample App - Initializing custom vendor")
    }
}
