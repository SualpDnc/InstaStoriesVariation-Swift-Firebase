//
//  UploadVC.swift
//  InstaStories
//
//  Created by Sualp DANACI on 9.08.2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth




class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            uploadImageView.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
            uploadImageView.addGestureRecognizer(gestureRecognizer)
        }
        
        @objc func choosePicture() {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            uploadImageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func uploadClicked(_ sender: Any) {
            guard let image = uploadImageView.image, let data = image.jpegData(compressionQuality: 0.5) else {
                self.makeAlert(title: "Error", message: "Please select an image first.")
                return
            }
            
            let storage = Storage.storage()
            let storageReference = storage.reference()
            let mediaFolder = storageReference.child("media")
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                imageReference.downloadURL { url, error in
                    if let error = error {
                        self.makeAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else {
                        self.makeAlert(title: "Error", message: "Could not retrieve image URL.")
                        return
                    }
                    
                    // Firestore
                    let fireStore = Firestore.firestore()
                    
                    fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                        if let error = error {
                            self.makeAlert(title: "Error", message: error.localizedDescription)
                        } else if let snapshot = snapshot, !snapshot.isEmpty {
                            for document in snapshot.documents {
                                let documentId = document.documentID
                                
                                if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                    imageUrlArray.append(imageUrl)
                                    
                                    let additionalDictionary: [String: Any] = ["imageUrlArray": imageUrlArray]
                                    
                                    fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                        if error == nil {
                                            self.resetUploadView()
                                        }
                                    }
                                }
                            }
                        } else {
                            let snapDictionary: [String: Any] = [
                                "imageUrlArray": [imageUrl],
                                "snapOwner": UserSingleton.sharedUserInfo.username,
                                "date": FieldValue.serverTimestamp()
                            ]
                            
                            fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                if error == nil {
                                    self.resetUploadView()
                                } else {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func resetUploadView() {
            self.tabBarController?.selectedIndex = 0
            self.uploadImageView.image = UIImage(named: "selectimage.png")
        }
        
        func makeAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
