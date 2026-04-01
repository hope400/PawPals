//
//  Pet.swift
//  PawPals
//
//  Created by user286283 on 3/24/26.
//

import Foundation

struct Pet: Identifiable {
    var id: UUID
    var name: String
    var image: String?              // Local asset name (optional)
    var isActive: Bool              // For UI state
    var species: String             // "Dog", "Cat", "Bird", etc.
    var breed: String
    var birthday: String            // Date as string (MM/DD/YYYY)
    var gender: String              // "Male" or "Female"
    var imageURL: String?           // Firebase Storage URL (optional)
    
    // Medical/Health Properties
    var isSterilized: Bool          // Sterilization status
    var isMicrochipped: Bool        // Microchip status
    var isVaccinated: Bool          // Vaccination status
    
    // Additional Properties
    var temperament: String         // "Friendly", "Shy", "Aggressive", etc.
    
    init(
        id: UUID = UUID(),
        name: String,
        image: String? = nil,
        isActive: Bool = true,
        species: String,
        breed: String,
        birthday: String,
        gender: String,
        imageURL: String? = nil,
        isSterilized: Bool = false,
        isMicrochipped: Bool = false,
        isVaccinated: Bool = false,
        temperament: String = ""
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.isActive = isActive
        self.species = species
        self.breed = breed
        self.birthday = birthday
        self.gender = gender
        self.imageURL = imageURL
        self.isSterilized = isSterilized
        self.isMicrochipped = isMicrochipped
        self.isVaccinated = isVaccinated
        self.temperament = temperament
    }
}
