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
				if try Bcrypt.verify(input.password, created: user.password), let ownerId = user.id {
					// TODO: How to create a random token
					let tokenString = UUID().uuidString  //.replacingCharacters(in: "-", with: "")
					print("tokenString: \(tokenString)")
					let createdAt = Date()
					let expiresAt = Date().addingTimeInterval(15*24*60*60) // TODO: Create a constant
					let token = Token(
						ownerId: ownerId,
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
