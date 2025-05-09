import SwiftUI

struct WardrobeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedHair = "HairBrown" // Default hair

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.sailorCream, Color.sailorBlue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Text("Wardrobe")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(Color.sailorPink)
                    .padding()

                // Avatar preview
                ZStack {
                    Image("ChibiBody") // Body (skin, eyes)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Image(selectedHair) // Selected hair
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Image("DressPink") // Default dress
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }

                // Hair color picker
                HStack {
                    Button("Brown") {
                        selectedHair = "HairBrown"
                    }
                    .padding()
                    .background(Color.sailorBlue)
                    .foregroundColor(Color.sailorCream)
                    .clipShape(Capsule())

                    Button("Pink") {
                        selectedHair = "HairPink"
                    }
                    .padding()
                    .background(Color.sailorBlue)
                    .foregroundColor(Color.sailorCream)
                    .clipShape(Capsule())

                    Button("Lavender") {
                        selectedHair = "HairLavender"
                    }
                    .padding()
                    .background(Color.sailorBlue)
                    .foregroundColor(Color.sailorCream)
                    .clipShape(Capsule())
                }
                .padding()

                Button("Back") {
                    dismiss()
                }
                .font(.system(.body, design: .rounded))
                .padding()
                .background(Color.sailorBlue)
                .foregroundColor(Color.sailorCream)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    WardrobeView()
}
