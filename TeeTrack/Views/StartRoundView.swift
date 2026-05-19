//
//  StartRoundView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 15/04/2025.
//

import SwiftUI

struct StartRoundView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel

    @State private var selectedCourse: GolfCourse? = nil
    @State private var courses: [GolfCourse] = []
    
    @State private var showScorecard = false
    


    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                BackTopBarView(title: "Start Round") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if courses.isEmpty {
                            VStack(spacing: 12) {
                                Text("No Golf Courses Available")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryGreen)

                                Text("Go to Courses to add a new golf course first.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                        } else {
                            Text("Select a Golf Course")
                                .font(.title2)
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal)
                                .padding(.top,40)
                            Spacer()
                            VStack(spacing: 12) {
                                ForEach(courses) { course in
                                    Button(action: {
                                        if selectedCourse?.id == course.id {
                                            selectedCourse = nil // Unselect if already selected
                                        } else {
                                            selectedCourse = course // Select new one
                                        }
                                    }) {

                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(course.name)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primaryGreen)
                                                Text(course.location)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            if selectedCourse?.id == course.id {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.primaryGreen)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                    .padding(.horizontal)
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                }

                if !courses.isEmpty {
                    Button(action: {
                        showScorecard = true
                    }) {
                        Text("Start Scorecard")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedCourse == nil ? Color.gray.opacity(0.5) : Color.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding()
                    }
                    .disabled(selectedCourse == nil)

                    // ✅ Insert NavigationLink HERE:
                    NavigationLink(
                        destination: selectedCourse.map { ScorecardView(course: $0) },
                        isActive: $showScorecard
                    ) {
                        EmptyView()
                    }
                    .hidden()

                }

            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadCourses()
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
}
