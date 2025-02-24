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
    
    @StateObject private var viewModel = SettingViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("계정관리")) {
                    HStack {
                        Text("이메일")
                        Spacer()
                        Text("user@example.com")
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink(destination: BlockedUsersView()) {
                        Text("차단한 사용자관리")
                    }
                }
                
                Section(header: Text("건강 정보")) {
                    NavigationLink(destination: RestingHeartRateView().environmentObject(viewModel)){
                        Text("안정시 심박수 설정")
                    }
                }
                
                Section(header: Text("멤버십 관리")) {
                    NavigationLink(destination: MembershipBenefitsView()) {
                        Text("멤버십 제휴 혜택")
                    }
                    NavigationLink(destination: PaymentMethodsView()) {
                        Text("결제수단")
                    }
                }
                
                Section(header: Text("디바이스")) {
                    NavigationLink(destination: LinkedDevicesView()) {
                        Text("현재 연동 중인 디바이스")
                    }
                    NavigationLink(destination: ManageDevicesView()) {
                        Text("등록된 디바이스 관리")
                    }
                }
                
                Section(header: Text("알림")) {
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("알림설정")
                    }
                }
                
                Section(header: Text("서비스")) {
                    NavigationLink(destination: CustomerServiceView()) {
                        Text("고객센터")
                    }
                    NavigationLink(destination: FeedbackView()) {
                        Text("피드백 보내기")
                    }
                    NavigationLink(destination: TermsView()) {
                        Text("약관 및 정책")
                    }
                }
                
                Section(header: Text("앱 정보")) {
                    HStack {
                        Text("버전 정보")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.white)
                    }
                }
                
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
                .background(Color.background)
                .listRowBackground(Color.clear)
                
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

// MARK: - 더미 뷰들

struct BlockedUsersView: View {
    var body: some View {
        Text("차단한 사용자관리 화면")
            .navigationTitle("차단한 사용자")
    }
}

struct RestingHeartRateView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
          VStack(spacing: 20) {
              ZStack {
                  Circle()
                      .fill(Color.red)
                      .frame(width: 120, height: 120)
                  Image(systemName: "heart.fill")
                      .resizable()
                      .scaledToFit()
                      .foregroundColor(.white)
                      .frame(width: 60, height: 60)
              }
              .padding(.top, 20)
              
              HStack {
                    TextField(" ", text: Binding(
                        get: {
                            return "\(viewModel.HeartRateRequest?.userHeartRate)"
                        },
                        set: { newValue in
                            if let newHeartRate = Int(newValue) {
                                viewModel.HeartRateRequest?.userHeartRate = newHeartRate
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
                        .stroke(viewModel.isValid ? Color.clear : Color.red, lineWidth: 2)
                  )
                  .onReceive(viewModel.$HeartRateRequest) { _ in
                      viewModel.validateHeartRate()
                  }
                  
                  Text("bpm")
                      .font(.title)
                      .foregroundColor(.white)
                      .bold()
              }
              
              if !viewModel.isValid {
                  Text("심박수는 40~120 사이여야 합니다.")
                      .foregroundColor(.red)
                      .font(.footnote)
                      .bold()
                      .padding(.top, 5)
              }
              
              Spacer()
              
              Button(action: {
                  if viewModel.validateHeartRate() {
                      let request = HeartRateRequest(userId: 1, userHeartRate: viewModel.HeartRateRequest?.userHeartRate ?? 40)
                      
//                      viewModel.updateHeartRate(request: request) { success, error in
//                          if success {
//                              self.presentationMode.wrappedValue.dismiss()
//                          } else {
//                              if let error = error {
//                                  print("Error: \(error.localizedDescription)")
//                              }
//                          }
//                      }
                  }
              }) {
                  Text("저장")
                      .bold()
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(viewModel.isValid ? Color.blue : Color.gray)
                      .foregroundColor(.white)
                      .cornerRadius(10)
              }
              .disabled(!viewModel.isValid)
              .padding(.horizontal)
          }
          .padding()
          .background(Color.black.edgesIgnoringSafeArea(.all))
      }
  }

struct MembershipBenefitsView: View {
    var body: some View {
        Text("멤버십 제휴 혜택 화면")
            .navigationTitle("멤버십 혜택")
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        Text("결제수단 화면")
            .navigationTitle("결제수단")
    }
}

struct LinkedDevicesView: View {
    var body: some View {
        Text("현재 연동 중인 디바이스 화면")
            .navigationTitle("연동 중인 디바이스")
    }
}

struct ManageDevicesView: View {
    var body: some View {
        Text("등록된 디바이스 관리 화면")
            .navigationTitle("디바이스 관리")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Text("알림설정 화면")
            .navigationTitle("알림설정")
    }
}

struct CustomerServiceView: View {
    var body: some View {
        Text("고객센터 화면")
            .navigationTitle("고객센터")
    }
}

struct FeedbackView: View {
    var body: some View {
        Text("피드백 보내기 화면")
            .navigationTitle("피드백")
    }
}

struct TermsView: View {
    var body: some View {
        Text("약관 및 정책 화면")
            .navigationTitle("약관 및 정책")
    }
}

struct AppVersionView: View {
    var body: some View {
        Text("버전 정보 화면")
            .navigationTitle("버전 정보")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


#Preview {
    SettingView()
}
