//
//  ChatView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    let booking: Booking
    @Environment(\.dismiss) var dismiss
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var listener: ListenerRegistration?
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    Circle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(booking.serviceProviderName.prefix(1).uppercased())
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(booking.serviceProviderName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Service Provider")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Call button
                    Button(action: {
                        if let phoneURL = URL(string: "tel://\(booking.serviceProviderPhone)") {
                            UIApplication.shared.open(phoneURL)
                        }
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "phone.fill")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 18))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Messages Area
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            // Date Divider
                            Text("Today")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .padding(.top, 16)
                            
                            // Chat Messages
                            ForEach(messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
                
                // Message Input
                HStack(spacing: 12) {
                    // Text field
                    HStack {
                        TextField("Type a message...", text: $messageText)
                            .font(.system(size: 16))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    
                    // Send button
                    Button(action: sendMessage) {
                        Circle()
                            .fill(
                                messageText.isEmpty ?
                                Color.gray.opacity(0.3) :
                                Color(red: 0.6, green: 0.4, blue: 0.9)
                            )
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "arrow.up")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            )
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(12)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: -1)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadMessages()
        }
        .onDisappear {
            listener?.remove()
        }
    }
    
    // MARK: - Load Messages
    func loadMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let chatId = getChatId(userId: currentUserId, providerId: booking.serviceProviderId)
        let db = Firestore.firestore()
        
        listener = db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error loading messages: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                messages = documents.compactMap { doc -> ChatMessage? in
                    let data = doc.data()
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    
                    return ChatMessage(
                        id: doc.documentID,
                        text: data["message"] as? String ?? "",
                        isFromMe: (data["senderId"] as? String) == currentUserId,
                        timestamp: timestamp,
                        senderId: data["senderId"] as? String,
                        senderName: data["senderName"] as? String
                    )
                }
                
                print("✅ Loaded \(messages.count) messages")
            }
    }
    
    // MARK: - Send Message
    func sendMessage() {
        guard !messageText.isEmpty,
              let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let chatId = getChatId(userId: currentUserId, providerId: booking.serviceProviderId)
        let db = Firestore.firestore()
        
        let messageData: [String: Any] = [
            "senderId": currentUserId,
            "senderName": "User",
            "message": messageText,
            "timestamp": Timestamp(date: Date()),
            "isRead": false
        ]
        
        db.collection("chats").document(chatId).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("❌ Error sending message: \(error.localizedDescription)")
                } else {
                    print("✅ Message sent successfully")
                }
            }
        
        messageText = ""
    }
    
    // MARK: - Get Chat ID
    func getChatId(userId: String, providerId: String) -> String {
        let ids = [userId, providerId].sorted()
        return ids.joined(separator: "_")
    }
}

// MARK: - Chat Bubble View (Renamed to avoid conflicts)
struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromMe {
                Spacer()
            }
            
            VStack(alignment: message.isFromMe ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 15))
                    .foregroundColor(message.isFromMe ? .white : .black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromMe ?
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.6, green: 0.3, blue: 0.95),
                                Color(red: 0.65, green: 0.4, blue: 0.9)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                Text(formatTime(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromMe {
                Spacer()
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// ✅ NO ChatMessage struct here - uses Models/ChatMessage.swift

// REMOVED: ChatView_Previews to avoid type errors
// Use the actual app to test ChatView with real Booking data
