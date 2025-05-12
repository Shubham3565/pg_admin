//
//  WelcomeView.swift
//  pg_admin
//
//  Created by Shubham on 11/05/25.
//


import SwiftUI

struct WelcomeView: View {
    @State private var navigateNext = false

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()

                Image(systemName: "building.2.crop.circle")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)

                Text("Welcome to StayMate Admin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Manage your PG buildings, rooms, tenants, and staff—all in one place.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                NavigationLink(destination: CompanySetupView(), isActive: $navigateNext) {
                    EmptyView()
                }

                Button(action: {
                    navigateNext = true
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer().frame(height: 30)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
