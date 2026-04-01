//
//  MessagesView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var selectedFilter: String = "All"
    @State private var selectedTab = 2 // Messages tab
    
    let filterOptions = ["All", "Unread", "Service Providers", "Support"]
    
    @State private var conversations: [ConversationItem] = [
        ConversationItem(
            name: "James Rodriguez",
            lastMessage: "I'll be there at 2 PM for Buddy's walk!",
            timestamp: Date(),
            isUnread: true,
            unreadCount: 2,
            avatar: "person.circle.fill",
            userType: .provider,
            isOnline: true
        ),
        ConversationItem(
            name: "Sarah Mitchell",
            lastMessage: "Thank you! Luna was so well-behaved today 😊",
            timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            isUnread: false,
            unreadCount: 0,
            avatar: "person.circle.fill",
            userType: .provider,
            isOnline: false
        ),
        ConversationItem(
            name: "Dr. Emily Watson",
            lastMessage: "Buddy's checkup results look great! All healthy.",
            timestamp: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
            isUnread: true,
            unreadCount: 1,
            avatar: "person.circle.fill",
            userType: .provider,
            isOnline: false
        ),
        ConversationItem(
            name: "PawPals Support",
            lastMessage: "How can we help you today?",
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            isUnread: false,
            unreadCount: 0,
            avatar: "headphones.circle.fill",
            userType: .support,
            isOnline: true
        )
    ]
    
    var filteredConversations: [ConversationItem] {
        var filtered = conversations
        
        if !searchText.isEmpty {
            filtered = filtered.filter { conversation in
                conversation.name.localizedCaseInsensitiveContains(searchText) ||
                conversation.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case "Unread":
            filtered = filtered.filter { $0.isUnread }
        case "Service Providers":
            filtered = filtered.filter { $0.userType == .provider }
        case "Support":
            filtered = filtered.filter { $0.userType == .support }
        default:
            break
        }
        
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
    
    var unreadCount: Int {
        conversations.filter { $0.isUnread }.count
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Text("Messages")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    if unreadCount > 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(unreadCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Compose new message")
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search conversations", text: $searchText)
                        .font(.system(size: 16))
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            MessageFilterChip(
                                title: filter,
                                count: getCount(for: filter),
                                isSelected: selectedFilter == filter,
                                action: {
                                    selectedFilter = filter
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
                
                // Conversations List
                if filteredConversations.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("No Messages")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text(searchText.isEmpty ? "Start a conversation!" : "No results found")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filteredConversations) { conversation in
                                NavigationLink(destination: ChatDetailView(conversation: conversation)) {
                                    ConversationRow(conversation: conversation)
                                }
                                
                                if conversation.id != filteredConversations.last?.id {
                                    Divider()
                                        .padding(.leading, 80)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            
            // Bottom Navigation - INLINE
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.white.opacity(0.95))
                        .frame(height: 85)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1),
                            alignment: .top
                        )
                    
                    HStack {
                        NavigationLink(destination: ContentView().environmentObject(appState)) {
                            VStack(spacing: 4) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                                
                                Text("Home")
                                    .font(.system(size: 10, weight: selectedTab == 0 ? .bold : .medium))
                                    .foregroundColor(selectedTab == 0 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            selectedTab = 0
                        })
                        
                        Spacer()
                        
                        NavigationLink(destination: ScheduleView().environmentObject(appState)) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 1 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                                
                                Text("Schedule")
                                    .font(.system(size: 10, weight: selectedTab == 1 ? .bold : .medium))
                                    .foregroundColor(selectedTab == 1 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            selectedTab = 1
                        })
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 56)
                        
                        Spacer()
                        
                        NavigationLink(destination: MessagesView().environmentObject(appState)) {
                            VStack(spacing: 4) {
                                Image(systemName: "message.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 2 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                                
                                Text("Messages")
                                    .font(.system(size: 10, weight: selectedTab == 2 ? .bold : .medium))
                                    .foregroundColor(selectedTab == 2 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            selectedTab = 2
                        })
                        
                        Spacer()
                        
                        NavigationLink(destination: ProfileView()) {
                            VStack(spacing: 4) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                                
                                Text("Profile")
                                    .font(.system(size: 10, weight: selectedTab == 3 ? .bold : .medium))
                                    .foregroundColor(selectedTab == 3 ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            selectedTab = 3
                        })
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    VStack {
                        NavigationLink(destination: ServiceProvidersListView()) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.6, green: 0.4, blue: 0.9),
                                            Color(red: 0.7, green: 0.5, blue: 0.95)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .shadow(color: Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        .offset(y: -24)
                        
                        Spacer()
                    }
                }
                .frame(height: 85)
            }
        }
        .navigationBarHidden(true)
    }
    
    func getCount(for filter: String) -> Int {
        switch filter {
        case "All":
            return conversations.count
        case "Unread":
            return conversations.filter { $0.isUnread }.count
        case "Service Providers":
            return conversations.filter { $0.userType == .provider }.count
        case "Support":
            return conversations.filter { $0.userType == .support }.count
        default:
            return 0
        }
    }
}

