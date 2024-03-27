// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Hummingbird
import Logging

@main
struct todos: AsyncParsableCommand {
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    func run() async throws {
	var logger = Logger(label: "todos")
	logger.logLevel = .debug

	let router = Router()
	router.middlewares.add(LogRequestsMiddleware(.info))
	router.get("/") { request, context in
		"Hello Hummingbird\n"
	}

	TodoController(repository: TodoMemoryRepository()).addRoutes(to: router.group("todos"))

	let app = Application(
            router: router,
            configuration: .init(address: .hostname(self.hostname, port: self.port)), 
            logger: logger)
	try await app.runService()
    }
}
