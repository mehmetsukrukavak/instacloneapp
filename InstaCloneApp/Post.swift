//
//  Post.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 19.04.2023.
//

import Foundation
import UIKit

class Post{
    
    var _documentId : String
    var _postedBy : String
    var _postComment : String
    var _like : Int
    var _imageURL : String
    
    init(documentId: String, postedBy: String, postComment: String, like: Int, imageURL: String){
        self._documentId = documentId
        self._postedBy = postedBy
        self._postComment = postComment
        self._like = like
        self._imageURL = imageURL
    }
    
    
    func getPostedBy() -> String {
        return _postedBy
    }
    
    func getPostedComment() -> String {
        return _postComment
    }
    
    func getLikeCount() -> String {
        return "\(_like)"
    }
    
    func getImageURL() -> String {
        return _imageURL
    }
    
  
}