// MARK: - Message Filter Chip (OUTSIDE MessagesView)
struct MessageFilterChip: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white.opacity(0.3) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ?
                Color(red: 0.6, green: 0.4, blue: 0.9) :
                Color.white
            )
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Conversation Row (OUTSIDE MessagesView)
struct ConversationRow: View {
    let conversation: ConversationItem
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: conversation.avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                if conversation.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: 2, y: 2)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(conversation.name)
                        .font(.system(size: 16, weight: conversation.isUnread ? .bold : .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(timeAgo(from: conversation.timestamp))
                        .font(.system(size: 13))
                        .foregroundColor(conversation.isUnread ? Color(red: 0.6, green: 0.4, blue: 0.9) : .gray)
                }
                
                HStack {
                    Text(conversation.lastMessage)
                        .font(.system(size: 14, weight: conversation.isUnread ? .medium : .regular))
                        .foregroundColor(conversation.isUnread ? .black : .gray)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                            .frame(width: 22, height: 22)
                            .overlay(
                                Text("\(conversation.unreadCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(conversation.isUnread ? Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.03) : Color.clear)
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Conversation Model (OUTSIDE MessagesView)
struct ConversationItem: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let timestamp: Date
    let isUnread: Bool
    let unreadCount: Int
    let avatar: String
    let userType: UserType
    let isOnline: Bool
}

enum UserType {
    case provider
    case support
    case petOwner
}

// MARK: - Chat Detail View (OUTSIDE MessagesView)
struct ChatDetailView: View {
    let conversation: ConversationItem
    @Environment(\.dismiss) var dismiss
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    
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
                    
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: conversation.avatar)
                                .foregroundColor(.gray.opacity(0.5))
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(conversation.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(conversation.isOnline ? "Online" : "Offline")
                            .font(.system(size: 12))
                            .foregroundColor(conversation.isOnline ? .green : .gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Call \(conversation.name)")
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
                ScrollView {
                    VStack(spacing: 12) {
                        Text("Today")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .padding(.top, 16)
                        
                        ForEach(messages) { message in
                            ChatMessageBubble(message: message)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                
                // Message Input
                HStack(spacing: 12) {
                    Button(action: {
                        print("Attach file")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                    }
                    
                    HStack {
                        TextField("Type a message...", text: $messageText)
                            .font(.system(size: 16))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    
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
    }
    
    func loadMessages() {
        messages = [
            ChatMessage(text: "Hi there!", isFromMe: true, timestamp: Date()),
            ChatMessage(text: "Hello! How can I help you?", isFromMe: false, timestamp: Date())
        ]
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = ChatMessage(
            text: messageText,
            isFromMe: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(
                text: "Thanks for your message!",
                isFromMe: false,
                timestamp: Date()
            )
            messages.append(response)
        }
    }
}

// MARK: - Chat Message Bubble (OUTSIDE MessagesView - Renamed to avoid conflicts)
struct ChatMessageBubble: View {
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
                
                Text(message.timestamp, style: .time)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromMe {
                Spacer()
            }
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
            .environmentObject(AppState())
    }
}
