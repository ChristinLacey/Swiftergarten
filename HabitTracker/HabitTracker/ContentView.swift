//
//  ContentView.swift
//  HabitTracker
//
//  Created by Christin Lacey on 5/25/25.
//

import SwiftUI

struct Habit: Identifiable, Codable, Hashable {
    var id = UUID()
    var habitName = ""
    var habitDescription = ""
}

@Observable
class Habits {
    var habits = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    init() {
        if let savedHabits = UserDefaults.standard.data(forKey: "Habits") {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
                habits = decodedHabits
                return
            }
        }
        habits = []
    }
}

struct ContentView: View {
    @State private var showingSheet = false
    @State private var habits = Habits()
    @State private var inputHabit = ""
    @State private var inputDesc = ""
    
    var body: some View {
        let exampleHabit = Habit(habitName: "Test Habit", habitDescription: "Test Description")

        NavigationStack {
            List(habits.habits) { habit in
                NavigationLink(value: habit) {
                    Text(habit.habitName)
                }
                }
                .navigationTitle("Good Habits")
                .navigationDestination(for: Habit.self) { selected in
                    Text("\(selected.habitName):\n \(selected.habitDescription)")}
                .toolbar {
                    Button("+") {
                        showingSheet = true
                    }
                    .sheet(isPresented: $showingSheet) {
                        NavigationStack {
                            Form {
                                TextField("Habit Name", text: $inputHabit)
                                TextField("Description", text: $inputDesc)
                            }
                            .navigationTitle("New habit")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Save") {
                                        let newHabit = Habit(habitName: inputHabit, habitDescription: inputDesc)
                                        habits.habits.append(newHabit)
                                        inputHabit = ""
                                        inputDesc = ""
                                        showingSheet = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        .onAppear {
            if habits.habits.isEmpty {
                habits.habits.append(exampleHabit)
            }
        }
        }
    }


#Preview {
    ContentView()
}
