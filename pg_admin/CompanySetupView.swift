//
//  CompanySetupView.swift
//  pg_admin
//
//  Created by Shubham on 11/05/25.
//


import SwiftUI

struct CompanySetupView: View {
    @State private var companyName = ""
    @State private var companyEmail = ""
    @State private var phoneNumber = ""
    @State private var navigateNext = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Your Company")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            TextField("Company Name", text: $companyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $companyEmail)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()

            NavigationLink(destination: BuildingSetupView(), isActive: $navigateNext) {
                EmptyView()
            }

            Button(action: {
                // Validate if needed
                navigateNext = true
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.bottom)

        }
        .padding()
        .navigationTitle("Company Setup")
    }
}

#Preview {
    NavigationView {
        CompanySetupView()
    }
}
