import Fluent
import Vapor

struct UserController: RouteCollection {

	// MARK: - Setup
	
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("users")
		users.post(use: create)
	}
	
	// MARK: - Create
	
	func create(req: Request) throws -> EventLoopFuture<User.Output> {
		let input = try req.content.decode(User.Input.self)
		let user = User(name: input.name,
						email: input.email,
						password: input.password
		)
		return user.save(on: req.db).map {
			return User.Output(
				name: user.name,
				email: user.name
			)
		}
	}

	
}
