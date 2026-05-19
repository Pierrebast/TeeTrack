//
//  CourseDetailView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 14/04/2025.
//

import SwiftUI

struct CourseDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var course: GolfCourse
    var onDelete: ((UUID) -> Void)? = nil

    @State private var showDeletePopup = false

    var body: some View {
        let hardestIDs = hardestHoleIDs(from: course.holes)

        ZStack {
            Color.white.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // 🔙 Top bar with back
                BackTopBarView(title: course.name) {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        // 🏞️ Image placeholder
                        Image("coursePreview")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location : " + course.location)
                                .font(.headline)
                                .foregroundColor(.primaryGreen)
                               

                            Text("Holes: \(course.holes.count)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)

                        Divider().padding(.horizontal)

                        Text("Hole Details")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryGreen)
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(course.holes.indices, id: \.self) { i in
                                let hole = course.holes[i]
                                let isHardest = hardestIDs.contains(hole.id)

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Hole \(hole.id)")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)

                                        Spacer()

                                        if isHardest {
                                            Text("Hardest")
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 4)
                                                .background(Color.red)
                                                .cornerRadius(6)
                                        }
                                    }

                                    HStack(spacing: 16) {
                                        Label("\(hole.distance)m", systemImage: "arrow.left.and.right")
                                        Label("Par \(hole.par)", systemImage: "flag")
                                        Label("Stroke \(hole.strokeIndex)", systemImage: "square.and.pencil")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)

                                Divider()
                                    .padding(.horizontal)

                            }
                        }

                        Button(action: {
                            
                            
                            showDeletePopup = true

                            // Wait a bit before actually deleting and dismissing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                onDelete?(course.id)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    showDeletePopup = false
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Label("Delete Course", systemImage: "trash")
                                .font(.subheadline)
                                //.fontWeight(.semibold)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }



                        Spacer(minLength: 40)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(
            Group {
                if showDeletePopup {
                    
                    VStack {
                        Spacer()

                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.primaryGreen)
                                    .frame(width: 44, height: 44)

                                Text("Course deleted successfully!")
                                    .font(.headline)
                                    .foregroundColor(.primaryGreen)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: 320)
                            .padding(.vertical, 24)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 8)
                            Spacer()
                        }

                        Spacer()
                    }
                    .padding(.bottom, 85)
                }
            }
        )

    }
}

func hardestHoleIDs(from holes: [GolfCourse.Hole]) -> Set<Int> {
    let sorted = holes.sorted(by: { $0.strokeIndex < $1.strokeIndex })
    return Set(sorted.prefix(2).map { $0.id })
}

