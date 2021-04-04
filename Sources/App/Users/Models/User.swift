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
	@Children(for: \.$owner) var books: [Book]
	
	init() { }
	
	init(id: UUID? = nil, name: String, email: String, password: String) {
		self.id = id
		self.name = name
		self.email = email
		self.password = password
	}

}

extension User.Input: Validatable {

	static func validations(_ validations: inout Validations) {
		validations.add("name", as: String.self, is: .count(3...) && .alphanumeric)
		validations.add("email", as: String.self, is: .email)
		validations.add("password", as: String.self, is: .count(8...))
	}

}
