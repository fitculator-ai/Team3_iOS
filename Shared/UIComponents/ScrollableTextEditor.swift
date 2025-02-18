//
//  ScrollableTextEditor.swift
//  Fitculator
//
//  Created by JIHYE SEOK on 2/17/25.
//

import SwiftUI

public struct ScrollableTextEditor: UIViewRepresentable {
    @Binding var text: String
    @FocusState.Binding public var isFocused: Bool
    public var isEditing: Bool
    
    public init(text: Binding<String>, isEditing: Bool, isFocused: FocusState<Bool>.Binding) {
        self._text = text
        self.isEditing = isEditing
        self._isFocused = isFocused
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = isEditing
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.backgroundColor = UIColor(Color.cellColor)
        textView.delegate = context.coordinator
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.isEditable = isEditing
        
        if isEditing && isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: ScrollableTextEditor
        
        init(_ parent: ScrollableTextEditor) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
