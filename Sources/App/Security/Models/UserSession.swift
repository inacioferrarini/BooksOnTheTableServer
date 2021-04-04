import Vapor

struct UserSession: Authenticatable {
	let name: String
	let userId: UUID
}
