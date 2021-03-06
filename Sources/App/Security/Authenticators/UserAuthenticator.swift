import Fluent
import Vapor

struct UserAuthenticator: BearerAuthenticator {

	func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void> {
		return Token.query(on: request.db)
			.filter(\.$value == bearer.token)
			.filter(\.$expiresAt >= Date())
			.with(\.$owner)
			.first()
			.unwrap(or: Abort(.unauthorized))
			.mapThrowing { token in
				guard let userId = token.owner.id else {
					throw Abort(.badRequest)
				}
				let authenticatedUser = UserSession(name: token.owner.email, userId: userId)
				request.auth.login(authenticatedUser)
			}
	}

}
