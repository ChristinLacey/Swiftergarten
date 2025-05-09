import SwiftUI

struct ContentView: View {
    @State private var savedEntry = "" // Stores the saved diary entry

    var body: some View {
        NavigationStack {
            VStack {
                Text("Rainy Days")
                    .font(.largeTitle)
                    .padding()

                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()

                NavigationLink {
                    DiaryEntryView(savedEntry: $savedEntry) // Pass the binding
                } label: {
                    Text("Write Today’s Entry")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                if !savedEntry.isEmpty {
                    Text("Latest Entry: \(savedEntry)")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
