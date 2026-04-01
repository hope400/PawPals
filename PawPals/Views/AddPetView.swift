//
//  AddPetView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct AddPetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var petName: String = ""
    @State private var species: String = ""
    @State private var breed: String = ""
    @State private var birthday: String = ""
    @State private var gender: String = "Male"
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var isSaving: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var errorMessage: String = ""
    
    let speciesOptions = ["", "Dog", "Cat", "Bird", "Rabbit", "Other"]
    let genderOptions = ["Male", "Female"]
    
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
                    
                    Text("Add Pet")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Color.clear
                        .frame(width: 44)
                }
                .padding(.horizontal, 16)
                .frame(height: 50)
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
                                    
                                    Text("No photo selected")
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
                                
                                Text("Upload Photo")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.15))
                            .cornerRadius(24)
                        }
                        .padding(.bottom, 12)
                        
                        // Error Message
                        if !errorMessage.isEmpty {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                        }
                        
                        // Form Fields
                        VStack(spacing: 4) {
                            // Pet Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pet Name *")
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
                            
                            // Species
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Species *")
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
                
                // Save Button
                VStack(spacing: 0) {
                    Button(action: {
                        savePet()
                    }) {
                        HStack {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Saving...")
                                    .font(.system(size: 18, weight: .bold))
                            } else {
                                Text("Save Pet")
                                    .font(.system(size: 18, weight: .bold))
                            }
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
                    .disabled(isSaving || !isFormValid())
                    .opacity(isFormValid() ? 1.0 : 0.6)
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert("Pet Added!", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("\(petName) has been added to your pets!")
        }
    }
    
    // MARK: - Validation
    func isFormValid() -> Bool {
        return !petName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !species.isEmpty
    }
    
    // MARK: - Save Pet to Firebase
    func savePet() {
        // Validation
        guard !petName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a pet name"
            return
        }
        
        guard !species.isEmpty else {
            errorMessage = "Please select a species"
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "You must be logged in to add a pet"
            return
        }
        
        isSaving = true
        errorMessage = ""
        
        // If there's an image, upload it first
        if let image = selectedImage {
            uploadImageAndSavePet(image: image, userId: userId)
        } else {
            // No image, just save pet data
            savePetData(userId: userId, imageURL: nil)
        }
    }
    
    // MARK: - Upload Image to Firebase Storage
    func uploadImageAndSavePet(image: UIImage, userId: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            errorMessage = "Failed to process image"
            isSaving = false
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageId = UUID().uuidString
        let imageRef = storageRef.child("pet_images/\(userId)/\(imageId).jpg")
        
        // Upload image
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                errorMessage = "Failed to upload image: \(error.localizedDescription)"
                isSaving = false
                print("❌ Image upload error: \(error.localizedDescription)")
                return
            }
            
            // Get download URL
            imageRef.downloadURL { url, error in
                if let error = error {
                    errorMessage = "Failed to get image URL: \(error.localizedDescription)"
                    isSaving = false
                    print("❌ Download URL error: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    errorMessage = "Failed to get image URL"
                    isSaving = false
                    return
                }
                
                // Save pet data with image URL
                savePetData(userId: userId, imageURL: downloadURL.absoluteString)
            }
        }
    }
    
    // MARK: - Save Pet Data to Firestore
    func savePetData(userId: String, imageURL: String?) {
        let db = Firestore.firestore()
        
        // Create pet data
        var petData: [String: Any] = [
            "name": petName.trimmingCharacters(in: .whitespaces),
            "species": species,
            "breed": breed.trimmingCharacters(in: .whitespaces),
            "birthday": birthday.trimmingCharacters(in: .whitespaces),
            "gender": gender,
            "isActive": false,
            "isSterilized": false,
            "isMicrochipped": false,
            "isVaccinated": false,
            "temperament": "Friendly",
            "bio": "",
            "createdAt": FieldValue.serverTimestamp(),
            "userId": userId
        ]
        
        // Add image URL if available
        if let imageURL = imageURL {
            petData["imageURL"] = imageURL
        }
        
        // Save to Firestore: users/{userId}/pets/{petId}
        db.collection("users").document(userId).collection("pets").addDocument(data: petData) { error in
            isSaving = false
            
            if let error = error {
                errorMessage = "Failed to save pet: \(error.localizedDescription)"
                print("❌ Error saving pet: \(error.localizedDescription)")
            } else {
                print("✅ Pet saved successfully!")
                if imageURL != nil {
                    print("✅ Image URL saved: \(imageURL!)")
                }
                showSuccessAlert = true
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView()
    }
}
