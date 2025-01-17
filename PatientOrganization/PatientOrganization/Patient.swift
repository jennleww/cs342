//
//  Patient.swift
//  PatientOrganization
//
import Foundation

enum PrescriptionError: Error {
    case duplicateMedication
}

struct Patient {
    let recordNumber: UUID = UUID()
    var firstName: String
    var lastName: String
    var sex: Character
    var dateOfBirth: Date
    var height: Double
    var weight: Double
    var bloodType: BloodType?
    var medications: [Medication]
    
    init(firstName: String, lastName: String, sex: Character, dateOfBirth: Date, height: Double, weight: Double, bloodType: BloodType? = nil, medications: [Medication] = []) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.bloodType = bloodType
        self.medications = medications
        self.sex = sex
    }
    
    // Calculate age of patient
    func age() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return components.year ?? 0
    }
    
    func fullName() -> String {
        "\(lastName), \(firstName) (\(age()))"
    }
    
    // Returns active medication and sorts by date
    func currentMed() -> [Medication] {
        return medications
            .filter { $0.isCurrent() }
            .sorted { $0.date < $1.date }
    }
    
    func expiredMed() -> [Medication] {
        return medications
            .filter { !$0.isCurrent() }
            .sorted { $0.date < $1.date }
    }
    
    func BMI() -> Double {
        let kgweight = weight * 0.453592
        return kgweight / pow(height / 100, 2)// assume height in cm
    }
    
    // Retrives raw string of blood type
    func getBloodType() -> String {
        if let bloodType = bloodType {
            return bloodType.description
        } else {
            return "Unknown"
        }
    }
    
    
    // Adds new medication to list of medication
    // Throws error if attempt to prescribe duplicate medication
    mutating func prescribeMed(_ medication: Medication) throws {
        if medications.contains(where: { $0.name == medication.name }) {
            throw PrescriptionError.duplicateMedication
        }
        
        medications.append(medication)
    }
    
    // Returns medication with specified route
    func specifyRoute(_ route: String) -> [Medication] {
        
        medications.filter { $0.route.caseInsensitiveCompare(route) == .orderedSame }
    }
    
    
    // Returns list of blood types compatible with patient bloodtype. If unknown, return empty array
    func compatibleDonor() -> [BloodType] {
        switch bloodType {
            case .ABPos:
                return BloodType.allCases
            case .ABNeg:
                return [.ONeg, .BNeg, .ANeg, .ABNeg]
            case .APos:
                return [.ONeg, .BNeg, .ANeg, .BPos]
            case .ANeg:
                return [.ONeg, .ANeg]
            case .BPos:
                return [.ONeg, .OPos, .BNeg, .BPos]
            case .BNeg:
                return [.ONeg, .BNeg]
            case .OPos:
                return [.ONeg, .OPos]
            case .ONeg:
                return [.ONeg]
            default:
             return []
        }
    }
}

