import Fluent

struct CreateBook: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("books")
			.id()
			.field("title", .string, .required)
			.field("author_name", .string, .required)
			.field("genre", .string, .required)
			.field("status", .string, .required)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("books").delete()
	}

}
