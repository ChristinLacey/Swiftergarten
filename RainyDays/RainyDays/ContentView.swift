import SwiftUI
import CoreData
import CryptoKit

struct DiaryDay: Identifiable {
    let id: UUID
    let date: Date
    let entries: [DiaryEntry]

    init(date: Date, entries: [DiaryEntry]) {
        self.date = date
        self.entries = entries
        self.id = date.deterministicUUID()
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DiaryEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<DiaryEntry>
    
    @State private var selectedDayID: UUID? = nil

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    private var diaryDays: [DiaryDay] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.date ?? Date())
        }

        // Add today if not already present
        let today = calendar.startOfDay(for: Date())
        var result = grouped.map { date, entries in
            DiaryDay(date: date, entries: entries.sorted { $0.date ?? Date() > $1.date ?? Date() })
        }

        if !result.contains(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            result.append(DiaryDay(date: today, entries: []))
        }

        return result.sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.sailorCream, Color.sailorBlue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Text("Rainy Days")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.sailorPink)
                        .padding(.top, 20)

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

                    GeometryReader { geometry in
                        if diaryDays.isEmpty {
                            Text("No entries yet! Write one to start.")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color.sailorLavender)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            TabView(selection: $selectedDayID) {
                                ForEach(diaryDays) { day in
                                    ScrollView {
                                        VStack(spacing: 10) {
                                            Text(dateFormatter.string(from: day.date))
                                                .font(.system(.title2, design: .rounded))
                                                .foregroundColor(Color.sailorPink)
                                                .padding(.top)
                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            if day.entries.isEmpty {
                                                Text("No entries yet for this day.")
                                                    .font(.system(.body, design: .rounded))
                                                    .foregroundColor(Color.sailorLavender)
                                                    .padding(.top)
                                            }

                                            ForEach(day.entries) { entry in
                                                VStack(alignment: .leading, spacing: 10) {
                                                    Text(timeFormatter.string(from: entry.date ?? Date()))
                                                        .font(.system(.headline, design: .rounded))
                                                        .foregroundColor(Color.sailorPink)
                                                    Text(entry.text ?? "")
                                                        .font(.system(.body, design: .rounded))
                                                        .foregroundColor(Color.sailorLavender)
                                                        .lineLimit(nil)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .padding()
                                                .background(Color.sailorCream.opacity(0.8))
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                                .frame(minWidth: geometry.size.width - 40)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 20)
                                    }
                                    .frame(maxHeight: .infinity)
                                    .tag(day.id)
                                }
                            }
                            .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                            .onAppear {
                                let todayID = Date().deterministicUUID()
                                DispatchQueue.main.async {
                                    selectedDayID = todayID
                                }
                            }
                        }
                    }
                }

                NavigationLink {
                    WardrobeView()
                } label: {
                    Image("default_chibi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .shadow(radius: 5)
                }
                .position(x: UIScreen.main.bounds.width - 120, y: UIScreen.main.bounds.height - 180)
            }
        }
    }
}

extension Date {
    // Deterministic UUID based on yyyy-MM-dd hash (MD5, first 16 bytes); enables most-to-least recent entries
    func deterministicUUID() -> UUID {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self)
        let hash = Insecure.MD5.hash(data: Data(dateString.utf8))
        let bytes = Array(hash.prefix(16))
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5],
            bytes[6], bytes[7],
            bytes[8], bytes[9],
            bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
