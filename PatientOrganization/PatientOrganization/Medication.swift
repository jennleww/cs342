import Foundation

struct Medication: Equatable {
    var date: Date
    var name: String
    var dose: Double 
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

    // Utilized guard let to ensure that end date is successfully calculated before proceeding 
    func isCurrent() -> Bool {
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .day, value: duration, to: date) else {
            return false
        }
        return Date() < endDate
    }
    
    // Utilized mutating function to modified propoerties of medication struct
    mutating func extendDuration(_ amount: Int) {
        duration += amount
    }
}
