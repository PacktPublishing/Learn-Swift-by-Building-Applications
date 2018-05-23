//
//  DataManager.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 5.03.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PostModel {
    var photoURL:String?
    var description:String
    var author:String
    
    init(description: String, author:String) {
        self.photoURL = nil
        self.description = description
        self.author = author
    }
    
    init(photoURL: String, description: String, author:String) {
        self.photoURL = photoURL
        self.description = description
        self.author = author
    }
    
    var toDict:[String:String] {
        var dict:[String:String] = [:]
        
        dict["description"] = description
        dict["author"] = author
        if let photoURL = self.photoURL {
            dict["photo"] = photoURL
        }
        
        return dict
    }
}

final class DataManager {
    //private constructor
    private init() {
        databaseRef = Database.database().reference()
    }
    //single instance
    static let shared = DataManager()
    
    var databaseRef: DatabaseReference!
    var userUID: String?
    var user: User?
    
    
    func createPost(post: PostModel, callback: @escaping (Bool) -> ()) {
        if let userID = userUID {
            let key = databaseRef.child("posts").childByAutoId().key
            let postData = post.toDict
            let childUpdates = ["/posts/\(key)": postData,
                                "/myposts/\(userID)/\(key)/": postData]
            databaseRef.updateChildValues(childUpdates)
            
            callback(true)
        } else {
            callback(false)
        }
    
    }
    
    func createPost(post:PostModel, image:UIImage, progress: @escaping (Double)->(),callback: @escaping (Bool) -> () ) {
        
        guard let userID = userUID else {
            callback(false)
            return
        }
        // key for the data
        let key = databaseRef.child("posts").childByAutoId().key

        let storageRef = Storage.storage().reference()
        // location of the image for a particular post
        let photoPath = "posts/\(userID)/\(key)/photo.jpg"
        let imageRef = storageRef.child(photoPath)
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.customMetadata = ["userId": userID]
        
        
        let data = UIImageJPEGRepresentation(image, 0.9)
        // Upload data and metadata
        let uploadTask = imageRef.putData(data!, metadata: metadata)
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let complete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }

        uploadTask.observe(.success) { [unowned uploadTask, weak self] snapshot in
            // Upload completed successfully
            uploadTask.removeAllObservers()
            
            
            var postData = post.toDict
            postData["photo"] = photoPath
            let childUpdates = ["/posts/\(key)": postData,
                                "/myposts/\(userID)/\(key)/": postData]
            self?.databaseRef.updateChildValues(childUpdates)
            
            callback(true)
        }
        
        uploadTask.observe(.failure) { [unowned uploadTask] snapshot in
            uploadTask.removeAllObservers()
            callback(false)
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("object not found")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("user has no permissions")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("upload was cancelled")
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
}
