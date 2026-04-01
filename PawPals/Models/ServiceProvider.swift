//
//  ServiceProvider.swift
//  PawPals
//
//  Created by user286283 on 3/24/26.
//

import Foundation

struct ServiceProvider: Identifiable {
    var id: String
    var name: String
    var service: [String]              // ✅ FIXED: Array of services
    var rating: Double
    var hourlyRate: Double
    var phone: String
    var email: String
    var bio: String
    var experience: String
    var availability: String
    var imageURL: String?
    var reviewCount: Int
    var completedJobs: Int
    var memberSince: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        service: [String],             // ✅ Array parameter
        rating: Double = 0.0,
        hourlyRate: Double = 0.0,
        phone: String = "",
        email: String = "",
        bio: String = "",
        experience: String = "",
        availability: String = "Available",
        imageURL: String? = nil,
        reviewCount: Int = 0,
        completedJobs: Int = 0,
        memberSince: String = ""
    ) {
        self.id = id
        self.name = name
        self.service = service
        self.rating = rating
        self.hourlyRate = hourlyRate
        self.phone = phone
        self.email = email
        self.bio = bio
        self.experience = experience
        self.availability = availability
        self.imageURL = imageURL
        self.reviewCount = reviewCount
        self.completedJobs = completedJobs
        self.memberSince = memberSince
    }
}
