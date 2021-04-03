import Vapor

struct UserAuthenticator: BearerAuthenticator {

//	typealias User = App.Token.Input

	func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
		if bearer.token == "foo" {
			request.auth.login(Token.Input(name: "Name", email: "Email", password: "Password"))
		}
		return request.eventLoop.makeSucceededFuture(())
	}

}
