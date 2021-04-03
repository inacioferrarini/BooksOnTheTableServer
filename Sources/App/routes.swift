import Fluent
import Vapor

func routes(_ app: Application) throws {

	try app.register(collection: SecurityController())

	try app.register(collection: UserController())
	try app.register(collection: BookController())
	
//	app.grouped(UserModelBasicAuthenticator(),
//					User.guardMiddleware())
//		.get("sign-in") { req in
//			"I'm authenticated"
//		}
	
}
