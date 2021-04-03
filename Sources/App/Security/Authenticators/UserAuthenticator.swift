import Vapor

struct UserAuthenticator: BearerAuthenticator {

	func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
		
		
		
		
		
		
		if bearer.token == "foo" {
			// Check the bearer
			// Het user
			let authenticatedUser = UserSession(name: "User Name")
			request.auth.login(authenticatedUser)
		}
		return request.eventLoop.makeSucceededFuture(())
	}

}
