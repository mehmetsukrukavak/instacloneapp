//
//  FeedCell.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 11.04.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import OneSignal

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var documentId = "0"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            let currentUser = Auth.auth().currentUser?.email!
            if currentUser != userEmailLabel.text {
                
                
                let likeStore = ["like": likeCount + 1] as [String : Any]
                
                fireStoreDatabase.collection("Posts").document(documentId).setData(likeStore, merge: true)
                
                let userEmail = userEmailLabel.text!
                
                fireStoreDatabase.collection("Users").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
                    if error == nil {
                        if snapshot?.isEmpty == false && snapshot != nil {
                            for document in snapshot!.documents {
                                if let playerId = document.get ("playerId") as? String {
                                    OneSignal.postNotification(["contents": ["en": "\(Auth.auth().currentUser!.email!) liked your post"], "include_player_ids": ["\(playerId)"]])
                                }
                            }
                        }
                    }
                    
                }
            }
           
            
        }
    }
}
