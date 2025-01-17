enum BloodType: String, CustomStringConvertible,  CaseIterable  {
    case APos = "A+"
    case ANeg = "A-"
    case BPos = "B+"
    case BNeg = "B-"
    case OPos = "O+"
    case ONeg = "O-"
    case ABPos = "AB+"
    case ABNeg = "AB-"

    /// A human-readable description of the blood type.
    var description: String {
        return self.rawValue
    }
}
