//
//  ImagePickerController.swift
//  FinalProject_147
//
//  Created by User20 on 2021/1/8.
//

import SwiftUI
struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var showSelectPhoto: Bool
    @Binding var selectImage: Image
    

    func makeCoordinator() -> Corrdinator {
        Coordinator(imagePickerController: self)
    }
    
    class Corrdinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        internal init(imagePickerController: ImagePickerController){
            self.imagePickerController = imagePickerController
        }
        let imagePickerController: ImagePickerController
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
            //print(info[.originalImage])
            if let uiImage = info[.originalImage] as? UIImage{
                imagePickerController.selectImage = Image(uiImage: uiImage)
                let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                let newPath = path.appendingPathComponent("image.jpg")
                let jpgImageData = uiImage.jpegData(compressionQuality: 1.0)
                do {
                    try jpgImageData!.write(to: newPath)
                    print(newPath)
                } catch {
                    print(error)
                }
                
            }
            imagePickerController.showSelectPhoto = false
        }
        
    }
    
    
    func makeUIViewController(context: Context) ->
    UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController:
                                    UIImagePickerController, context: Context) {
        
    }
    
    
}
