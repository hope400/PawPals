//
//  ChatMessage.swift
//  PawPals
//
//  Created by Claude on 3/24/26.
//

import Foundation

struct ChatMessage: Identifiable {
    var id: String = UUID().uuidString
    var text: String
    var isFromMe: Bool
    var timestamp: Date
    var senderId: String?
    var senderName: String?
    
    init(id: String = UUID().uuidString, text: String, isFromMe: Bool, timestamp: Date = Date(), senderId: String? = nil, senderName: String? = nil) {
        self.id = id
        self.text = text
        self.isFromMe = isFromMe
        self.timestamp = timestamp
        self.senderId = senderId
        self.senderName = senderName
    }
}
