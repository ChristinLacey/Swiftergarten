import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DiaryEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<DiaryEntry>

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

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
                    DiaryEntryView()
                        .environment(\.managedObjectContext, viewContext)
                } label: {
                    Text("Write Today’s Entry")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }

            List {
                ForEach(entries) { entry in
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: entry.date!))
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(entry.text!)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
