import Vapor

extension EventLoopFuture {
	
	func mapThrowing<NewValue>(_ callback: @escaping (Value) throws -> NewValue) -> EventLoopFuture<NewValue> {
		return flatMapThrowing(callback)
	}

}
