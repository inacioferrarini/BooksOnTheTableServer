import Fluent

struct CreateBooks: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema(Book.schema)
			.id()
			.field("title", .string, .required)
			.field("author_name", .string, .required)
			.field("genre", .string, .required)
			.field("status", .string, .required)
			.field("user_id", .uuid, .required, .references("users", "id"))
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		return database.schema("books").delete()
	}

}

