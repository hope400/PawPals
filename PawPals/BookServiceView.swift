//
//  BookServiceView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct BookServiceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedService: String = "Pet Sitting"
    @State private var selectedPet: String = "Buddy"
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String = "09:00 AM"
    @State private var specialInstructions: String = ""
    @State private var showingDatePicker: Bool = false
    
    let services = ["Pet Sitting", "Dog Walking", "Grooming", "Training", "Vet Visit"]
    let pets = ["Buddy", "Luna", "Max", "Coco"]
    let availableTimes = ["09:00 AM", "10:30 AM", "12:00 PM", "01:00 PM", "02:30 PM", "04:00 PM", "05:30 PM"]
    
    var serviceFee: Double {
        switch selectedService {
        case "Pet Sitting": return 45.0
        case "Dog Walking": return 25.0
        case "Grooming": return 60.0
        case "Training": return 50.0
        case "Vet Visit": return 75.0
        default: return 35.0
        }
    }
    
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
                    
                    Text("Book Service")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer
                    Color.clear
                        .frame(width: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Service Type Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Service Type")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(services, id: \.self) { service in
                                        ServiceCard(
                                            service: service,
                                            isSelected: selectedService == service,
                                            action: {
                                                selectedService = service
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        // Choose Pet Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Your Pet")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(pets, id: \.self) { pet in
                                        PetSelector(
                                            petName: pet,
                                            isSelected: selectedPet == pet,
                                            action: {
                                                selectedPet = pet
                                            }
                                        )
                                    }
                                    
                                    // Add Pet Button
                                    NavigationLink(destination: AddPetView()) {
                                        VStack(spacing: 8) {
                                            Circle()
                                                .stroke(
                                                    Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3),
                                                    style: StrokeStyle(lineWidth: 2, dash: [5])
                                                )
                                                .frame(width: 64, height: 64)
                                                .overlay(
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 24, weight: .semibold))
                                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                )
                                            
                                            Text("Add Pet")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        // Date & Time Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Date & Time")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            // Date Selector
                            Button(action: {
                                showingDatePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        .font(.system(size: 20))
                                    
                                    Text(selectedDate, style: .date)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal, 16)
                            
                            // Date Picker (when expanded)
                            if showingDatePicker {
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                                .padding(.horizontal, 16)
                                .accentColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            // Time Slots
                            Text("Available Times")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(availableTimes, id: \.self) { time in
                                        TimeSlotChip(
                                            time: time,
                                            isSelected: selectedTime == time,
                                            action: {
                                                selectedTime = time
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        // Special Instructions Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Special Instructions (Optional)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            TextEditor(text: $specialInstructions)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                )
                                .overlay(
                                    Group {
                                        if specialInstructions.isEmpty {
                                            Text("Add any special instructions or notes...")
                                                .foregroundColor(.gray.opacity(0.6))
                                                .padding(.leading, 12)
                                                .padding(.top, 16)
                                                .allowsHitTesting(false)
                                        }
                                    },
                                    alignment: .topLeading
                                )
                                .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                            .frame(height: 120)
                    }
                    .padding(.top, 16)
                }
                
                // Bottom Action Section
                VStack(spacing: 12) {
                    // Price Summary
                    HStack {
                        Text("Service Fee")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", serviceFee))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)
                    
                    // Confirm Button
                    Button(action: {
                        confirmBooking()
                    }) {
                        Text("Confirm & Pay")
                            .font(.system(size: 18, weight: .bold))
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
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .top
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    func confirmBooking() {
        print("Booking confirmed:")
        print("Service: \(selectedService)")
        print("Pet: \(selectedPet)")
        print("Date: \(selectedDate)")
        print("Time: \(selectedTime)")
        print("Instructions: \(specialInstructions)")
        print("Fee: $\(serviceFee)")
        
        dismiss()
    }
}

// MARK: - Service Card
struct ServiceCard: View {
    let service: String
    let isSelected: Bool
    let action: () -> Void
    
    var serviceIcon: String {
        switch service {
        case "Pet Sitting": return "house.fill"
        case "Dog Walking": return "figure.walk"
        case "Grooming": return "scissors"
        case "Training": return "person.fill.checkmark"
        case "Vet Visit": return "cross.case.fill"
        default: return "star.fill"
        }
    }
    
    var serviceColor: Color {
        switch service {
        case "Pet Sitting": return .purple
        case "Dog Walking": return .green
        case "Grooming": return .pink
        case "Training": return .blue
        case "Vet Visit": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    serviceColor.opacity(0.3),
                                    serviceColor.opacity(0.6)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 8) {
                        Image(systemName: serviceIcon)
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                        
                        Text(service)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .bold))
                                    )
                                    .padding(8)
                            }
                            Spacer()
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : Color.clear,
                            lineWidth: 3
                        )
                )
            }
        }
    }
}

// MARK: - Pet Selector
struct PetSelector: View {
    let petName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.gray.opacity(0.5))
                        )
                    
                    if isSelected {
                        Circle()
                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9), lineWidth: 3)
                            .frame(width: 72, height: 72)
                    }
                }
                
                Text(petName)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : .black)
            }
            .opacity(isSelected ? 1.0 : 0.6)
        }
    }
}

// MARK: - Time Slot Chip
struct TimeSlotChip: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
                    Color(red: 0.6, green: 0.4, blue: 0.9) :
                    Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            Color(red: 0.6, green: 0.4, blue: 0.9).opacity(isSelected ? 0 : 0.3),
                            lineWidth: 1
                        )
                )
        }
    }
}

struct BookServiceView_Previews: PreviewProvider {
    static var previews: some View {
        BookServiceView()
    }
}
