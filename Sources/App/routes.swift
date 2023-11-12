import Fluent
import WebAuthn
import Vapor

func routes(_ app: Application) throws {
    app.get(".well-known", "apple-app-site-association") { req -> Response in
        let appID = "D3K2BQRG84.dev.kobe.Hashtag"
        
        let responseString =
        """
        {
            "webcredentials": {
                "apps": [
                    "\(appID)"
                ]
            }
        }
        """
        
        let response = try await responseString.encodeResponse(for: req)
        response.headers.contentType = HTTPMediaType(type: "application", subType: "json")
        return response
    }
    
    let authSessionRoute = app.grouped(User.sessionAuthenticator())
    
    authSessionRoute.get("signup") { req -> Response in
        let username = try req.query.get(String.self, at: "username")
        guard try await User.query(on: req.db).filter(\.$username == username).first() == nil else {
            throw Abort(.conflict, reason: "Username is already taken")
        }
        
        let user = User(username: username)
        try await user.create(on: req.db)
        req.auth.login(user)
        return req.redirect(to: "makeCredential")
    }
    
    authSessionRoute.get("makeCredential") { req -> PublicKeyCredentialCreationOptions in
        let user = try req.auth.require(User.self)
        
        let options = req.webAuthn.beginRegistration(user: user.webAuthnUser)
        
        req.session.data["registrationChallenge"] = Data(options.challenge).base64EncodedString()
        
        return options
    }
}

extension PublicKeyCredentialCreationOptions: AsyncResponseEncodable {
    public func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        var headers = HTTPHeaders()
        headers.contentType = .json
        return try Response(status: .ok, headers: headers, body: .init(data: JSONEncoder().encode(self)))
    }
}
