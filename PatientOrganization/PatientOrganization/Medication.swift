import Foundation

struct Medication: Equatable {
    var date: Date
    var name: String
    var dose: Double // Changed from Int to Double
    var route: String
    var frequency: Int
    var duration: Int

    init(
        date: Date = Date(),
        name: String,
        dose: Double = 25, // Default to Double
        route: String = "by mouth",
        frequency: Int = 1,
        duration: Int = 14
    ) {
        self.date = date
        self.name = name
        self.dose = dose
        self.route = route
        self.frequency = frequency
        self.duration = duration
    }

    func isCurrent() -> Bool {
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .day, value: duration, to: date) else {
            return false
        }
        return Date() < endDate
    }
}