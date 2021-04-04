import Vapor
import Fluent

final class Token: Model {

	struct Input: Content {
		let email: String
		let password: String
	}

	struct Output: Content {
		let token: String
		let createdAt: Date
		let expiresAt: Date
	}
	
	static let schema = "tokens"

	@ID(key: "id") var id: UUID?
	@Parent(key: "user_id") var owner: User
	@Field(key: "value") var value: String
	@Field(key: "created_at") var createdAt: Date?
	@Field(key: "expires_at") var expiresAt: Date?

	init() {}

	init(id: UUID? = nil, ownerId: User.IDValue, token: String, createdAt: Date?, expiresAt: Date?) {
		self.id = id
		self.$owner.id = ownerId
		self.value = token
		self.createdAt = createdAt
		self.expiresAt = expiresAt
	}

}

extension Token.Input: Validatable {

	static func validations(_ validations: inout Validations) {
		validations.add("email", as: String.self, is: .email)
		validations.add("password", as: String.self, is: .count(8...))
	}

}
