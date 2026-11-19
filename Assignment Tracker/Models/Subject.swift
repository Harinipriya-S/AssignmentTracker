import Foundation

enum Subject: String, CaseIterable, Identifiable {
    case computerScience = "Java"
    case mathematics = "Swift"
    case science = "Maths"
    case english = "MERN"
    case other = "Other"

    var id: String { rawValue }
}
