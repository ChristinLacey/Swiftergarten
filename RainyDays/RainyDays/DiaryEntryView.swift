import SwiftUI
import CoreData

struct DiaryEntryView: View {
    @State private var entryText = ""
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.sailorCream, Color.sailorBlue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // Date
                Text(dateFormatter.string(from: Date()))
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color.sailorPink)
                    .padding()

                // Text editor
                TextEditor(text: $entryText)
                    .frame(height: 200)
                    .padding()
                    .background(Color.sailorCream.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    .shadow(radius: 3)

                // Save button
                Button("Save") {
                    saveEntry()
                    dismiss()
                }
                .font(.system(.body, design: .rounded))
                .padding()
                .background(Color.sailorBlue)
                .foregroundColor(Color.sailorCream)
                .clipShape(Capsule())
                .shadow(radius: 3)
            }
            .padding()
        }
    }

    private func saveEntry() {
        let newEntry = DiaryEntry(context: viewContext)
        newEntry.date = Date()
        newEntry.text = entryText

        do {
            try viewContext.save()
        } catch {
            print("Failed to save entry: \(error)")
        }
    }
}

#Preview {
    DiaryEntryView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
