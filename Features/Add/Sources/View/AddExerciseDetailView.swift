//
//  AddExerciseDetailView.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI

struct AddExerciseDetailView: View {
    let exerciseName: String
    var body: some View {
            VStack {
                Rectangle()
                    .fill(Color.cellColor)
                    .frame(width: UIScreen.main.bounds.width * 0.88, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.top, .bottom], 10)
                
                Rectangle()
                    .fill(Color.cellColor)
                    .frame(width: UIScreen.main.bounds.width * 0.88, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 10)
                
                Rectangle()
                    .fill(Color.cellColor)
                    .frame(width: UIScreen.main.bounds.width * 0.88, height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
            }
            .navigationTitle(exerciseName)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddExerciseDetailView(exerciseName: "런닝")
}
