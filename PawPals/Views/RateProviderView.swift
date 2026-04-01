//
//  RateProviderView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RateProviderView: View {
    @Environment(\.dismiss) var dismiss
    let booking: Booking
    
    @State private var rating: Int = 5
    @State private var review: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var isSubmitting: Bool = false
    @State private var showSuccessAlert: Bool = false
    
    let tags = ["Professional", "Friendly", "Punctual", "Great with pets", "Clean", "Reliable"]
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
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
                    
                    Text("Rate Provider")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 100)
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
                    VStack(spacing: 24) {
                        // Provider Info
                        VStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.9),
                                            Color(red: 0.65, green: 0.5, blue: 0.95)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(String(booking.serviceProviderName.prefix(1)).uppercased())
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            Text(booking.serviceProviderName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("\(booking.serviceName) • \(booking.petName)")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 24)
                        
                        // Rating Stars
                        VStack(spacing: 12) {
                            Text("How was your experience?")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 16) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.system(size: 36))
                                            .foregroundColor(star <= rating ? .orange : .gray.opacity(0.3))
                                    }
                                }
                            }
                            
                            Text(ratingText)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 16)
                        
                        // Tags
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select tags (optional)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(tags, id: \.self) { tag in
                                    Button(action: {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }) {
                                        Text(tag)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedTags.contains(tag) ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                selectedTags.contains(tag) ?
                                                Color(red: 0.6, green: 0.4, blue: 0.9) :
                                                Color.white
                                            )
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: selectedTags.contains(tag) ? 0 : 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Review Text
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Write a review (optional)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            ZStack(alignment: .topLeading) {
                                if review.isEmpty {
                                    Text("Share more about your experience...")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $review)
                                    .font(.system(size: 15))
                                    .frame(height: 120)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Submit Button
                VStack {
                    Button(action: {
                        submitRating()
                    }) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Submitting...")
                                    .font(.system(size: 18, weight: .bold))
                            } else {
                                Text("Submit Rating")
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
                    .disabled(isSubmitting)
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }
        }
        .navigationBarHidden(true)
        .alert("Thank You!", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your rating has been submitted successfully!")
        }
    }
    
    var ratingText: String {
        switch rating {
        case 1: return "Poor"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Very Good"
        case 5: return "Excellent"
        default: return ""
        }
    }
    
    // MARK: - Submit Rating
    func submitRating() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isSubmitting = true
        
        let db = Firestore.firestore()
        let reviewRef = db.collection("serviceProviders").document(booking.serviceProviderId).collection("reviews").document()
        
        let reviewData: [String: Any] = [
            "userId": userId,
            "bookingId": booking.id,
            "rating": rating,
            "review": review,
            "tags": Array(selectedTags),
            "petName": booking.petName,
            "service": booking.serviceName,
            "createdAt": Date()
        ]
        
        reviewRef.setData(reviewData) { error in
            isSubmitting = false
            
            if let error = error {
                print("❌ Error submitting rating: \(error.localizedDescription)")
            } else {
                print("✅ Rating submitted successfully")
                updateProviderRating()
                showSuccessAlert = true
            }
        }
    }
    
    // MARK: - Update Provider Rating
    func updateProviderRating() {
        let db = Firestore.firestore()
        let providerRef = db.collection("serviceProviders").document(booking.serviceProviderId)
        
        // In a real app, you'd calculate the new average rating from all reviews
        // For now, we'll just increment the review count
        providerRef.updateData([
            "reviewCount": FieldValue.increment(Int64(1))
        ])
    }
}

struct RateProviderView_Previews: PreviewProvider {
    static var previews: some View {
        RateProviderView(booking: Booking(
            id: "1",
            petOwnerId: "owner123",
            petName: "bob",
            petOwnerName: "John Smith",
            serviceProviderId: "provider456",
            serviceProviderName: "James Rodriguez",
            serviceProviderPhone: "222-234-6578",
            serviceName: "Dog Walking",
            date: "03/25/2026",
            time: "2:00 PM",
            status: "completed",
            notes: "Great service!",
            totalPrice: 25.0
        ))
    }
}
