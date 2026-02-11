//
//  PaymentView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPaymentMethod: String = "Card"
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    @State private var cardHolderName: String = ""
    @State private var saveCard: Bool = false
    @State private var showingSuccess: Bool = false
    
    let paymentMethods = ["Card", "Apple Pay", "Google Pay"]
    let bookingFee: Double = 45.00
    let serviceFee: Double = 5.00
    
    var total: Double {
        bookingFee + serviceFee
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
                    
                    Text("Payment")
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Booking Summary Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Booking Summary")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pet Sitting")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Text("Buddy • Today at 2:00 PM")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "house.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3))
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Payment Method Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Payment Method")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                            
                            HStack(spacing: 12) {
                                ForEach(paymentMethods, id: \.self) { method in
                                    PaymentMethodChip(
                                        method: method,
                                        isSelected: selectedPaymentMethod == method,
                                        action: {
                                            selectedPaymentMethod = method
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Card Details (only show if Card is selected)
                        if selectedPaymentMethod == "Card" {
                            VStack(spacing: 16) {
                                // Card Number
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Card Number")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        
                                        TextField("1234 5678 9012 3456", text: $cardNumber)
                                            .keyboardType(.numberPad)
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
                                
                                // Expiry and CVV
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Expiry Date")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        TextField("MM/YY", text: $expiryDate)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 16))
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                            )
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("CVV")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        TextField("123", text: $cvv)
                                            .keyboardType(.numberPad)
                                            .font(.system(size: 16))
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                            )
                                    }
                                }
                                
                                // Card Holder Name
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cardholder Name")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    TextField("John Doe", text: $cardHolderName)
                                        .font(.system(size: 16))
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                // Save Card Toggle
                                HStack {
                                    Toggle(isOn: $saveCard) {
                                        Text("Save card for future bookings")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .tint(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Apple Pay / Google Pay Message
                        if selectedPaymentMethod == "Apple Pay" {
                            VStack(spacing: 12) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 48))
                                    .foregroundColor(.black)
                                
                                Text("Pay with Apple Pay")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("Touch ID or Face ID required")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        }
                        
                        if selectedPaymentMethod == "Google Pay" {
                            VStack(spacing: 12) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color.blue)
                                
                                Text("Pay with Google Pay")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("Secure payment")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        }
                        
                        // Price Breakdown
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Price Breakdown")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 12) {
                                PriceRow(label: "Booking Fee", value: "$\(String(format: "%.2f", bookingFee))")
                                PriceRow(label: "Service Fee", value: "$\(String(format: "%.2f", serviceFee))")
                                
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                                
                                HStack {
                                    Text("Total")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", total))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                            .frame(height: 120)
                    }
                }
                
                // Pay Button
                VStack(spacing: 0) {
                    Button(action: {
                        processPayment()
                    }) {
                        Text("Pay $\(String(format: "%.2f", total))")
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
            
            // Success Overlay
            if showingSuccess {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                SuccessCard()
            }
        }
        .navigationBarHidden(true)
    }
    
    func processPayment() {
        print("Processing payment...")
        print("Method: \(selectedPaymentMethod)")
        print("Amount: $\(total)")
        
        if selectedPaymentMethod == "Card" {
            print("Card: \(cardNumber)")
            print("Expiry: \(expiryDate)")
            print("CVV: \(cvv)")
            print("Name: \(cardHolderName)")
            print("Save: \(saveCard)")
        }
        
        // Show success animation
        withAnimation {
            showingSuccess = true
        }
        
        // Dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingSuccess = false
            }
            dismiss()
        }
    }
}

// MARK: - Payment Method Chip
struct PaymentMethodChip: View {
    let method: String
    let isSelected: Bool
    let action: () -> Void
    
    var icon: String {
        switch method {
        case "Card": return "creditcard.fill"
        case "Apple Pay": return "apple.logo"
        case "Google Pay": return "g.circle.fill"
        default: return "dollarsign.circle.fill"
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(method)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected ?
                Color(red: 0.6, green: 0.4, blue: 0.9) :
                Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Price Row
struct PriceRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
        }
    }
}

// MARK: - Success Card
struct SuccessCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                )
            
            Text("Payment Successful!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text("Your booking has been confirmed")
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

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
