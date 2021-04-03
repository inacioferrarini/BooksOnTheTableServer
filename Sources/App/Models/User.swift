import Fluent
import Vapor

final class User: Model, Content {
	
	struct Input: Content {
		let name: String
		let email: String
		let password: String
	}
	
	struct Output: Content {
		let name: String
		let email: String
	}

	static let schema = "users"
	
	@ID(key: .id) var id: UUID?
	@Field(key: "name") var name: String
	@Field(key: "email") var email: String
	@Field(key: "password") var password: String
	
	init() { }
	
	init(id: UUID? = nil, name: String, email: String, password: String) {
		self.id = id
		self.name = name
		self.email = email
		self.password = password
	}

}
