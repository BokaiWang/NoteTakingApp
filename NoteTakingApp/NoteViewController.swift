//
//  NoteViewController.swift
//  NoteTakingApp
//
//  Created by 王柏凱 on 2021/1/12.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    var note:Note?
    
    var notesModel:NotesModel?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note != nil {
            // User is veiwing an existing note, so populate the fields
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            
            // Set the status of the star button
            setStarButton()
        }
        else {
            // Note property is nil, so create a new note
            // Create the note
            let n = Note(docID: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", isStarred: false, createdAt: Date(), lastUpdatedAt: Date())
            
            self.note = n
        }
    }
    
    func setStarButton() {
        let imageName = note!.isStarred ? "star.fill":"star" // ? means if it is true or false
        
        starButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        if note != nil {
            notesModel?.deleteNote(note!)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        
        // This is an update to the existing note
        self.note?.title = titleTextField.text ?? ""    // ?? means if it's nil, assign ""
        self.note?.body = bodyTextView.text ?? ""
        self.note?.lastUpdatedAt = Date()
        
        // Send it to the notes model
        self.notesModel?.saveNote(self.note!)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func starTapped(_ sender: Any) {
        // Change the properties in the note
        note?.isStarred.toggle()
        
        // Update the database
        notesModel?.updateFavStatus(note!.docID, note!.isStarred)
        
        // Update the button
        setStarButton()
    }
    
}
