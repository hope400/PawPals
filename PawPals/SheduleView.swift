//
//  SheduleView.swift
//  PawPals
//
//  Created by user286283 on 2/5/26.
//

import SwiftUI

struct ScheduleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: String = "All"
    @State private var selectedDate: Date = Date()
    
    let filterOptions = ["All", "Upcoming", "Past", "Cancelled"]
    
    @State private var appointments: [Appointment] = [
        Appointment(
            serviceName: "Dog Walking",
            petName: "Buddy",
            providerName: "James Rodriguez",
            date: Date(),
            time: "2:00 PM",
            duration: "1 hour",
            status: .upcoming,
            price: 25.00,
            location: "Central Park",
            icon: "figure.walk",
            color: .green
        ),
        Appointment(
            serviceName: "Pet Sitting",
            petName: "Luna",
            providerName: "Sarah Mitchell",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            time: "10:00 AM",
            duration: "4 hours",
            status: .upcoming,
            price: 45.00,
            location: "Your Home",
            icon: "house.fill",
            color: .purple
        ),
        Appointment(
            serviceName: "Grooming",
            petName: "Buddy",
            providerName: "Michael Chen",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            time: "3:30 PM",
            duration: "2 hours",
            status: .upcoming,
            price: 60.00,
            location: "Pet Spa Downtown",
            icon: "scissors",
            color: .pink
        ),
        Appointment(
            serviceName: "Vet Visit",
            petName: "Max",
            providerName: "Dr. Emily Watson",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            time: "11:00 AM",
            duration: "30 min",
            status: .upcoming,
            price: 75.00,
            location: "Healthy Paws Clinic",
            icon: "cross.case.fill",
            color: .red
        ),
        Appointment(
            serviceName: "Dog Walking",
            petName: "Buddy",
            providerName: "James Rodriguez",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            time: "2:00 PM",
            duration: "1 hour",
            status: .completed,
            price: 25.00,
            location: "Central Park",
            icon: "figure.walk",
            color: .green
        ),
        Appointment(
            serviceName: "Training Session",
            petName: "Luna",
            providerName: "David Park",
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            time: "4:00 PM",
            duration: "1 hour",
            status: .completed,
            price: 50.00,
            location: "Dog Park",
            icon: "person.fill.checkmark",
            color: .blue
        )
    ]
    
    var filteredAppointments: [Appointment] {
        appointments.filter { appointment in
            switch selectedFilter {
            case "Upcoming":
                return appointment.status == .upcoming
            case "Past":
                return appointment.status == .completed
            case "Cancelled":
                return appointment.status == .cancelled
            default:
                return true
            }
        }.sorted { $0.date > $1.date }
    }
    
    var groupedAppointments: [String: [Appointment]] {
        Dictionary(grouping: filteredAppointments) { appointment in
            if Calendar.current.isDateInToday(appointment.date) {
                return "Today"
            } else if Calendar.current.isDateInTomorrow(appointment.date) {
                return "Tomorrow"
            } else if appointment.date > Date() {
                return "Upcoming"
            } else {
                return "Past"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Text("Schedule")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Calendar view")
                    }) {
                        Circle()
                            .fill(Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.1))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                                    .font(.system(size: 20))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .background(Color(red: 0.97, green: 0.96, blue: 0.97))
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            FilterButton(
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
                
                // Summary Stats
                HStack(spacing: 12) {
                    SummaryCard(
                        title: "Upcoming",
                        count: appointments.filter { $0.status == .upcoming }.count,
                        icon: "calendar.badge.clock",
                        color: Color(red: 0.6, green: 0.4, blue: 0.9)
                    )
                    
                    SummaryCard(
                        title: "Completed",
                        count: appointments.filter { $0.status == .completed }.count,
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                // Appointments List
                if filteredAppointments.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text("No \(selectedFilter) Appointments")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text("Your schedule is clear!")
                            .font(.system(size: 15))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(groupedAppointments.keys.sorted(), id: \.self) { section in
                                if let appointments = groupedAppointments[section] {
                                    VStack(alignment: .leading, spacing: 12) {
                                        // Section Header
                                        HStack {
                                            Text(section)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.black)
                                            
                                            Text("\(appointments.count)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                                                .cornerRadius(12)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        
                                        // Appointments
                                        ForEach(appointments) { appointment in
                                            NavigationLink(destination: BookingDetailsView()) {
                                                ScheduleAppointmentCard(appointment: appointment)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                                .frame(height: 100)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            
            // Bottom Navigation
            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: .constant(2))
            }
        }
        .navigationBarHidden(true)
    }
    
    func getCount(for filter: String) -> Int {
        switch filter {
        case "All":
            return appointments.count
        case "Upcoming":
            return appointments.filter { $0.status == .upcoming }.count
        case "Past":
            return appointments.filter { $0.status == .completed }.count
        case "Cancelled":
            return appointments.filter { $0.status == .cancelled }.count
        default:
            return 0
        }
    }
}

// MARK: - Filter Button
struct FilterButton: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                
                Text("\(count)")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.3) : Color.gray.opacity(0.2))
                    .cornerRadius(8)
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

// MARK: - Summary Card
struct SummaryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Schedule Appointment Card
struct ScheduleAppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(appointment.color.opacity(0.1))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: appointment.icon)
                        .foregroundColor(appointment.color)
                        .font(.system(size: 24))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(appointment.serviceName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    StatusBadge(status: appointment.status)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 11))
                    Text(appointment.petName)
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                
                HStack(spacing: 16) {
                    // Date
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text(appointment.date, style: .date)
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.gray)
                    
                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(appointment.time)
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.gray)
                    
                    // Price
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 11))
                        Text("$\(String(format: "%.0f", appointment.price))")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.gray)
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.3))
                .font(.system(size: 14))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: AppointmentStatus
    
    var statusColor: Color {
        switch status {
        case .upcoming: return .blue
        case .completed: return .green
        case .cancelled: return .red
        case .inProgress: return .orange
        }
    }
    
    var statusText: String {
        switch status {
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .inProgress: return "In Progress"
        }
    }
    
    var body: some View {
        Text(statusText)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .cornerRadius(6)
    }
}

// MARK: - Appointment Model
struct Appointment: Identifiable {
    let id = UUID()
    let serviceName: String
    let petName: String
    let providerName: String
    let date: Date
    let time: String
    let duration: String
    let status: AppointmentStatus
    let price: Double
    let location: String
    let icon: String
    let color: Color
}

enum AppointmentStatus {
    case upcoming
    case completed
    case cancelled
    case inProgress
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
