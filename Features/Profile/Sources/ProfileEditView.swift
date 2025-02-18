//
//  ProfileEditView.swift
//  Features
//
//  Created by Heeji Jung on 2/14/25.
//

import SwiftUI
import Shared

struct ProfileEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var nickname: String = ""
    @State private var weight: String = "0"
    @State private var height: String = "0.0"
    @State private var birthdate: Date = Date()
    
    @State private var showGenderSheet = false
    @State private var selectedGender: String = "남성"
    
    @State private var showDatePickerSheet = false
    
    let genders = ["남성", "여성"]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    private var isFormValid: Bool {
        return !nickname.isEmpty && nickname.count <= 15 &&
               !weight.isEmpty && Double(weight) != nil &&
               !height.isEmpty && Double(height) != nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 5)
                    .padding(.leading, 5)
                Spacer()
            }
            .padding(.bottom, 10)

            Spacer()
                .frame(height: 50)
            
            HStack {
                Text("닉네임")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                TextField("공백 없이 최대 15자까지 입력 가능", text: $nickname)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if nickname.isEmpty {
                Text("닉네임을 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, -20)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing) 
            }

            HStack {
                Text("성별")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    showGenderSheet = true
                }) {
                    Text(selectedGender)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.trailing)
                }
                .multilineTextAlignment(.trailing)
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
                    .frame(width: 100, alignment: .leading)
                TextField("", text: $weight)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.top, -20)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if weight.isEmpty || Double(weight) == nil {
                Text("올바른 몸무게를 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, -20)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack {
                Text("신장 (cm)")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                TextField("", text: $height)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.top, -20)
            
            Divider()
                .background(Color.white)
                .frame(height: 2)
                .padding(.top, -20)
                .padding(.horizontal, 20)
            
            if height.isEmpty || Double(height) == nil {
                Text("올바른 신장을 입력해주세요.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, -20)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            HStack {
                Text("생년월일")
                    .foregroundColor(.white)
                    .frame(width: 100, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    showDatePickerSheet = true
                }) {
                    Text(dateFormatter.string(from: birthdate))
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.trailing)
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
                    .foregroundColor(isFormValid ? .blue : .gray)
                    .disabled(!isFormValid) 
            }
        )
        .sheet(isPresented: $showGenderSheet) {
            GenderSelectionSheet(selectedGender: $selectedGender)
                .presentationDetents([.fraction(0.35)])
        }
        .sheet(isPresented: $showDatePickerSheet) {
            BirthdateDatePickerView(birthdate: $birthdate)
                .presentationDetents([.fraction(0.35)])
        }
        .frame(width: UIScreen.main.bounds.width * 0.88)
    }
}
struct GenderSelectionSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedGender: String
    
    let genders = ["남성", "여성"]
    
    var body: some View {
        VStack {
            Text("성별을 선택하세요")
                .font(AppFont.subTitle)
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

struct BirthdateDatePickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var birthdate: Date
    
    var body: some View {
        VStack {
            Text("생년월일을 선택하세요")
                .font(AppFont.subTitle)
                .padding()
            
            DatePicker("", selection: $birthdate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            
                .font(AppFont.subTitle)
            
            Spacer()
        }
        .padding()
    }
}



// #Preview
struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}

