//
//  NewCourseView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 14/04/2025.
//

import SwiftUI

struct NewCourseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var holeCount: Int = 9
    @State private var errorMessage: String? = nil
    
    @State private var distances: [String] = Array(repeating: "", count: 18)
    @State private var pars: [String] = Array(repeating: "", count: 18)
    @State private var strokeIndexes: [String] = Array(repeating: "", count: 18)
    
    @State private var showSuccessPopup = false


    var onSave: (GolfCourse) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Enter New Golf Course Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.primaryGreen)
                    
                    Group {
                        CustomTextField(placeholder: "Golf Club Location (City)", text: $location)
                        CustomTextField(placeholder: "Course Name", text: $name)
                    }
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(10)
                    
                    HStack(spacing: 12) {
                        ForEach([9, 18], id: \.self) { count in
                            Button(action: {
                                holeCount = count
                            }) {
                                Text("\(count) Holes")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(holeCount == count ? .white : .primary)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(holeCount == count ? Color.primaryGreen : Color.gray.opacity(0.55))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    Text("Hole Details")
                        .font(.title3)
                        .foregroundColor(.primaryGreen)
                    
                    ForEach(0..<holeCount, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hole \(i + 1)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primaryGreen)
                            
                            HStack {
                                CustomTextField(placeholder: "Distance", text: $distances[i], keyboardType: .numberPad)
                                CustomTextField(placeholder: "Par", text: $pars[i], keyboardType: .numberPad)
                                CustomTextField(placeholder: "Stroke Index", text: $strokeIndexes[i], keyboardType: .numberPad)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Button(action: saveCourse) {
                        Text("Confirm & Save")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.top, 12)
                        
                    }
                  
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 4)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(.white)
            }
            .hideKeyboardOnTap()
            .background(.white)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .overlay(
                Group {
                    if showSuccessPopup {
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(.primaryGreen)
                                        .frame(width: 44, height: 44)

                                    Text("Course created successfully!")
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

            .foregroundColor(.primaryGreen)
            .navigationBarHidden(false)
        }
    }
    
    // MARK: - Save Logic
    
    func saveCourse() {
        var holes: [GolfCourse.Hole] = []

        for i in 0..<holeCount {
            guard
                !distances[i].isEmpty,
                !pars[i].isEmpty,
                !strokeIndexes[i].isEmpty,
                let distance = Int(distances[i]),
                let par = Int(pars[i]),
                let stroke = Int(strokeIndexes[i])
            else {
                errorMessage = "Please fill in all fields for each hole."
                return
            }

            let hole = GolfCourse.Hole(
                id: i + 1,
                distance: distance,
                par: par,
                strokeIndex: stroke
            )
            holes.append(hole)
        }

        if name.trimmingCharacters(in: .whitespaces).isEmpty || location.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please enter both course name and location."
            return
        }

        let course = GolfCourse(
            id: UUID(),
            name: name,
            location: location,
            holes: holes
        )

        errorMessage = nil
        onSave(course)

        showSuccessPopup = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showSuccessPopup = false
            presentationMode.wrappedValue.dismiss()
        }

    }
}
