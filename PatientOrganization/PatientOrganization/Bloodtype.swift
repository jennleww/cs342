enum BloodType: String, CustomStringConvertible,  CaseIterable  {
    case APos = "A+"
    case ANeg = "A-"
    case BPos = "B+"
    case BNeg = "B-"
    case OPos = "O+"
    case ONeg = "O-"
    case ABPos = "AB+"
    case ABNeg = "AB-"

    
    var description: String {
        return self.rawValue
    }
}
