//
//  File.swift
//  
//
//  Created by Minseong Kang on 11/9/23.
//

import Vapor
import WebAuthn

extension Application {
    
    struct WebAuthnKey: StorageKey {
        typealias Value = WebAuthnManager
    }
    
    var webAuthn: WebAuthnManager {
        get {
            guard let webAuthn = storage[WebAuthnKey.self] else {
                fatalError("WebAuthn configuration failed")
            }
            return webAuthn
        }
        set {
            storage[WebAuthnKey.self] = newValue
        }
    }
}

extension Request {
    var webAuthn: WebAuthnManager { application.webAuthn }
}
