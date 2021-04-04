import Fluent
import Vapor

final class Book: Model, Content {
	
	enum Genre: String, Codable {
		case horror = "Horror"
	}
	
	enum Status: String, Codable {
		case reading = "Reading"
		case done = "Done"
	}
	
	struct Input: Content {
		let title: String
		let authorName: String
		let genre: Genre
		let status: Status
	}
	
	struct Output: Content {
		let id: String
		let title: String
		let authorName: String
		let genre: Genre
		let status: Status
	}
	
	static let schema = "books"
	
	@ID(key: .id) var id: UUID?
	@Field(key: "title") var title: String
	@Field(key: "author_name") var authorName: String
	@Field(key: "genre") var genre: Genre
	@Field(key: "status") var status: Status
	@Parent(key: "user_id") var owner: User
	
	init() { }

	init(id: UUID? = nil, ownerId: UUID, title: String, authorName: String, genre: Genre, status: Status) {
		self.id = id
		self.$owner.id = ownerId
		self.title = title
		self.authorName = authorName
		self.genre = genre
		self.status = status
	}
	
}

extension Book.Input {
	
	enum CodingKeys: String, CodingKey {
		case title
		case authorName = "author_name"
		case genre
		case status
	}
	
}

extension Book.Output {
	
	enum CodingKeys: String, CodingKey {
		case id
		case title
		case authorName = "author_name"
		case genre
		case status
	}
	
}
