import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

	app.migrations.add(CreateUsers())
//	app.migrations.add(CreateTokens())
    app.migrations.add(CreateBooks())

    // register routes
    try routes(app)
}
