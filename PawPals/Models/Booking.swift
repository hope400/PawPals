
//
//  Booking.swift
//  PawPals
//
//  Created by user286283 on 3/24/26.
//

import Foundation

struct Booking: Identifiable {
    var id: String
    var petOwnerId: String
    var petName: String
    var petOwnerName: String
    var serviceProviderId: String
    var serviceProviderName: String
    var serviceProviderPhone: String

    var serviceName: String
    var date: String
    var time: String
    var status: String              // ✅ SIMPLE: Just a String - "pending", "confirmed", "completed", "cancelled"
    var notes: String
    var totalPrice: Double
    
    init(
        id: String = UUID().uuidString,
        petOwnerId: String,
        petName: String,
        petOwnerName: String,
        serviceProviderId: String,
        serviceProviderName: String,
        serviceProviderPhone: String,
        serviceName: String,
        date: String,
        time: String,
        status: String = "pending",
        notes: String = "",
        totalPrice: Double
    ) {
        self.id = id
        self.petOwnerId = petOwnerId
        self.petOwnerName = petOwnerName
        self.serviceProviderId = serviceProviderId
        self.serviceProviderName = serviceProviderName
        self.serviceProviderPhone = serviceProviderPhone
        self.serviceName = serviceName
        self.date = date
        self.time = time
        self.status = status
        self.notes = notes
        self.totalPrice = totalPrice
        self.petName = petName
    }
}
