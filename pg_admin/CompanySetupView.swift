import SwiftUI
import PhotosUI

struct CompanySetupView: View {
    @State private var companyName = ""
    @State private var companyEmail = ""
    @State private var phoneNumber = ""
    @State private var navigateNext = false

    @State private var isLoading = false
    @State private var errorMessage: String?

    @AppStorage("companyId") private var companyId: Int = 0
    @AppStorage("companyName") private var companyNameStored: String = ""

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var logoImage: Image? = nil
    @State private var logoData: Data? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Logo Preview
                if let image = logoImage {
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .padding(.top)
                } else {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .frame(width: 100, height: 90)
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Select Logo")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Text("Create Your Company")
                    .font(.title)
                    .fontWeight(.bold)

                CustomInputField(title: "Company Name", text: $companyName)

                VStack(alignment: .leading, spacing: 4) {
                    CustomInputField(title: "Email", text: $companyEmail, keyboard: .emailAddress)
                    if !isValidEmail(companyEmail) && !companyEmail.isEmpty {
                        Text("Invalid email format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    CustomInputField(title: "Phone Number", text: $phoneNumber, keyboard: .phonePad)
                    if !isValidPhone(phoneNumber) && !phoneNumber.isEmpty {
                        Text("Invalid phone number")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }

                if isLoading {
                    ProgressView("Creating Company...")
                }

                Spacer()

                NavigationLink(destination: BuildingSetupView(), isActive: $navigateNext) {
                    Text("").hidden()
                }

                Button(action: createCompany) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isLoading)
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Company Setup")
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    logoData = data
                    logoImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    private func createCompany() {
        guard !companyName.isEmpty else {
            errorMessage = "Company name is required."
            return
        }
        guard isValidEmail(companyEmail) else {
            errorMessage = "Please enter a valid email."
            return
        }
        guard isValidPhone(phoneNumber) else {
            errorMessage = "Please enter a valid 10-digit phone number."
            return
        }

        errorMessage = nil
        isLoading = true

        let url = URL(string: "https://pgbackend-production.up.railway.app/companies")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "name": companyName,
            "email": companyEmail,
            "phone": phoneNumber
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "No response from server."
                    return
                }

                if (200...299).contains(httpResponse.statusCode),
                   let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let id = json["id"] as? Int {

                    companyId = id
                    companyNameStored = companyName

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        navigateNext = true
                    }
                } else {
                    errorMessage = "Failed to create company (Code: \(httpResponse.statusCode))."
                }
            }
        }.resume()
    }

    // MARK: - Validation Helpers

    func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    func isValidPhone(_ phone: String) -> Bool {
        let regex = #"^[6-9]\d{9}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)
    }
}

// MARK: - Modern TextField Wrapper
struct CustomInputField: View {
    var title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .keyboardType(keyboard)
    }
}
