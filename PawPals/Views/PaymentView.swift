//
//  PaymentView.swift
//  PawPals
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss

    // ── Passed in from BookServiceView ──────────────────
    var serviceName:  String = "Pet Sitting"
    var petName:      String = "Your Pet"
    var providerName: String = ""        // ← NEW
    var providerID:   String = ""        // ← NEW
    var date:         Date   = Date()
    var time:         String = "09:00 AM"
    var amount:       Double = 45.00

    let platformFee:  Double = 5.00
    var total:        Double { amount + platformFee }

    // ── Card fields ──────────────────────────────────────
    @State private var selectedPaymentMethod: String = "Card"
    @State private var cardNumber:     String = ""
    @State private var expiryDate:     String = ""
    @State private var cvv:            String = ""
    @State private var cardHolderName: String = ""
    @State private var saveCard:       Bool   = false
    @State private var showingSuccess: Bool   = false
    @State private var isProcessing:   Bool   = false
    @State private var errorMessage:   String = ""
    @State private var showError:      Bool   = false

    let paymentMethods = ["Card", "Apple Pay", "Google Pay"]

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97).ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ────────────────────────────────
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    Spacer()
                    Text("Payment")
                        .font(.system(size: 18, weight: .bold)).foregroundColor(.black)
                    Spacer()
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))

                ScrollView {
                    VStack(spacing: 24) {

                        // ── Booking Summary ───────────────────
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Booking Summary")
                                .font(.system(size: 18, weight: .bold)).foregroundColor(.black)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(serviceName)
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                                    Text("\(petName) · \(date.formatted(date: .abbreviated, time: .omitted)) at \(time)")
                                        .font(.system(size: 14)).foregroundColor(.gray)
                                    if !providerName.isEmpty {
                                        Text("Provider: \(providerName)")
                                            .font(.system(size: 13)).foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Image(systemName: "house.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.3))
                            }
                        }
                        .padding(16).background(Color.white).cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16).padding(.top, 16)

                        // ── Payment Method ────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Payment Method")
                                .font(.system(size: 18, weight: .bold)).foregroundColor(.black)
                                .padding(.horizontal, 16)

                            HStack(spacing: 12) {
                                ForEach(paymentMethods, id: \.self) { method in
                                    PaymentMethodChip(
                                        method: method,
                                        isSelected: selectedPaymentMethod == method,
                                        action: { selectedPaymentMethod = method }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // ── Card Details ──────────────────────
                        if selectedPaymentMethod == "Card" {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Card Number")
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                        TextField("1234 5678 9012 3456", text: $cardNumber)
                                            .keyboardType(.numberPad).font(.system(size: 16))
                                    }
                                    .padding().background(Color.white).cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1))
                                }

                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Expiry Date")
                                            .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                                        TextField("MM/YY", text: $expiryDate)
                                            .keyboardType(.numberPad).font(.system(size: 16))
                                            .padding().background(Color.white).cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1))
                                    }
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("CVV")
                                            .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                                        TextField("123", text: $cvv)
                                            .keyboardType(.numberPad).font(.system(size: 16))
                                            .padding().background(Color.white).cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1))
                                    }
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cardholder Name")
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                                    TextField("John Doe", text: $cardHolderName)
                                        .font(.system(size: 16))
                                        .padding().background(Color.white).cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2), lineWidth: 1))
                                }

                                Toggle(isOn: $saveCard) {
                                    Text("Save card for future bookings")
                                        .font(.system(size: 14)).foregroundColor(.gray)
                                }
                                .tint(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 16)
                        }

                        // ── Apple Pay ─────────────────────────
                        if selectedPaymentMethod == "Apple Pay" {
                            VStack(spacing: 12) {
                                Image(systemName: "apple.logo").font(.system(size: 48)).foregroundColor(.black)
                                Text("Pay with Apple Pay").font(.system(size: 16, weight: .semibold))
                                Text("Touch ID or Face ID required").font(.system(size: 14)).foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 32)
                        }

                        // ── Google Pay ────────────────────────
                        if selectedPaymentMethod == "Google Pay" {
                            VStack(spacing: 12) {
                                Image(systemName: "g.circle.fill").font(.system(size: 48)).foregroundColor(.blue)
                                Text("Pay with Google Pay").font(.system(size: 16, weight: .semibold))
                                Text("Secure payment").font(.system(size: 14)).foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 32)
                        }

                        // ── Price Breakdown ───────────────────
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Price Breakdown")
                                .font(.system(size: 18, weight: .bold)).foregroundColor(.black)

                            VStack(spacing: 12) {
                                PriceRow(label: serviceName,
                                         value: "$\(String(format: "%.2f", amount))")
                                PriceRow(label: "Platform Fee",
                                         value: "$\(String(format: "%.2f", platformFee))")
                                Divider().background(Color.gray.opacity(0.3))
                                HStack {
                                    Text("Total").font(.system(size: 18, weight: .bold)).foregroundColor(.black)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", total))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                }
                            }
                        }
                        .padding(16).background(Color.white).cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)

                        // Error message
                        if showError {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                                Text(errorMessage).font(.system(size: 13)).foregroundColor(.red)
                            }
                            .padding(12).background(Color.red.opacity(0.08)).cornerRadius(10)
                            .padding(.horizontal, 16)
                        }

                        Spacer().frame(height: 120)
                    }
                }

                // ── Pay Button ────────────────────────────────
                VStack(spacing: 0) {
                    Button(action: { processPayment() }) {
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.6, green: 0.3, blue: 0.95),
                                    Color(red: 0.65, green: 0.4, blue: 0.9)
                                ]),
                                startPoint: .leading, endPoint: .trailing
                            )
                            .cornerRadius(12).frame(height: 56)

                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Pay $\(String(format: "%.2f", total))")
                                    .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(isProcessing)
                    .padding(16)
                }
                .background(Color(red: 0.97, green: 0.96, blue: 0.97).opacity(0.95))
            }

            // ── Success Overlay ───────────────────────────────
            if showingSuccess {
                Color.black.opacity(0.4).ignoresSafeArea()
                SuccessCard()
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Process Payment + Save to Firebase

    func processPayment() {
        // Basic card validation
        if selectedPaymentMethod == "Card" {
            guard !cardNumber.isEmpty, !expiryDate.isEmpty,
                  !cvv.isEmpty, !cardHolderName.isEmpty else {
                errorMessage = "Please fill in all card details."
                showError    = true
                return
            }
        }
        showError    = false
        isProcessing = true

        // Save booking to Firebase
        saveBookingToFirebase { success in
            isProcessing = false
            if success {
                withAnimation { showingSuccess = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showingSuccess = false }
                    dismiss()
                }
            } else {
                errorMessage = "Payment succeeded but booking could not be saved. Please try again."
                showError    = true
            }
        }
    }

    func saveBookingToFirebase(completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let dateFormatter         = DateFormatter()
        dateFormatter.dateFormat  = "MM/dd/yyyy"
        let dateString            = dateFormatter.string(from: date)

        let bookingData: [String: Any] = [
            "petOwnerId":           uid,
            "petName":              petName,
            "serviceProviderId":    providerID,
            "serviceProviderName":  providerName,
            "serviceName":          serviceName,
            "date":                 dateString,
            "time":                 time,
            "status":               "pending",
            "totalPrice":           total,
            "paymentMethod":        selectedPaymentMethod,
            "createdAt":            Timestamp()
        ]

        Firestore.firestore()
            .collection("bookings")
            .addDocument(data: bookingData) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Booking save error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ Booking saved to Firebase")
                        completion(true)
                    }
                }
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
        case "Card":       return "creditcard.fill"
        case "Apple Pay":  return "apple.logo"
        case "Google Pay": return "g.circle.fill"
        default:           return "dollarsign.circle.fill"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 18))
                Text(method).font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color(red: 0.6, green: 0.4, blue: 0.9))
            .padding(.horizontal, 16).padding(.vertical, 12)
            .background(isSelected ? Color(red: 0.6, green: 0.4, blue: 0.9) : Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
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
            Text(label).font(.system(size: 15)).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(size: 15, weight: .semibold)).foregroundColor(.black)
        }
    }
}

// MARK: - Success Card
struct SuccessCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle().fill(Color.green).frame(width: 80, height: 80)
                .overlay(Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold)).foregroundColor(.white))
            Text("Payment Successful!")
                .font(.system(size: 24, weight: .bold)).foregroundColor(.black)
            Text("Your booking has been confirmed")
                .font(.system(size: 16)).foregroundColor(.gray)
        }
        .padding(32).background(Color.white).cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 40)
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
