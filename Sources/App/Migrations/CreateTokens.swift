import Fluent

struct CreateTokens: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema(Token.schema)
			.id()
			.field("user_id", .uuid, .references("users", "id"))
			.field("value", .string, .required)
			.unique(on: "value")
			.field("created_at", .datetime, .required)
			.field("expires_at", .datetime)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema(Token.schema).delete()
	}

}
