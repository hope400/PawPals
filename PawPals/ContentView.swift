//
//  ContentView.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.

import SwiftUI

struct ContentView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        if appState.isLoggedIn {
            
            homeView
        } else {
           
            NavigationStack {
                ZStack {
                    // Background color
                    Color(red: 0.93, green: 0.93, blue: 0.98)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Skip button at top right
                        HStack {
                            Spacer()
                            Button(action: {
                                print("Skip tapped")
                            }) {
                                Text("Skip")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                            .padding(.trailing, 24)
                            .padding(.top, 16)
                        }
                        
                        Spacer().frame(height: 60)
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.95, green: 0.88, blue: 0.73))
                                .frame(width: 320, height: 320)
                            
                            Circle()
                                .fill(Color(red: 0.98, green: 0.96, blue: 0.91))
                                .frame(width: 280, height: 280)
                            
                            Image("dog-welcome")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                        
                        Spacer().frame(height: 50)
                        
                        // Welcome text
                        VStack(spacing: 8) {
                            Text("Welcome to")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("PawPals")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        }
                        
                        Spacer().frame(height: 24)
                        
                        Text("The happiest place for your furry\nbest friends to find their local\nsoulmate sitters.")
                            .font(.system(size: 17))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        
                        Spacer().frame(height: 40)
                        
                        // Page indicators
                        HStack(spacing: 12) {
                            Capsule()
                                .fill(Color(red: 0.6, green: 0.4, blue: 0.9))
                                .frame(width: 32, height: 8)
                            ForEach(0..<4) { _ in
                                Circle()
                                    .fill(Color(red: 0.8, green: 0.8, blue: 0.85))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
                        Spacer()
                        
                        // Get Started button
                        NavigationLink(destination: RoleSelectionView().environmentObject(appState)) {
                            HStack(spacing: 12) {
                                Text("Get Started")
                                    .font(.system(size: 20, weight: .semibold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
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
                            .cornerRadius(30)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer().frame(height: 24)
                        
                        // Already have an account
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            
                            NavigationLink(destination: LoginView(appState: appState)) {
                                Text("Log In")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    //Show the correct home based on user role
    @ViewBuilder
    var homeView: some View {
        switch appState.selectedRole {
        case .petOwner:
            PetOwnerHomeView()
                .environmentObject(appState)
        case .serviceProvider:
            ServiceProviderHomeView()
                .environmentObject(appState)
        case .businessClient:
            BusinessClientHomeView()
                .environmentObject(appState)
        case .none:
            PetOwnerHomeView()
                .environmentObject(appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
