//
//  ProfileEditView.swift
//  Features
//
//  Created by Heeji Jung on 2/14/25.
//

import SwiftUI
import UIKit
import Shared

public struct ProfileEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ProfileViewModel
    
    @State private var showGenderSheet = false
    @State private var showDatePickerSheet = false
    @State private var showWeightSheet = false
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                    showActionSheet = true
                    
                }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 5)
                        .padding(.leading, 5)
                }
                Spacer()
            }
            .padding(.bottom, 10)
            .buttonStyle(PlainButtonStyle())

            Spacer()
                .frame(height: 50)
            
            // 닉네임
            HStack {
                Text("닉네임")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                TextField("공백 없이 최대 15자까지 입력 가능", text: $viewModel.profiledata.userName)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.trailing, -20)
            }
            .padding(.horizontal)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if !viewModel.isUserNameValid {
                Text("닉네임을 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // 성별
            HStack {
                Text("성별")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                Spacer()
                Button(action: {
                    showGenderSheet = true
                }) {
                    Text(viewModel.profiledata.userGender)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.trailing, -10)
            }
            .padding(.horizontal)
            .padding(.top, -10)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            HStack {
                Text("몸무게 (kg)")
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .padding(.leading, 5)
                Spacer()
                Button(action: {
                    showWeightSheet = true
                }) {
                    Text(String(viewModel.profiledata.userweight))
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.trailing, 5)
            }
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if !viewModel.isUserWeightValid {
                Text("올바른 몸무게를 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // 신장
            HStack {
                Text("신장 (cm)")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                TextField("", text: Binding(
                    get: { String(viewModel.profiledata.userheight) },
                    set: { viewModel.profiledata.userheight = Int32($0) ?? 0 }
                ))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.trailing, -15)
            }
            .padding(.horizontal)
            .padding(.top, -20)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if !viewModel.isUserHeightValid {
                Text("올바른 신장을 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // 생년월일
            HStack {
                Text("생년월일")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                Spacer()
                Button(action: {
                    showDatePickerSheet = true
                }) {
                    Text(viewModel.profiledata.userBirth)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, -10)
                }
            }
            .padding(.top, -10)
            .padding(.horizontal)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
        }
        .navigationTitle("프로필 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
            },
            trailing: Button(action: {}) {
                Text("Save")
                    .foregroundColor(viewModel.isFormValid ? Color.blue : Color.gray)
                    .disabled(!viewModel.isFormValid)
            }
        )
        .sheet(isPresented: $showGenderSheet) {
            GenderSelectionSheetView(selectedGender: $viewModel.profiledata.userGender)
                .presentationDetents([.fraction(0.35)])
        }
        .sheet(isPresented: $showDatePickerSheet) {
            BirthdateDatePickerSheetView(birthdate: $viewModel.profiledata.userBirth)
                .presentationDetents([.fraction(0.35)])
        }
        .sheet(isPresented: $showWeightSheet) {
            WeightInputSheetView(Weight: $viewModel.profiledata.userweight)
                .presentationDetents([.fraction(0.35)])
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("이미지 선택"),
                buttons: [
                    .default(Text("갤러리")) {
                        imageSourceType = .photoLibrary
                        showImagePicker = true
                        
                    },
                    .default(Text("사진 촬영")) {
                        imageSourceType = .camera
                        showImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(isImagePickerPresented: $showImagePicker, selectedImage: $selectedImage, imageSourceType: $imageSourceType)
        }
        .frame(width: UIScreen.main.bounds.width * 0.88)
    }
}

//MARK: 프로필 선택 시트 뷰(성별)
struct GenderSelectionSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedGender: String
    
    let genders = ["남성", "여성"]
    
    var body: some View {
        VStack {
            Text("성별을 선택하세요")
                .font(.headline)
                .padding()
            
            Picker("성별 선택", selection: $selectedGender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender)
                }
            }
            .pickerStyle(WheelPickerStyle())
            Spacer()
        }
        .padding()
    }
}


//MARK: 프로필 선택 시트 뷰(몸무게)
struct WeightInputSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var Weight: Double
    
    private let maxFrontValue: Double = 200
    private let maxBackValue: Double = 9
    
    @State private var frontValue: Double = 70
    @State private var backValue: Double = 0
    
    var body: some View {
        VStack {
            Text("몸무게를 입력하세요.")
                .font(.headline)
                .padding()
            

            HStack {
                Picker("Front Value", selection: $frontValue) {
                    ForEach(0...Int(maxFrontValue), id: \.self) { value in
                        Text("\(value)").tag(Double(value))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .onChange(of: frontValue) { newValue in
                    Weight = newValue + backValue
                }
                
                Text(".")
                    .font(.headline)

                Picker("Back Value", selection: $backValue) {
                    ForEach(0...Int(maxBackValue), id: \.self) { value in
                        Text("\(value)").tag(Double(value))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                .onChange(of: backValue) { newValue in
                    Weight = frontValue + newValue
                }
                
                Text("kg")
                    .font(.headline)
                    .padding()
            }
            .font(AppFont.subTitle)
            Spacer()
        }
        .padding()
    }
}


//MARK: 프로필 선택 시트 뷰(생년월일)
struct BirthdateDatePickerSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var birthdate: String
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("생년월일을 선택하세요")
                .font(.headline)
                .padding()
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .font(AppFont.subTitle)
                .onChange(of: selectedDate) { newDate in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd" 
                    birthdate = formatter.string(from: newDate)
                }
            
            Spacer()
        }
        .padding()
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: birthdate) {
                selectedDate = date
            }
        }
    }
}


struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environmentObject(ProfileViewModel())
    }
}
