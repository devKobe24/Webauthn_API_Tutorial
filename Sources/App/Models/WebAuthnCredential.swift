//
//  WebAuthnCredential.swift
//
//
//  Created by Minseong Kang on 11/10/23.
//

import Fluent
import Vapor
import WebAuthn

final class WebAuthnCredential: Model, Content {
    static let schema: String = "webAuthn_Credentials"
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Field(key: "public_key")
    var publicKey: String
    
    @Field(key: "current_signCount")
    var currentSignCount: Int32
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: String, publicKey: String, currentSignCount: Int32, userID: UUID) {
        self.id = id
        self.publicKey = publicKey
        self.currentSignCount = currentSignCount
        self.$user.id = userID
    }
    
    convenience init(from credential: Credential, userID: UUID) {
        self.init(
            id: credential.id,
            publicKey: credential.publicKey.base64URLEncodedString().asString(),
            currentSignCount: Int32(credential.signCount),
            userID: userID
        )
    }
}
