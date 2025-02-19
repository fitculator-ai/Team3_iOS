//
//  MyWorkoutDetailView.swift
//  Features
//
//  Created by JIHYE SEOK on 2/14/25.
//

import SwiftUI
import Shared

struct MyWorkoutDetailView: View {
    @State private var showDialog: Bool = false
    @State private var isEditing: Bool = false
    @State private var textEditor: String = ""
    @State private var originalText: String = ""
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 75, height: 75)
                    Image(systemName: "figure.run")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                VStack(alignment: .leading) {
                    Text("달리기")
                        .font(AppFont.subTitle)
                    Text("오후 2:11 - 오후 3:40")
                        .font(.system(size: 16))
                }
                Spacer()
                Text("111.3pt")
                    .font(AppFont.mainTitle)
            }
            .padding(.vertical)
            
            Text("운동 세부사항")
                .font(AppFont.subTitle)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cellColor)
                    .frame(height: 250)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("평균 심박수")
                            .font(AppFont.cellTitle)
                        HStack {
                            Text("160")
                                .font(AppFont.subTitle)
                            Text("bpm")
                        }
                        .padding(.vertical, 3)
                    }
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 3)
                        .padding(.bottom, 3)
                    
                    VStack(alignment: .leading) {
                        Text("운동 시간")
                            .font(AppFont.cellTitle)
                        HStack {
                            Text("120")
                                .font(AppFont.subTitle)
                            Text("min")
                        }
                        .padding(.vertical, 3)
                    }
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 3)
                        .padding(.bottom, 3)
                    
                    VStack(alignment: .leading) {
                        Text("운동 강도")
                            .font(AppFont.cellTitle)
                        Text("낮음")
                            .font(AppFont.subTitle)
                            .foregroundStyle(Color.yellow)
                            .padding(.vertical, 3)
                    }
                }
            }
            .padding(.bottom)
            
            Text("메모")
                .font(AppFont.subTitle)

            ScrollableTextEditor(
                text: $textEditor,
                isEditing: isEditing,
                isFocused: $isFocused
            )
                .frame(height: 150)
                .focused($isFocused)
                .cornerRadius(10)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.88)
        .navigationTitle("2월 17일 (월)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if !isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDialog = true
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        textEditor = originalText
                        isEditing = false
                        isFocused = false
                    } label: {
                        Text("취소")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        originalText = textEditor
                        isEditing = false
                        isFocused = false
                    }
                }
            }
        }
        .confirmationDialog("MyWorkoutEdit", isPresented: $showDialog) {
            Button("수정") {
                isEditing = true
                isFocused = true
            }
            Button("삭제", role: .destructive) {
                print("삭제 선택됨")
            }
            Button("취소", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        MyWorkoutDetailView()
    }
}
