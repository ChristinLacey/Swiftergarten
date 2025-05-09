import SwiftUI
import CoreData

struct DiaryEntryView: View {
    @State private var entryText = ""
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // e.g., "May 8, 2025"
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        VStack {
            Text(dateFormatter.string(from: Date()))
                .font(.title2)
                .padding()

            TextEditor(text: $entryText)
                .frame(height: 200)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

            Button("Save") {
                saveEntry()
                dismiss()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
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
