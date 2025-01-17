//
//  A1Tests.swift
//  A1Tests
//
//  Created by Jennifer Lew on 1/13/25.
//

import Testing
import Foundation
@testable import PatientOrganization

struct PatientOrganizationTests {

    // MARK: Medication Tests
    @Test func testMedicationInitialization() async throws {
        let calendar = Calendar.current
        let component = DateComponents(year: 2021, month: 5, day: 8, hour: 9, minute: 30)
        guard let med1date = calendar.date(from: component) else { return }

        let medication1 = Medication(date: med1date, name: "Aspirin", dose: 81, route: "by mouth", frequency: 1, duration: 60)
        let medication2 = Medication(date: Date(), name: "Aspirin", dose: 25, route: "by mouth", frequency: 3, duration: 20)

        #expect(medication1.name == "Aspirin")
        #expect(medication1.date == med1date)
        #expect(medication1.dose == 81)
        #expect(medication1.route == "by mouth")
        #expect(medication1.frequency == 1)
        #expect(medication1.duration == 60)
    }

    @Test func testMedicationIsCurrent() async throws {
        let medication1 = Medication(date: Date(), name: "Aspirin", dose: 81, route: "by mouth", frequency: 1, duration: -10) // Already expired
        let medication2 = Medication(date: Date(), name: "Ibuprofen", dose: 200, route: "by mouth", frequency: 1, duration: 30) // Active

        #expect(medication1.isCurrent() == false)
        #expect(medication2.isCurrent() == true)
    }

    // MARK: Patient Initialization Tests
    @Test func testPatientInitialization() throws {
        let calendar = Calendar.current
        let DOBcomponent = DateComponents(year: 2004, month: 1, day: 25, hour: 9, minute: 30)
        guard let DOB = calendar.date(from: DOBcomponent) else { return }

        let medication1 = Medication(date: Date(), name: "Metoprolol", dose: 25, route: "by mouth", frequency: 1, duration: 90)
        let medication2 = Medication(date: Date(), name: "Aspirin", dose: 81, route: "by mouth", frequency: 1, duration: 60)

        let patient = Patient(
            firstName: "Sarah",
            lastName: "Bowlen",
            sex: "F",
            dateOfBirth: DOB,
            height: 178,
            weight: 140,
            bloodType: .BPos,
            medications: [medication1, medication2]
        )

        #expect(patient.firstName == "Sarah")
        #expect(patient.lastName == "Bowlen")
        #expect(patient.dateOfBirth == DOB)
        #expect(patient.sex == "F")
        #expect(patient.height == 178)
        #expect(patient.weight == 140)
        #expect(patient.bloodType == .BPos)
    }

    @Test func testPatientComputedProperties() throws {
        let calendar = Calendar.current
        let DOBcomponent = DateComponents(year: 2004, month: 1, day: 25, hour: 9, minute: 30)
        guard let DOB = calendar.date(from: DOBcomponent) else { return }

        let patient = Patient(
            firstName: "Sarah",
            lastName: "Bowlen",
            sex: "F",
            dateOfBirth: DOB,
            height: 178,
            weight: 140,
            bloodType: .BPos,
            medications: []
        )

        #expect(patient.fullName() == "Bowlen, Sarah (20)")
        #expect(patient.age() == 20)
        #expect(patient.getBloodType() == "B+")
    }

    // Patient Medication Management Tests
    @Test func testPatientMedicationManagement() throws {
        let calendar = Calendar.current
        let component = DateComponents(year: 2021, month: 5, day: 8, hour: 9, minute: 30)
        guard let med2date = calendar.date(from: component) else { return }

        let medication1 = Medication(date: Date(), name: "Metoprolol", dose: 25, route: "by mouth", frequency: 1, duration: 90)
        let medication2 = Medication(date: med2date, name: "Aspirin", dose: 81, route: "by mouth", frequency: 1, duration: 60)
        let duplicate = Medication(date: Date(), name: "Metoprolol", dose: 12.5, route: "by mouth", frequency: 2, duration: 50)
        let medication4 = Medication(date: Date(), name: "Losartan", dose: 30, route: "inhaled", frequency: 3, duration: 40)

        var patient = Patient(
            firstName: "Sarah",
            lastName: "Bowlen",
            sex: "F",
            dateOfBirth: Date(),
            height: 178,
            weight: 140,
            bloodType: .BPos,
            medications: [medication1, medication2]
        )

        // Check active medications
        #expect(patient.currentMed() == [medication1])

        // Test adding duplicate prescription
        #expect(throws: PrescriptionError.duplicateMedication) {
            try patient.prescribeMed(duplicate)
        }

        // Test adding new medication
        try patient.prescribeMed(medication4)
        #expect(patient.medications.contains(medication4))
        #expect(patient.currentMed().contains(medication4))
    }

    // Patient Blood Type Compatibility Tests
    @Test func testPatientBloodTypeCompatibility() throws {
        let patient = Patient(
            firstName: "Sarah",
            lastName: "Bowlen",
            sex: "F",
            dateOfBirth: Date(),
            height: 178,
            weight: 140,
            bloodType: .BPos,
            medications: []
        )

        #expect(patient.compatibleDonor() == [.ONeg, .OPos, .BNeg, .BPos])
    }
}