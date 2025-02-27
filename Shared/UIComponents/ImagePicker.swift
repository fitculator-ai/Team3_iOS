//
//  ImagePicker.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import SwiftUI
import UIKit

public struct ImagePicker: UIViewControllerRepresentable {
    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        public init(parent: ImagePicker) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.isImagePickerPresented = false
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }
    
    @Binding public var isImagePickerPresented: Bool
    @Binding public var selectedImage: UIImage?
    @Binding public var imageSourceType: UIImagePickerController.SourceType
    
    public init(isImagePickerPresented: Binding<Bool>, selectedImage: Binding<UIImage?>, imageSourceType: Binding<UIImagePickerController.SourceType>) {
            self._isImagePickerPresented = isImagePickerPresented
            self._selectedImage = selectedImage
            self._imageSourceType = imageSourceType
        }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = imageSourceType // sourceType을 imageSourceType에 맞게 설정
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
