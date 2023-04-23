//
//  FeedViewController.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 28.03.2023.
//

import UIKit
import Firebase
import SDWebImage
import OneSignal

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    let firestoreDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
      
        
        let status = OneSignal.getDeviceState()
        
        let playerId = status?.userId
        if let playerNewId = playerId {
            
            firestoreDatabase.collection("Users").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
                if error == nil{
                    
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let playerIdFromFirebase = document.get("playerId") as? String {
                               // print("plaverIDFromFirebase: " + playerIDFromFirebase)
                                
                                if playerNewId != playerIdFromFirebase{
                                    let userDictionary = ["email": Auth.auth().currentUser!.email, "playerId" : playerNewId] as! [String : Any]
                                    
                                    self.firestoreDatabase.collection("Users").addDocument(data: userDictionary){
                                        (error) in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                        }
                                    }
                                }
                            }
                           
                        }
                        
                    } else {
                        let userDictionary = ["email": Auth.auth().currentUser!.email, "playerId" : playerNewId] as! [String : Any]
                        
                        self.firestoreDatabase.collection("Users").addDocument(data: userDictionary){
                            (error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }
                        }
                    }
                    
                   
                }
            }
        }
       // print(playerId)
    }
    
    func getData(){
        
       
        
        firestoreDatabase.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else{
                if snapshot?.isEmpty != true {
                    self.posts = [Post]()
                    for document in  snapshot!.documents {
                        
                        let documentId = document.documentID
                        if let postedBy = document.get("postedBy") as? String {
                            if let imageUrl = document.get("imageUrl") as? String {
                                if let postComment = document.get("postComment") as? String {
                                    if let like = document.get("like") as? Int {
                                        let post = Post(documentId: documentId, postedBy: postedBy,postComment: postComment, like: like, imageURL: imageUrl)
                                        
                                        self.posts.append(post)
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! FeedCell
        
        let post = posts[indexPath.row]
        
        cell.commentLabel.text = post.getPostedComment()
        cell.likeLabel.text = post.getLikeCount()
        cell.userEmailLabel.text = post.getPostedBy()
        
        cell.userImageView.sd_setImage(with: URL(string: post.getImageURL()))
        cell.documentId = post.getDocumentId()
        return cell;
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present (alert, animated: true, completion: nil)
    }
   
    
}
