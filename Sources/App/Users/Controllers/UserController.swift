import Fluent
import Vapor
import Crypto

struct UserController: RouteCollection {

	// MARK: - Setup
	
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("users")
		users.post(use: create)
	}
	
	// MARK: - Create
	
	func create(req: Request) throws -> EventLoopFuture<User.Output> {
		try User.Input.validate(content: req)
		let input = try req.content.decode(User.Input.self)
		let user = User(name: input.name,
						email: input.email,
						password: input.password
		)
		user.password = try Bcrypt.hash(user.password, cost: 4)
		return user.save(on: req.db).map {
			return User.Output(
				name: user.name,
				email: user.email
			)
		}
	}

	
}
