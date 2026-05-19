//
//  CoursesView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 11/04/2025.
//

import SwiftUI

struct CoursesView: View {
    
    @State private var showMenu = false
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var showAddCourse = false
    @State private var courses: [GolfCourse] = []
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    TopBarView(title: "Courses") {
                        withAnimation { showMenu = true }
                    }

                    Text("Saved Golf Courses")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.top, 8)
                        .foregroundColor(.primaryGreen)

                    if courses.isEmpty {
                        Spacer()
                        Text("No courses saved yet.")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(courses) { course in
                                    NavigationLink(
                                        destination: CourseDetailView(
                                            course: course,
                                            onDelete: { id in
                                                if let index = courses.firstIndex(where: { $0.id == id }) {
                                                    courses.remove(at: index)
                                                    saveCourses()
                                                }
                                            }
                                        )
                                    ) {
                                        CourseCard(course: course)
                                    }

                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showAddCourse = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 52, height: 52)
                                .background(Color.primaryGreen)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 16)
                        .padding(.horizontal)
                    }
                    NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                        EmptyView()
                    }

                }

                // Slide Menu
                if showMenu {
                    SlideMenuView(
                        onClose: { showMenu = false },
                        onProfile: { },
                        onSettings: {
                            showMenu = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showSettings = true
                            }
                        },
                        onLogout: {
                            showMenu = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                                authVM.logout()
                            }
                        }
                    )
                    .transition(.move(edge: .trailing))
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddCourse) {
                NewCourseView { newCourse in
                    courses.append(newCourse)
                    saveCourses()
                }
            }
            .onAppear {
                loadCourses()
            }
        }
    }

    // MARK: - Persistence

    func userKey() -> String {
        guard let email = authVM.currentUser?.email else { return "courses_guest" }
        return "courses_\(email)"
    }

    func loadCourses() {
        if let data = UserDefaults.standard.data(forKey: userKey()),
           let decoded = try? JSONDecoder().decode([GolfCourse].self, from: data) {
            courses = decoded
        }
    }

    func saveCourses() {
        if let data = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(data, forKey: userKey())
        }
    }
}
