import SwiftData

enum AssignmentModelContainer {
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([Assignment.self, User.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
