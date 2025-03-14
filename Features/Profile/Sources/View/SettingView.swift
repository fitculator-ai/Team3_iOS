//
//  SettingView.swift
//  Features
//
//  Created by Heeji Jung on 2/17/25.
//

import SwiftUI
import Core
import Shared

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("계정관리")) {
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text("1")
                                .foregroundColor(.gray)
                        }
                        .listRowBackground(Color.cellColor)
                        
                        NavigationLink(destination: BlockedUsersView()) {
                            Text("차단한 사용자관리")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("건강 정보")) {
                        NavigationLink(destination: RestingHeartRateView().environmentObject(viewModel)){
                            Text("안정시 심박수 설정")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("멤버십 관리")) {
                        NavigationLink(destination: MembershipBenefitsView()) {
                            Text("멤버십 제휴 혜택")
                        }
                        .listRowBackground(Color.cellColor)
                        
                        NavigationLink(destination: PaymentMethodsView()) {
                            Text("결제수단")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("디바이스")) {
                        NavigationLink(destination: LinkedDevicesView()) {
                            Text("현재 연동 중인 디바이스")
                        }
                        .listRowBackground(Color.cellColor)
                        
                        NavigationLink(destination: ManageDevicesView()) {
                            Text("등록된 디바이스 관리")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("알림")) {
                        NavigationLink(destination: NotificationSettingsView()) {
                            Text("알림설정")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("서비스")) {
                        NavigationLink(destination: CustomerServiceView()) {
                            Text("고객센터")
                        }
                        .listRowBackground(Color.cellColor)
                        
                        NavigationLink(destination: FeedbackView()) {
                            Text("피드백 보내기")
                        }
                        .listRowBackground(Color.cellColor)
                        
                        NavigationLink(destination: TermsView()) {
                            Text("약관 및 정책")
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text("앱 정보")) {
                        HStack {
                            Text("버전 정보")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.basicColor)
                        }
                        .listRowBackground(Color.cellColor)
                    }
                    
                    Section(header: Text(" ")) {
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("회원탈퇴")
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .multilineTextAlignment(.trailing)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .padding(.top, -20)
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.background)
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .scrollIndicators(.never)
    }
}


// MARK: - 더미 뷰들

struct BlockedUsersView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text("차단한 사용자관리 화면")
            .navigationTitle("차단한 사용자")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct RestingHeartRateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var heartRateText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 120, height: 120)
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.basicColor)
                    .frame(width: 60, height: 60)
            }
            .padding(.top, 20)
            
            HStack {
                TextField(" ", text: Binding(
                    get: {
                        if let heartRate = profileViewModel.MyPageRecord?.userHeartRate {
                            return "\(heartRate)"
                        } else {
                            return ""
                        }
                    },
                    set: { newValue in
                        heartRateText = newValue
                        // 실시간 유효성 검사 (숫자인지 + 범위 체크)
                        if let newHeartRate = Int(newValue) {
                            profileViewModel.isHeartRateValid = (40...120).contains(newHeartRate)
                        } else {
                            profileViewModel.isHeartRateValid = false
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(width: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(profileViewModel.isHeartRateValid ? Color.clear : Color.red, lineWidth: 2)
                )
                
                Text("bpm")
                    .font(.title)
                    .foregroundColor(.basicColor)
                    .bold()
            }
            
            if !profileViewModel.isHeartRateValid {
                Text("심박수는 40~120 사이여야 합니다.")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .bold()
                    .padding(.top, 5)
            }
            
            Spacer()
            
            Button(action: {
                if let newHeartRate = Int(heartRateText), profileViewModel.isHeartRateValid {
                    profileViewModel.MyPageRecord?.userHeartRate = newHeartRate
                    
                    let heartRateRequest = HeartRateRequest(userId: 1, userHeartRate: profileViewModel.MyPageRecord?.userHeartRate ?? 0)
                    
                    profileViewModel.updateHeartRate(request: heartRateRequest)
                }
            }) {
                Text("저장")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(profileViewModel.isHeartRateValid ? Color.blue : Color.gray)
                    .foregroundColor(.basicColor)
                    .cornerRadius(10)
            }
            .disabled(!profileViewModel.isHeartRateValid) // 유효하지 않으면 버튼 비활성화
            .padding(.horizontal)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            // 화면이 나타날 때 저장된 심박수를 불러와서 초기화
            profileViewModel.fetchMyPage(userId: 1)
        }
        
    }
}
struct MembershipBenefitsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("멤버십 제휴 혜택 화면")
        
            .navigationTitle("멤버십 혜택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct PaymentMethodsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("결제수단 화면")
            .navigationTitle("결제수단")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct LinkedDevicesView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("현재 연동 중인 디바이스 화면")
            .navigationTitle("연동 중인 디바이스")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct ManageDevicesView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("등록된 디바이스 관리 화면")
            .navigationTitle("디바이스 관리")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("알림설정 화면")
            .navigationTitle("알림설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct CustomerServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("고객센터 화면")
            .navigationTitle("고객센터")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("피드백 보내기 화면")
            .navigationTitle("피드백")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct TermsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("약관 및 정책 화면")
            .navigationTitle("약관 및 정책")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct AppVersionView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("버전 정보 화면")
            .navigationTitle("버전 정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


#Preview {
    SettingView()
        .environmentObject(ProfileViewModel())
}
