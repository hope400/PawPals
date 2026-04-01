import SwiftUI

struct PetProfileView: View {
    @Environment(\.dismiss) var dismiss
    let pet: Pet
    
    // Calculate age from birthday
    func calculateAge(from birthday: String) -> String {
        if birthday.isEmpty {
            return "Age unknown"
        }
        // Simple age calculation
        return "Birthday: \(birthday)"
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header - FIXED WITH VISIBLE BACK BUTTON
                HStack(spacing: 0) {
                    // Back button - LEFT
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.leading, 16)
                        .frame(width: 100, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    // Title - CENTER
                    Text("Pet Details")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Edit button - RIGHT
                    NavigationLink(destination: EditPetView(pet: pet)) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "pencil")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 16, weight: .semibold))
                            )
                    }
                    .padding(.trailing, 16)
                    .frame(width: 100, alignment: .trailing)
                }
                .frame(height: 50)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                .overlay(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Pet Image with AsyncImage
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                                .frame(height: 320)
                            
                            // Display image if available
                            if let imageURL = pet.imageURL, !imageURL.isEmpty {
                                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 320)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 320)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    case .failure:
                                        // Fallback to placeholder on error
                                        Image(systemName: "pawprint.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.5))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                // Placeholder if no image
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.5))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        // Pet Name and Info Header
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pet.name)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("\(pet.breed.isEmpty ? pet.species : pet.breed) • \(calculateAge(from: pet.birthday))")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            
                            Spacer()
                            
                            // Gender badge
                            Text(pet.gender.uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                                .cornerRadius(20)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Info Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                if pet.isSterilized {
                                    InfoChip(icon: "checkmark.shield.fill", text: pet.gender.lowercased() == "male" ? "Neutered" : "Spayed")
                                }
                                if pet.isMicrochipped {
                                    InfoChip(icon: "qrcode", text: "Microchipped")
                                }
                                if pet.isVaccinated {
                                    InfoChip(icon: "cross.vial.fill", text: "Vaccinated")
                                }
                                if !pet.temperament.isEmpty {
                                    InfoChip(icon: "face.smiling", text: pet.temperament)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 16)
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About \(pet.name)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("\(pet.name) is a wonderful companion!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        
                        // Medical Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Medical Information")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                MedicalInfoRow(
                                    icon: "calendar",
                                    title: "Last Checkup",
                                    value: "Jan 15, 2026",
                                    color: Color.blue
                                )
                                
                                MedicalInfoRow(
                                    icon: "cross.vial.fill",
                                    title: "Next Vaccination",
                                    value: "Mar 10, 2026",
                                    color: Color.purple
                                )
                                
                                MedicalInfoRow(
                                    icon: "pill.fill",
                                    title: "Medications",
                                    value: "None",
                                    color: Color.green
                                )
                                
                                MedicalInfoRow(
                                    icon: "heart.text.square.fill",
                                    title: "Allergies",
                                    value: "None known",
                                    color: Color.orange
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 20)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            // Book Session Button
                            Button(action: {
                                print("Book session tapped")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Book Session")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
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
                                .cornerRadius(25)
                                .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            // Log Medical Record Button
                            NavigationLink(destination: MedicalRecordsView(pet: pet)) {
                                HStack(spacing: 8) {
                                    Image(systemName: "cross.case.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Log Medical Record")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4), lineWidth: 2)
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Info Chip
struct InfoChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Medical Info Row
struct MedicalInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PetProfileView(pet: Pet(
            id: UUID(),
            name: "Buddy",
            image: "dog-buddy",
            isActive: true,
            species: "Dog",
            breed: "Golden Retriever",
            birthday: "01/15/2023",
            gender: "Male",
            imageURL: "https://firebasestorage.googleapis.com/..."
        ))
    }
}
