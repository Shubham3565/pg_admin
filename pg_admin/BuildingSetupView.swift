import SwiftUI

struct BuildingSetupView: View {
    @State private var buildingName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var navigateNext = false

    @State private var isLoading = false
    @State private var errorMessage: String?

    @AppStorage("companyId") var companyId: Int = 0
    @AppStorage("companyName") var companyName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Company Name Header
            Text(companyName)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top)

            Text("Add Your PG Building")
                .font(.title)
                .fontWeight(.bold)

            TextField("Building Name", text: $buildingName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("City", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }

            if isLoading {
                ProgressView("Creating Building...")
            }

            Spacer()

            NavigationLink(destination: RoomSetupView(), isActive: $navigateNext) {
                Text("").hidden()
            }

            Button(action: createBuilding) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(isLoading || companyId == 0)
            .padding(.bottom)
        }
        .padding()
        .navigationTitle("Building Setup")
    }

    private func createBuilding() {
        guard !buildingName.isEmpty else {
            errorMessage = "Building name is required."
            return
        }

        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://pgbackend-production.up.railway.app/buildings")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "name": buildingName,
            "address": address,
            "city": city,
            "companyId": companyId
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "No response from server."
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        navigateNext = true
                    }
                } else {
                    errorMessage = "Failed to create building (Code: \(httpResponse.statusCode))."
                }
            }
        }.resume()
    }
}
