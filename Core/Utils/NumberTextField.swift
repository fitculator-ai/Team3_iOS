//
//  NumberTextField.swift
//  Fitculator
//
//  Created by Song Kim on 2/21/25.
//

import UIKit
import SwiftUI

public struct NumberTextField: UIViewRepresentable {
    @Binding public var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberTextField

        init(_ parent: NumberTextField) {
            self.parent = parent
        }

        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = CharacterSet.decimalDigits
            return string.rangeOfCharacter(from: allowedCharacters) != nil || string.isEmpty
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
