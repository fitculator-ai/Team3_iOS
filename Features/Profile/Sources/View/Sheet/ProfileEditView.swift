//
//  ProfileEditView.swift
//  Features
//
//  Created by Heeji Jung on 2/14/25.
//

import SwiftUI
import UIKit
import Core
import Shared

public struct ProfileEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ProfileViewModel
    
    @State private var showGenderSheet = false
    @State private var showDatePickerSheet = false
    @State private var showWeightSheet = false
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    
    @State private var userGender: Gender = .man
    
    @State private var userBirth: Date = Date()
    
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var showImageCropper = false
    
    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        
                        showActionSheet = true
                        
                    }) {
                        if let image = viewModel.profileImage {
                                 Image(uiImage: image)
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
                             } else if let selectedImage = viewModel.profileImage {
                                 Image(uiImage: selectedImage)
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
                             } else {
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
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                    .frame(height: 50)
                
                //닉네임
                HStack {
                    Text("닉네임")
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    TextField("공백 없이 최대 15자까지 입력 가능", text: Binding(
                        get: { viewModel.MyPageRecord?.userName ?? "" },
                        set: { newValue in
                            viewModel.MyPageRecord?.userName = newValue
                        }
                    ))
                    .multilineTextAlignment(.trailing)
                    .background(Color.background)
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
                        .padding(.top, -20)
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
                        if let genderString = viewModel.MyPageRecord?.userGender,
                           let gender = Gender.fromString(genderString) {
                            Text(gender.description)  // Gender Enum의 description을 사용하여 한글로 출력
                        } else {
                            Text(viewModel.userGender.description)
                        }
                    }
                    
//                    Button(action: {
//                        showGenderSheet = true
//                    }) {
//                        Text(viewModel.MyPageRecord?.userGender)
//                        print("viewModel.MyPageRecord?.userGender")
//                            .padding()
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                            .multilineTextAlignment(.trailing)
//                    }
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
                        Text(String(format: "%.1f", viewModel.MyPageRecord?.userWeight ?? 0.0))
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
                        .padding(.top, -20)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                //신장
                HStack {
                    Text("신장 (cm)")
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    
                    TextField(" ", text: Binding(
                        get: {
                            return viewModel.MyPageRecord?.userHeight != nil ? String(viewModel.MyPageRecord?.userHeight ?? 0) : ""
                        },
                        set: { newValue in
                            if let height = Int(newValue), height > 0, newValue.count <= 3 {
                                if viewModel.MyPageRecord?.userHeight == nil {
                                    viewModel.MyPageRecord?.userHeight = height
                                } else {
                                    viewModel.MyPageRecord?.userHeight = height
                                }
                            }
                        }
                    ))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .background(Color.background)
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
                        let birthString = viewModel.MyPageRecord?.userBirth ?? viewModel.dateFormatter.string(from: Date()) 
                        Text(birthString)
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
                trailing: Button(action: {
                    if let userId = viewModel.MyPageRecord?.userId,
                       let imageString = viewModel.profileImageString {
                        if let imageData = Data(base64Encoded: imageString),
                           let image = UIImage(data: imageData) {
                            viewModel.createProfileImage(userId: userId, image: image)
                        } else {
                            print("Failed to decode base64 string into UIImage")
                        }
                    }
                    viewModel.updateMyPage()
                }) {
                    Text("Save")
                        .foregroundColor(viewModel.isFormValid ? Color.blue : Color.gray)
                        .disabled(!viewModel.isFormValid)
                }
            )
//            .sheet(isPresented: $showGenderSheet) {
//                GenderSettingSheetView(selectedGender: $viewModel.MyPageRecord?.userGender)
//                       .presentationDetents([.fraction(0.35)])
////                GenderSettingSheetView(selectedGender: Binding(
////                    get: { viewModel.userGender},
////                    set: { newGender in
////                        $viewModel.userGender = newGender
////                    }
////                ))
//                //.presentationDetents([.fraction(0.35)])
//            }
//            .sheet(isPresented: $showGenderSheet) {
//                GenderSettingSheetView(selectedGender: Binding(
//                    get: { viewModel.userGender },  // 뷰 모델의 userGender 값을 가져옴
//                    set: { newGender in
//                        viewModel.userGender = newGender  // 새로 선택된 gender로 업데이트
//                    }
//                ))
//                .presentationDetents([.fraction(0.35)])
//            }
            .sheet(isPresented: $showGenderSheet) {
                if let genderString = viewModel.MyPageRecord?.userGender,
                   let gender = Gender.fromString(genderString) {
                    GenderSettingSheetView(selectedGender: Binding(
                        get: { gender },
                        set: { newGender in
                            // 성별이 선택되면 viewModel에 반영
                            viewModel.MyPageRecord?.userGender = newGender.description
                        }
                    ))
                    .presentationDetents([.fraction(0.35)])
                } else {
                    // 기본 성별을 지정
                    GenderSettingSheetView(selectedGender: Binding(
                        get: { Gender.man }, // 기본 성별: 남성
                        set: { newGender in
                            viewModel.MyPageRecord?.userGender = newGender.description
                        }
                    ))
                    .presentationDetents([.fraction(0.35)])
                }
            }
            .sheet(isPresented: $showWeightSheet) {
                WeightSettingSheetView(Weight: Binding(
                    get: {
                        Double(viewModel.MyPageRecord?.userWeight ?? 0)
                    },
                    set: { newWeight in
                        viewModel.MyPageRecord?.userWeight = (newWeight)
                    }
                ))
                .presentationDetents([.fraction(0.35)])
            }
            .sheet(isPresented: $showDatePickerSheet) {
                if let userBirth = viewModel.MyPageRecord?.userBirth {
                    BirthDatePickerSheetView(birthdate: Binding(
                        get: { userBirth },
                        set: { viewModel.MyPageRecord?.userBirth = $0 }
                    ))
                    .presentationDetents([.fraction(0.35)])
                } else {
                    Text("생년월일 미입력")
                }
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
                ImagePicker(isImagePickerPresented: $showImagePicker, selectedImage: $viewModel.profileImage, imageSourceType: $imageSourceType)
                    .onDisappear {
                        if viewModel.profileImage != nil {
                            showImageCropper = true
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width * 0.88)
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
            .environmentObject(ProfileViewModel())
    }
}
