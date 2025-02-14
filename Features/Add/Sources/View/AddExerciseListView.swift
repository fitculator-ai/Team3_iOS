//
//  AddExerciseListView.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import SwiftUI
import Core

public struct AddExerciseListView: View {
    public init() {}
    public var body: some View {
        VStack {
            AddExerciseAerobicListView()
        }
    }
}

struct AddExerciseAerobicListView: View {
    var body: some View {
        ForEach(aerobicList) { item in
            Image(systemName: item.exerciseImage)
                .resizable()
                .frame(width: 50, height: 50)
                .background(Color(hex: item.exerciseColor))
                .clipShape(Circle())
                .padding()
        }
    }
}

#Preview {
    AddExerciseListView()
}
