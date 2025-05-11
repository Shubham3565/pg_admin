//
//  BuildingSetupView.swift
//  pg_admin
//
//  Created by Shubham on 11/05/25.
//


import SwiftUI

struct BuildingSetupView: View {
    @State private var buildingName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var navigateNext = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Your PG Building")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            TextField("Building Name", text: $buildingName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("City", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()

            NavigationLink(destination: RoomSetupView(), isActive: $navigateNext) {
                EmptyView()
            }

            Button(action: {
                // Validation logic can be added
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
        .navigationTitle("Building Setup")
    }
}

#Preview {
    NavigationView {
        BuildingSetupView()
    }
}
