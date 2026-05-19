//
//  StatsView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI


struct StatsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel

    enum RoundFilter: String, CaseIterable {
        case last5 = "5 Lasts"
        case last10 = "10 Lasts"
        case all = "All"
    }
    
    @State private var roundToDelete: StoredGolfRound? = nil
    @State private var showDeleteConfirmation: Bool = false


    @State private var selectedFilter: RoundFilter = .last5
    @State private var rounds: [StoredGolfRound] = []
    @State private var courses: [GolfCourse] = []
   
    
    

    var filteredRounds: [StoredGolfRound] {
        let sorted = rounds.sorted(by: { $0.date < $1.date })

        switch selectedFilter {
        case .last5:
            return Array(sorted.suffix(5))
        case .last10:
            return Array(sorted.suffix(10))
        case .all:
            return sorted
        }
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                BackTopBarView(title: "Stats") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        if filteredRounds.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)

                                Text("No rounds found")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            // MARK: Chart Title
                            Text("Score Over Time")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                                .padding(.top, 24)
                                .padding(.horizontal)

                            // MARK: Chart
                            ScoreLineChart(rounds: filteredRounds)

                            // MARK: Filter Buttons
                            HStack(spacing: 12) {
                                ForEach(RoundFilter.allCases, id: \.self) { filter in
                                    Button(action: {
                                        selectedFilter = filter
                                    }) {
                                        Text(filter.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(selectedFilter == filter ? .white : .primary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(selectedFilter == filter ? Color.primaryGreen : Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity)
                        }


                        // MARK: Divider
                        Divider().padding(.horizontal)

                        // MARK: History List
                        VStack(alignment: .leading, spacing: 16) {
                            Text("📖 Round History")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal)

                            ForEach(filteredRounds.reversed(), id: \.id) { round in
                                if let course = courses.first(where: { $0.id == round.courseID }) {
                                    NavigationLink(destination: RoundDetailView(round: round,course: course)) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text(round.courseName)
                                                        .font(.headline)
                                                        .foregroundColor(.primaryGreen)
                                                    
                                                    HStack {
                                                        Text(formattedDate(round.date))
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                        
                                                        Spacer()
                                                        
                                                        Text("\(round.holeScores.count) Holes")
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                    
                                                    Text("Total: \(round.totalScore)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    roundToDelete = round
                                                    showDeleteConfirmation = true
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                        .padding(8)
                                                }
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.06))
                                        .cornerRadius(14)
                                        .padding(.horizontal)
                                    }
                                } else {
                                    // Fallback: still show basic round info
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(round.courseName)
                                            .font(.headline)
                                            .foregroundColor(.red)

                                        Text("⚠️ Course data missing")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.06))
                                    .cornerRadius(14)
                                    .padding(.horizontal)
                                }
                            }

                        }
                        



                        // MARK: Divider
                        
                        Divider().padding(.horizontal)

                        // MARK: Best Round
                        if let bestRound = rounds.max(by: { $0.totalScore < $1.totalScore }),
                           let bestCourse = courses.first(where: { $0.id == bestRound.courseID }) {

                            VStack(alignment: .leading, spacing: 8) {
                                Text("🏆 Best Round")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryGreen)
                                    .padding(.horizontal)

                                NavigationLink(destination: RoundDetailView(round: bestRound, course: bestCourse)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(bestRound.courseName)
                                                    .font(.headline)
                                                    .foregroundColor(.primaryGreen)
                                                
                                                Text(formattedDate(bestRound.date))
                                                    .font(.caption)
                                                    .foregroundColor(.gray)

                                                Text("Total: \(bestRound.totalScore)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }

                                            Spacer()

                                            Text("👏")
                                                .font(.largeTitle)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.yellow, lineWidth: 2)
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }

                        // MARK: Divider
                        Divider().padding(.horizontal)

                        // MARK: Summary Stats
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📊 Summary")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal)

                            Group {
                                // Total Rounds
                                HStack {
                                    Text("Total Rounds Played:")
                                        .foregroundColor(.primaryGreen)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(rounds.count)")
                                        .foregroundColor(.gray)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }

                                // Average Net Score
                                HStack {
                                    Text("Average Net Score:")
                                        .foregroundColor(.primaryGreen)
                                        .font(.headline)
                                    Spacer()
                                    let avg = rounds.map { $0.totalScore }.reduce(0, +) / max(rounds.count, 1)
                                    Text("\(avg)")
                                        .foregroundColor(.gray)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }

                                // Average Putts per Hole
                                HStack {
                                    Text("Avg Putts per Hole:")
                                        .foregroundColor(.primaryGreen)
                                        .font(.headline)
                                    Spacer()
                                    let allPutts = rounds.flatMap { $0.holeScores.compactMap { Int($0.putts) } }
                                    if allPutts.isEmpty {
                                        Text("Not enough data")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    } else {
                                        let avgPutts = Double(allPutts.reduce(0, +)) / Double(allPutts.count)
                                        Text(String(format: "%.1f", avgPutts))
                                            .foregroundColor(.gray)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                }

                                // Average Greens per Hole
                                HStack {
                                    Text("Avg Hits to Green:")
                                        .foregroundColor(.primaryGreen)
                                        .font(.headline)
                                    Spacer()
                                    let allGreens = rounds.flatMap { $0.holeScores.compactMap { Int($0.hitsToGreen) } }
                                    if allGreens.isEmpty {
                                        Text("Not enough data")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    } else {
                                        let avgGreens = Double(allGreens.reduce(0, +)) / Double(allGreens.count)
                                        Text(String(format: "%.1f", avgGreens))
                                            .foregroundColor(.gray)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .padding(.bottom, 40)



                        Spacer(minLength: 60)
                    }
                    .padding(.top, 12)
                }

            }
        }
        .navigationBarHidden(true)
        .onAppear{
            loadRounds()
            loadCourses()
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete This Round?"),
                message: Text("This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let round = roundToDelete {
                        deleteRound(round)
                    }
                },
                secondaryButton: .cancel()
            )
        }

    }

    func loadRounds() {
        guard let email = authVM.currentUser?.email else { return }
        let key = "rounds_\(email)"

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([StoredGolfRound].self, from: data) {
            rounds = decoded
        }
    }
    func loadCourses() {
        guard let email = authVM.currentUser?.email else { return }
        let key = "courses_\(email)"

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([GolfCourse].self, from: data) {
            courses = decoded
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func deleteRound(_ round: StoredGolfRound) {
        guard let email = authVM.currentUser?.email else { return }
        let key = "rounds_\(email)"

        if let data = UserDefaults.standard.data(forKey: key),
           var decoded = try? JSONDecoder().decode([StoredGolfRound].self, from: data) {
            decoded.removeAll(where: { $0.id == round.id })

            if let updated = try? JSONEncoder().encode(decoded) {
                UserDefaults.standard.set(updated, forKey: key)
            }

            loadRounds()
        }
    }
    


}
