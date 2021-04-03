import Fluent

struct CreateUsers: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema(User.schema)
			.id()
			.field("name", .string, .required)
			.field("email", .string, .required)
			.field("password", .string, .required)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("users").delete()
	}

}

