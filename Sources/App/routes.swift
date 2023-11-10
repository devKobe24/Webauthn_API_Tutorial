import Fluent
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
}
