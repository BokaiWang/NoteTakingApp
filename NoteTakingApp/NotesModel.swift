//
//  NotesModel.swift
//  NoteTakingApp
//
//  Created by 王柏凱 on 2021/1/12.
//

import Foundation
import Firebase

protocol NotesModelProtocol {
    
    func notesRetrieved(notes:[Note])
    
}

class NotesModel {
    
    var delegate:NotesModelProtocol?
    
    var listener:ListenerRegistration?
    
    deinit {
        // Unregister databse listener
        listener?.remove()
    }
    
    func getNotes(_ starredOnly:Bool = false) {
        
        // Detach any listener
        listener?.remove()
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        var query:Query = db.collection("notes")
        
        // If we're only looking for starred notes, update the query
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        // Get all the notes
        // In this app, Listener is used to refresh the table view everytime there's something changed
        self.listener = query.addSnapshotListener { (snapshot, error) in
            // Check for errors
            if error == nil && snapshot != nil {
                
                var notes = [Note]()
                
                // Parse documents into notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate = Timestamp.dateValue(doc["createdAt"] as! Timestamp)
                    
                    let lastUpdatedAtDate = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)
                    
                    let n = Note(docID: doc["docID"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, isStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate(), lastUpdatedAt: lastUpdatedAtDate())
                    
                    notes.append(n)
                }
                
                // Call the delegate and pass back the notes in the main thread
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes: notes)
                }
            }
        }
    }
    
    func deleteNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docID).delete()
    }
    
    func saveNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docID).setData(noteToDict(n))
    }
    
    func updateFavStatus(_ docId:String, _ isStarred:Bool) {
        let db = Firestore.firestore()
        db.collection("notes").document(docId).updateData(["isStarred":isStarred])
    }
    
    func noteToDict(_ n:Note)->[String:Any] {
        
        var dict = [String:Any]()
        
        dict["docID"] = n.docID
        dict["title"] = n.title
        dict["body"] = n.body
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        dict["isStarred"] = n.isStarred
        
        return dict
    }
}
