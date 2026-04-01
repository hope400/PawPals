//
//  BookingView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct BookingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let provider: ServiceProvider
    
    @State private var selectedPet: Pet?
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String = "9:00 AM"
    @State private var selectedDuration: String = "1 hour"
    @State private var notes: String = ""
    @State private var showPetPicker: Bool = false
    @State private var pets: [Pet] = []
    @State private var isLoading: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    let timeSlots = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
    let durations = ["30 minutes", "1 hour", "2 hours", "3 hours", "4 hours"]
    
    var totalPrice: Double {
        let hours: Double
        switch selectedDuration {
        case "30 minutes": hours = 0.5
        case "1 hour": hours = 1.0
        case "2 hours": hours = 2.0
        case "3 hours": hours = 3.0
        case "4 hours": hours = 4.0
        default: hours = 1.0
        }
        return provider.hourlyRate * hours
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
                    
                    Text("Book Service")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 10)
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                
                ScrollView {
                    VStack(spacing: 20) {
                        providerCard
                        selectPetSection
                        dateTimeSection
                        notesSection
                        priceSummary
                        
                        Spacer().frame(height: 100)
                    }
                }
                
                bookButton
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPetPicker) {
            PetPickerView(selectedPet: $selectedPet, pets: pets)
        }
        .alert("Booking Confirmed!", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your booking with \(provider.name) has been confirmed!")
        }
        .alert("Booking Failed", isPresented: $showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .onAppear { loadPets() }
    }
    
    // MARK: - View Components
    
    private var providerCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.4, blue: 0.9),
                        Color(red: 0.65, green: 0.5, blue: 0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(provider.name.prefix(1)).uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(provider.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", provider.rating))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text("$\(Int(provider.hourlyRate))/hr")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                }
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    private var selectPetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Pet")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 16)
            
            Button(action: { showPetPicker = true }) {
                HStack {
                    if let pet = selectedPet {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(pet.name.prefix(1).uppercased())
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("\(pet.species) • \(pet.breed)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Text("Select a pet")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date & Time")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 16)
            
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Time")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(timeSlots, id: \.self) { time in
                            timeSlotButton(time)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Duration")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(durations, id: \.self) { duration in
                            durationButton(duration)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
    }
    
    private func timeSlotButton(_ time: String) -> some View {
        Button(action: { selectedTime = time }) {
            Text(time)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedTime == time ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    selectedTime == time ?
                    Color(red: 0.6, green: 0.4, blue: 0.9) :
                    Color.white
                )
                .cornerRadius(8)
        }
    }
    
    private func durationButton(_ duration: String) -> some View {
        Button(action: { selectedDuration = duration }) {
            Text(duration)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedDuration == duration ? .white : .black)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    selectedDuration == duration ?
                    Color(red: 0.6, green: 0.4, blue: 0.9) :
                    Color.white
                )
                .cornerRadius(8)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Notes")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 16)
            
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
        }
    }
    
    private var priceSummary: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Hourly Rate")
                    .foregroundColor(.gray)
                Spacer()
                Text("$\(String(format: "%.2f", provider.hourlyRate))")
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Duration")
                    .foregroundColor(.gray)
                Spacer()
                Text(selectedDuration)
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text("$\(String(format: "%.2f", totalPrice))")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private var bookButton: some View {
        Button(action: createBooking) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Confirm Booking")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            selectedPet == nil ?
            AnyShapeStyle(Color.gray.opacity(0.5)) :
            AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.3, blue: 0.95),
                    Color(red: 0.65, green: 0.4, blue: 0.9)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            ))
        )
        .cornerRadius(12)
        .disabled(selectedPet == nil || isLoading)
        .padding(16)
    }
    
    // MARK: - Functions
    
    func loadPets() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("pets")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    return
                }
                
                pets = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    
                    // ✅ FIXED: No ownerId parameter
                    return Pet(
                        id: UUID(),
                        name: data["name"] as? String ?? "",
                        species: data["species"] as? String ?? "",
                        breed: data["breed"] as? String ?? "",
                        birthday: data["birthday"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        imageURL: data["imageURL"] as? String,
                        isSterilized: data["isSterilized"] as? Bool ?? false,
                        isMicrochipped: data["isMicrochipped"] as? Bool ?? false,
                        isVaccinated: data["isVaccinated"] as? Bool ?? false,
                        temperament: data["temperament"] as? String ?? ""
                    )
                } ?? []
                
                if !pets.isEmpty {
                    selectedPet = pets[0]
                }
            }
    }
    
    func createBooking() {
        guard let pet = selectedPet,
              let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: selectedDate)
        
        // ✅ FIXED: Use first service from array
        let serviceName = provider.service.first ?? "Service"
        
        let bookingData: [String: Any] = [
            "petOwnerId": userId,
            "petName": pet.name,
            "petOwnerName": appState.currentUserName,
            "serviceProviderId": provider.id,
            "serviceProviderName": provider.name,
            "serviceProviderPhone": provider.phone,
            "serviceName": serviceName,
            "date": dateString,
            "time": selectedTime,
            "status": "pending",
            "notes": notes,
            "totalPrice": totalPrice,
            "createdAt": Timestamp()
        ]
        
        Firestore.firestore().collection("bookings").addDocument(data: bookingData) { error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else {
                showSuccessAlert = true
            }
        }
    }
}

struct PetPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPet: Pet?
    let pets: [Pet]
    
    var body: some View {
        NavigationView {
            List(pets) { pet in
                Button(action: {
                    selectedPet = pet
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(pet.name.prefix(1).uppercased())
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("\(pet.species) • \(pet.breed)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if selectedPet?.id == pet.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                    }
                }
            }
            .navigationTitle("Select Pet")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}

// ✅ FIXED PREVIEW
struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(provider: ServiceProvider(
            id: "1",
            name: "James Rodriguez",
            service: ["Dog Walking", "Pet Sitting"],  // ✅ Array
            rating: 4.9,
            hourlyRate: 25.0,
            phone: "(555) 123-4667",
            email: "james@example.com",
            bio: "Experienced walker",
            reviewCount: 127,
            completedJobs: 243,
            memberSince: "2023"
        ))
        .environmentObject(AppState())
    }
}
