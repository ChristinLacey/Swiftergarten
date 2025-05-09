import SwiftUI

struct DiaryEntryView: View {
    @State private var entryText = ""
    @Binding var savedEntry: String // Binding to update ContentView’s savedEntry
    @Environment(\.dismiss) private var dismiss // To go back to the main screen

    var body: some View {
        VStack {
            Text("Today’s Diary")
                .font(.title)
                .padding()

            TextEditor(text: $entryText)
                .frame(height: 200)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

            Button("Save") {
                savedEntry = entryText // Save the text
                dismiss() // Go back to the main screen
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    DiaryEntryView(savedEntry: .constant(""))
}
