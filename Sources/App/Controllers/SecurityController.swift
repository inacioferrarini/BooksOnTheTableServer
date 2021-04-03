import Fluent
import Vapor
import Crypto

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
			.mapThrowing { user -> Token.Output in
				if try Bcrypt.verify(input.password, created: user.password), let userId = user.id {
					let tokenString = UUID().uuidString //.replacingCharacters(in: "-", with: "")
					print("tokenString: \(tokenString)")
					let createdAt = Date()
					let expiresAt = Date().advanced(by: 15*24*60*60*1000)
					let token = Token(
						userId: userId,
						token: tokenString,
						createdAt: createdAt,
						expiresAt: expiresAt
					)

					_ = token.save(on: req.db)
					
					return Token.Output(
						token: tokenString,
						createdAt: createdAt,
						expiresAt: expiresAt
					)
					
				} else {
					throw Abort(HTTPStatus.unauthorized)
				}
			}
	}
	
}
