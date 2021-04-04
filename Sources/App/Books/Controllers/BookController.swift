import Fluent
import Vapor

struct BookController: RouteCollection {

	// MARK: - Setup
	
	func boot(routes: RoutesBuilder) throws {
		let protected = routes.grouped(UserAuthenticator())
			.grouped(UserSession.guardMiddleware())
		let books = protected.grouped("books")
		books.post(use: create)
		books.get(use: readAll)
		books.get(":id", use: read)
		books.put(":id", use: update)
		books.delete(":id", use: delete)
	}

	// MARK: - Helper Functions
	
	func getOwnerId(req: Request) throws -> UUID {
		let authenticatedUser = try req.auth.require(UserSession.self)
		return authenticatedUser.userId
	}
	
	// MARK: - Create
	
	func create(req: Request) throws -> EventLoopFuture<Book.Output> {
		try Book.Input.validate(content: req)
		let ownerId = try getOwnerId(req: req)
		let input = try req.content.decode(Book.Input.self)
		let book = Book(ownerId: ownerId,
						title: input.title,
						authorName: input.authorName,
						genre: input.genre,
						status: input.status
		)
		return book.save(on: req.db).map {
			// TODO: Handle nil
			let uuid = book.id?.uuidString ?? ""
			return Book.Output(
				id: uuid,
				title: book.title,
				authorName: book.authorName,
				genre: book.genre,
				status: book.status
			)
		}
	}
	
	// MARK: - Read

	func readAll(req: Request) throws -> EventLoopFuture<Page<Book.Output>> {
		let ownerId = try getOwnerId(req: req)
		return Book.query(on: req.db)
			.filter(\.$owner.$id == ownerId)
			.paginate(for: req).map { page in
			page.map { book -> Book.Output in
				// TODO: Handle nil
				let uuid = book.id?.uuidString ?? ""
				return Book.Output(
					id: uuid,
					title: book.title,
					authorName: book.authorName,
					genre: book.genre,
					status: book.status
				)
			}
		}
	}
	
	func read(req: Request) throws -> EventLoopFuture<Book.Output> {
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		let ownerId = try getOwnerId(req: req)
		return Book.find(id, on: req.db)
			.unwrap(or: Abort(.notFound))
			.guard({ return $0.$owner.id == ownerId }, else: Abort(.notFound))
			.map { book -> Book.Output in
				// TODO: Handle nil
				let uuid = book.id?.uuidString ?? ""
				return Book.Output(
					id: uuid,
					title: book.title,
					authorName: book.authorName,
					genre: book.genre,
					status: book.status
				)
			}
	}
	
	// MARK: - Update
	
	func update(req: Request) throws -> EventLoopFuture<Book.Output> {
		try Book.Input.validate(content: req)
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		let ownerId = try getOwnerId(req: req)
		let input = try req.content.decode(Book.Input.self)
		return Book.find(id, on: req.db)
			.unwrap(or: Abort(.notFound))
			.guard({ return $0.$owner.id == ownerId }, else: Abort(.notFound))
			.flatMap { book in
				book.title = input.title
				book.authorName = input.authorName
				book.genre = input.genre
				book.status = input.status
				return book.save(on: req.db)
					.map {
						// TODO: Handle nil
						let uuid = book.id?.uuidString ?? ""
						return Book.Output(
							id: uuid,
							title: book.title,
							authorName: book.authorName,
							genre: book.genre,
							status: book.status
						)
					}
			}
	}

	// MARK: - Delete
	
	func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		let ownerId = try getOwnerId(req: req)
		return Book.find(id, on: req.db)
			.unwrap(or: Abort(.notFound))
			.guard({ return $0.$owner.id == ownerId }, else: Abort(.notFound))
			.flatMap { $0.delete(on: req.db) }
			.map { .noContent }
	}
	
}
