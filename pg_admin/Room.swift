import SwiftUI

struct Room: Identifiable {
    let id = UUID()
    var number: String
    var floor: String
    var capacity: String
}

struct RoomSetupView: View {
    @State private var manualRooms: [Room] = []
    @State private var isManualMode = false
    @State private var navigateNext = false

    // Auto mode variables
    @State private var numberOfFloors = 1
    @State private var roomsPerFloor = 1

    var totalRooms: Int {
        numberOfFloors * roomsPerFloor
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Room Setup")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Picker("Setup Mode", selection: $isManualMode) {
                Text("Auto Generate").tag(false)
                Text("Manual Entry").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())

            if isManualMode {
                ForEach(manualRooms.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        HStack {
                            TextField("Room No.", text: $manualRooms[index].number)
                            TextField("Floor", text: $manualRooms[index].floor)
                            TextField("Capacity", text: $manualRooms[index].capacity)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                Button("Add Room") {
                    manualRooms.append(Room(number: "", floor: "", capacity: "1"))
                }
                .padding(.top, 5)

            } else {
                VStack(spacing: 12) {
                    Stepper(value: $numberOfFloors, in: 1...20) {
                        Text("Number of Floors: \(numberOfFloors)")
                    }

                    Stepper(value: $roomsPerFloor, in: 1...20) {
                        Text("Rooms per Floor: \(roomsPerFloor)")
                    }

                    Text("Total Rooms to be generated: \(totalRooms)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
            }

            Spacer()

            NavigationLink(destination: OnboardingSuccessView(), isActive: $navigateNext) {
                EmptyView()
            }

            Button(action: {
                // Future logic: generate room list from floor × count
                navigateNext = true
            }) {
                Text("Finish Setup")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.bottom)
        }
        .padding()
        .navigationTitle("Room Setup")
    }
}

#Preview {
    NavigationView {
        RoomSetupView()
    }
}
