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
	@Parent(key: "user_id") var user: User
	@Field(key: "value") var value: String
	@Field(key: "expires_at") var expiresAt: Date?
	@Timestamp(key: "created_at", on: .create) var createdAt: Date?

	init() {}

	init(id: UUID? = nil, userId: User.IDValue, token: String, expiresAt: Date?) {
		self.id = id
		self.$user.id = userId
		self.value = token
		self.expiresAt = expiresAt
	}

}
