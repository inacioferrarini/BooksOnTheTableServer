import Fluent
import Vapor
//import Random

struct SecurityController: RouteCollection {

	// MARK: - Setup
	
	func boot(routes: RoutesBuilder) throws {
		let security = routes.grouped("security")
		security.post("token", use: login)
	}

	// MARK: - Authentication
	
	func login(_ req: Request) throws -> EventLoopFuture<Token.Output> {
		let input = try req.content.decode(Token.Input.self)
		return User.query(on: req.db)
			.filter(\.$email == input.email)
			.first()
			.unwrap(or: Abort(.notFound))
			.map { user -> Token.Output in
				//let hasher = try req.make(BCryptDigest.self)
				//if try hasher.verify(user.password, created: existingUser.password) {
				//	let tokenString = try URandom().generateData(count: 32).base64EncodedString()
				//	let token = try Token(token: tokenString, userId: existingUser.requireID())
				//	return token.save(on: req)
				//} else {
				//	throw Abort(HTTPStatus.unauthorized)
				//}
				return Token.Output(
					token: "new Token Value",
					createdAt: Date(),
					expiresAt: Date()
				)
			}
				
//		return try req.content.decode(User.Input.self).flatMap { user in
//			return User.query(on: req.db).filter(\.email == user.email).first().flatMap { fetchedUser in
//				guard let existingUser = fetchedUser else {
//					throw Abort(HTTPStatus.notFound)
//				}
//				let hasher = try req.make(BCryptDigest.self)
//				if try hasher.verify(user.password, created: existingUser.password) {
//					let tokenString = try URandom().generateData(count: 32).base64EncodedString()
//					let token = try Token(token: tokenString, userId: existingUser.requireID())
//					return token.save(on: req)
//				} else {
//					throw Abort(HTTPStatus.unauthorized)
//				}
//			}
//		}
	}
	
}
