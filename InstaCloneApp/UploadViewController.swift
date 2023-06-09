//
//  UploadViewController.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 28.03.2023.
//

import UIKit

import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideKeyboardgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                   
       view.addGestureRecognizer(hideKeyboardgestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage () {
    let pickerController = UIImagePickerController ()
    pickerController.delegate = self
    pickerController.sourceType = .photoLibrary
    present (pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           imageView.image = info[.originalImage] as? UIImage
           
           self.dismiss(animated: true)
       }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present (alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
            view.endEditing(true)
        }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        uploadButton.isEnabled = false
        let storage = Storage.storage()
        
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data,metadata: nil) { (metadata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            //print(imageUrl)
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "like" : 0 ] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                }else{
                                    self.uploadButton.isEnabled = true
                                    self.imageView.image = UIImage(named: "selectImage")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                                
                                
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
}
