//
//  EditPetView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//
import SwiftUI

struct EditPetView: View {
    @Environment(\.dismiss) var dismiss
    let pet: Pet
    
    @State private var petName: String
    @State private var species: String
    @State private var breed: String
    @State private var birthday: String
    @State private var gender: String
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    
    let speciesOptions = ["", "Dog", "Cat", "Bird", "Rabbit", "Other"]
    let genderOptions = ["Male", "Female"]
    
    // Initialize with existing pet data
    init(pet: Pet) {
        self.pet = pet
        _petName = State(initialValue: pet.name)
        _species = State(initialValue: pet.species)
        _breed = State(initialValue: pet.breed)
        _birthday = State(initialValue: pet.birthday)
        _gender = State(initialValue: pet.gender)
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
                    
                    Text("Edit Pet")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
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
                    VStack(spacing: 0) {
                        // Photo Preview Section
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.95, green: 0.91, blue: 1.0),
                                            Color(red: 0.91, green: 0.84, blue: 1.0)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 218)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3),
                                            style: StrokeStyle(lineWidth: 2, dash: [8])
                                        )
                                )
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 218)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "pawprint.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    
                                    Text("Current photo")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                        
                        // Upload Photo Button
                        Button(action: {
                            showImagePicker = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18))
                                
                                Text("Change Photo")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                            .cornerRadius(24)
                        }
                        .padding(.bottom, 12)
                        
                        // Form Fields
                        VStack(spacing: 4) {
                            // Pet Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pet Name")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("Enter pet's name", text: $petName)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Species (Picker)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Species")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Menu {
                                    ForEach(speciesOptions, id: \.self) { option in
                                        Button(action: {
                                            species = option
                                        }) {
                                            Text(option.isEmpty ? "Select species" : option)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(species.isEmpty ? "Select species" : species)
                                            .foregroundColor(species.isEmpty ? Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4) : .black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.6))
                                    }
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Breed
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Breed")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                TextField("e.g. Golden Retriever", text: $breed)
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Birthday
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Birthday")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                HStack {
                                    TextField("MM/DD/YYYY", text: $birthday)
                                        .keyboardType(.numbersAndPunctuation)
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.6))
                                }
                                .padding()
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            // Gender
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Menu {
                                    ForEach(genderOptions, id: \.self) { option in
                                        Button(action: {
                                            gender = option
                                        }) {
                                            Text(option)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(gender)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.6))
                                    }
                                    .padding()
                                    .frame(height: 56)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        
                        // Extra spacing for bottom button
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Save Button (Sticky Bottom)
                VStack(spacing: 0) {
                    Button(action: {
                        updatePet()
                    }) {
                        Text("Save Changes")
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
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    func updatePet() {
        // TODO: Update pet in CoreData/Firebase
        print("Updating pet:")
        print("Name: \(petName)")
        print("Species: \(species)")
        print("Breed: \(breed)")
        print("Birthday: \(birthday)")
        print("Gender: \(gender)")
        
        // Dismiss after updating
        dismiss()
    }
}

struct EditPetView_Previews: PreviewProvider {
    static var previews: some View {
        EditPetView(pet: Pet(name: "Buddy", image: "dog-buddy", isActive: true, species: "Dog", breed: "Golden Retriever", birthday: "01/15/2023", gender: "Male"))
    }
}
