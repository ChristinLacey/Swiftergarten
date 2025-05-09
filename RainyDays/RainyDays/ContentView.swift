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
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.sailorCream, Color.sailorBlue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    // Title
                    Text("Rainy Days")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.sailorPink)
                        .padding(.top, 20)

                    // Write button
                    NavigationLink {
                        DiaryEntryView()
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        Text("Write Today’s Entry")
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .background(Color.sailorBlue)
                            .foregroundColor(Color.sailorCream)
                            .clipShape(Capsule())
                            .shadow(radius: 3)
                    }
                    .padding(.bottom)

                    // Entry list
                    List {
                        ForEach(entries) { entry in
                            VStack(alignment: .leading) {
                                Text(dateFormatter.string(from: entry.date!))
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(Color.sailorPink)
                                Text(entry.text!)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(Color.sailorLavender)
                            }
                            .padding()
                            .background(Color.sailorCream.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.vertical, 2)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }

                // Avatar (bottom-right)
                NavigationLink {
                    WardrobeView()
                } label: {
                    Image("default_chibi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 5)
                }
                .position(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 180)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
