//
//  MedicalRecordsView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct MedicalRecordsView: View {
    @Environment(\.dismiss) var dismiss
    let pet: Pet
    
    @State private var medicalRecords: [MedicalRecord] = [
        MedicalRecord(
            type: .vaccination,
            title: "Rabies Shot",
            date: Date(),
            provider: "Dr. Smith",
            notes: "Vaccination valid for 3 years. Next booster due Oct 2026.",
            icon: "syringe.fill"
        ),
        MedicalRecord(
            type: .checkup,
            title: "Annual Checkup",
            date: Calendar.current.date(byAdding: .day, value: -27, to: Date())!,
            provider: "Healthy Paws Clinic",
            notes: "General physical exam completed. All vitals are normal. Heartbeat strong.",
            icon: "heart.text.square.fill"
        ),
        MedicalRecord(
            type: .weight,
            title: "Weight Entry",
            date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
            provider: "25.4 lbs",
            notes: "Weight is stable. Increase activity slightly to maintain ideal condition.",
            icon: "chart.line.uptrend.xyaxis"
        ),
        MedicalRecord(
            type: .medication,
            title: "Deworming Treatment",
            date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
            provider: "Home Administered",
            notes: "",
            icon: "pills.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    Spacer()
                    
                    Text("Medical Records")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        print("More options")
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(90))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Pet Profile Header
                        VStack(spacing: 16) {
                            // Pet Photo
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 128, height: 128)
                                .overlay(
                                    Image(systemName: "pawprint.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray.opacity(0.5))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2),
                                            lineWidth: 4
                                        )
                                )
                                .padding(.top, 8)
                            
                            VStack(spacing: 4) {
                                Text(pet.name)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("\(pet.breed) • \(calculateAge(from: pet.birthday))")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        .padding(.bottom, 8)
                        
                        // Add Record Button
                        NavigationLink(destination: AddMedicalRecordView(pet: pet)) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Add Record")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.6, green: 0.3, blue: 0.95),
                                        Color(red: 0.65, green: 0.4, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 16)
                        
                        // Health History Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Health History")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                            Rectangle()
                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(width: 48, height: 4)
                                .cornerRadius(2)
                                .padding(.horizontal, 16)
                        }
                        
                        // Timeline
                        VStack(spacing: 0) {
                            ForEach(Array(medicalRecords.enumerated()), id: \.element.id) { index, record in
                                MedicalRecordRow(
                                    record: record,
                                    isLast: index == medicalRecords.count - 1
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func calculateAge(from birthday: String) -> String {
        
        return "2 years old"
    }
}

// MARK: - Medical Record Row
struct MedicalRecordRow: View {
    let record: MedicalRecord
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon and Timeline
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: record.icon)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .font(.system(size: 20))
                    )
                
                if !isLast {
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                        .frame(width: 2)
                        .frame(minHeight: 40)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(record.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 6) {
                    Image(systemName: record.dateIcon)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    
                    Text("\(record.date, style: .date) • \(record.provider)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 0.45, green: 0.3, blue: 0.6))
                }
                
                if !record.notes.isEmpty {
                    Text(record.notes)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
            }
            .padding(.bottom, isLast ? 0 : 24)
            
            Spacer()
        }
    }
}

// MARK: - Medical Record Model
struct MedicalRecord: Identifiable {
    let id = UUID()
    let type: RecordType
    let title: String
    let date: Date
    let provider: String
    let notes: String
    let icon: String
    
    var dateIcon: String {
        switch type {
        case .vaccination: return "calendar"
        case .checkup: return "stethoscope"
        case .weight: return "scalemass.fill"
        case .medication: return "clock.fill"
        }
    }
}

enum RecordType {
    case vaccination
    case checkup
    case weight
    case medication
}

// MARK: - Add Medical Record View
struct AddMedicalRecordView: View {
    @Environment(\.dismiss) var dismiss
    let pet: Pet
    @State private var recordType: String = "Vaccination"
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var provider: String = ""
    @State private var notes: String = ""
    @State private var weight: String = ""
    @State private var temperature: String = ""
    @State private var showSuccessMessage: Bool = false
    
    let recordTypes = ["Vaccination", "Checkup", "Weight", "Medication", "Surgery", "Allergy", "Injury", "Other"]
    
    var recordIcon: String {
        switch recordType {
        case "Vaccination": return "syringe.fill"
        case "Checkup": return "heart.text.square.fill"
        case "Weight": return "chart.line.uptrend.xyaxis"
        case "Medication": return "pills.fill"
        case "Surgery": return "bandage.fill"
        case "Allergy": return "exclamationmark.triangle.fill"
        case "Injury": return "cross.case.fill"
        default: return "doc.text.fill"
        }
    }
    
    var recordColor: Color {
        switch recordType {
        case "Vaccination": return Color(red: 0.6, green: 0.4, blue: 0.9)
        case "Checkup": return .red
        case "Weight": return .blue
        case "Medication": return .green
        case "Surgery": return .orange
        case "Allergy": return .yellow
        case "Injury": return .pink
        default: return .gray
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    Spacer()
                    
                    Text("Add Medical Record")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Pet Info Card
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .font(.system(size: 24))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Medical Record for")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                Text(pet.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(pet.breed)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Record Type Selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Record Type")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(recordTypes, id: \.self) { type in
                                        RecordTypeChip(
                                            type: type,
                                            icon: getIcon(for: type),
                                            isSelected: recordType == type,
                                            action: {
                                                recordType = type
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Image(systemName: recordIcon)
                                        .foregroundColor(recordColor)
                                        .font(.system(size: 18))
                                    
                                    TextField(getPlaceholder(for: recordType), text: $title)
                                        .font(.system(size: 16))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .accentColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            // Provider/Location
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Provider/Location")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Image(systemName: "stethoscope")
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        .font(.system(size: 18))
                                    
                                    TextField("e.g., Dr. Smith or Healthy Paws Clinic", text: $provider)
                                        .font(.system(size: 16))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Weight (
                            if recordType == "Weight" {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Weight (lbs)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Image(systemName: "scalemass.fill")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 18))
                                        
                                        TextField("25.4", text: $weight)
                                            .keyboardType(.decimalPad)
                                            .font(.system(size: 16))
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Temperature (if Checkup record type)
                            if recordType == "Checkup" {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Temperature (°F) - Optional")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Image(systemName: "thermometer")
                                            .foregroundColor(.red)
                                            .font(.system(size: 18))
                                        
                                        TextField("101.5", text: $temperature)
                                            .keyboardType(.decimalPad)
                                            .font(.system(size: 16))
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                ZStack(alignment: .topLeading) {
                                    if notes.isEmpty {
                                        Text("Add any additional details, observations, or instructions...")
                                            .foregroundColor(.gray.opacity(0.6))
                                            .font(.system(size: 15))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 16)
                                    }
                                    
                                    TextEditor(text: $notes)
                                        .frame(height: 120)
                                        .padding(8)
                                        .font(.system(size: 15))
                                        .scrollContentBackground(.hidden)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                            
                            // Tips Card
                            HStack(spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 20))
                                
                                Text("Tip: Keep records up to date to ensure \(pet.name) gets the best care!")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                            .padding(12)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer().frame(height: 100)
                    }
                }
                
                // Save Button
                VStack(spacing: 0) {
                    Button(action: saveRecord) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                            Text("Save Record")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.3, blue: 0.95),
                                    Color(red: 0.65, green: 0.4, blue: 0.9)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(title.isEmpty || provider.isEmpty)
                    .opacity(title.isEmpty || provider.isEmpty ? 0.5 : 1.0)
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
            
            // Success Overlay
            if showSuccessMessage {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text("Record Saved!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Medical record added for \(pet.name)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 40)
            }
        }
        .navigationBarHidden(true)
    }
    
    func getIcon(for type: String) -> String {
        switch type {
        case "Vaccination": return "syringe.fill"
        case "Checkup": return "heart.text.square.fill"
        case "Weight": return "chart.line.uptrend.xyaxis"
        case "Medication": return "pills.fill"
        case "Surgery": return "bandage.fill"
        case "Allergy": return "exclamationmark.triangle.fill"
        case "Injury": return "cross.case.fill"
        default: return "doc.text.fill"
        }
    }
    
    func getPlaceholder(for type: String) -> String {
        switch type {
        case "Vaccination": return "e.g., Rabies Shot, DHPP Vaccine"
        case "Checkup": return "e.g., Annual Checkup, Wellness Exam"
        case "Weight": return "e.g., Weight Check, Monthly Weigh-In"
        case "Medication": return "e.g., Heartworm Prevention, Antibiotics"
        case "Surgery": return "e.g., Spay/Neuter, Dental Cleaning"
        case "Allergy": return "e.g., Food Allergy, Environmental Allergy"
        case "Injury": return "e.g., Sprained Leg, Cut Paw"
        default: return "Enter record title"
        }
    }
    
    func saveRecord() {
        print("Saving medical record:")
        print("Pet: \(pet.name)")
        print("Type: \(recordType)")
        print("Title: \(title)")
        print("Date: \(date)")
        print("Provider: \(provider)")
        if recordType == "Weight" {
            print("Weight: \(weight) lbs")
        }
        if recordType == "Checkup" && !temperature.isEmpty {
            print("Temperature: \(temperature)°F")
        }
        print("Notes: \(notes)")
        
        // Show success message
        withAnimation {
            showSuccessMessage = true
        }
        
        // TODO: Save to CoreData/Firebase
        
        // Dismiss after showing success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSuccessMessage = false
            }
            dismiss()
        }
    }
}

// MARK: - Record Type Chip
struct RecordTypeChip: View {
    let type: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var chipColor: Color {
        switch type {
        case "Vaccination": return Color(red: 0.6, green: 0.4, blue: 0.9)
        case "Checkup": return .red
        case "Weight": return .blue
        case "Medication": return .green
        case "Surgery": return .orange
        case "Allergy": return .yellow
        case "Injury": return .pink
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(isSelected ? chipColor : chipColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(isSelected ? .white : chipColor)
                            .font(.system(size: 22))
                    )
                
                Text(type)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? chipColor : .gray)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
        }
    }
}

struct MedicalRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalRecordsView(
            pet: Pet(
                name: "Buddy",
                image: "dog",
                isActive: true,
                species: "Dog",
                breed: "Golden Retriever",
                birthday: "01/15/2022",
                gender: "Male"
            )
        )
    }
}
