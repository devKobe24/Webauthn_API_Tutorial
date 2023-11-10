//
//  CreateWebauthnCredential.swift
//
//
//  Created by Minseong Kang on 11/10/23.
//

import Fluent

struct CreateWebauthnCredential: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("webAuthn_Credentials")
            .field("id", .string, .identifier(auto: false))
            .field("public_key", .string, .required)
            .field("current_signCount", .uint32, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .unique(on: "id")
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("webAuthn_Credentials").delete()
    }
}
