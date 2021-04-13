//
//  ViewController.swift
//  NoteTakingApp
//
//  Created by 王柏凱 on 2021/1/12.
//

import UIKit

class ViewController: UIViewController {
    
    private var isStarFiltered = false
    @IBOutlet weak var starFilterButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notesModel = NotesModel()
    private var notes = [Note]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the viewcontroller as the delegates for dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set the viewcontroller as the delegate for notesModelProtocol
        notesModel.delegate = self
        
        // Set the status of the star filter button
        setStarFilterButton()
        
        // Retrieve all notes according to the filter status
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let noteViewController = segue.destination as! NoteViewController
        
        // If the user has selected a row, transition to noteVC
        if tableView.indexPathForSelectedRow != nil {
            // Set the note and notesModel properties of the noteVC
            noteViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            
            // Deselect the selected row so that it doesn't interfere with new note creation
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        // Whether it's a new note or a selected note, we still want to pass through the notesModel
        noteViewController.notesModel = self.notesModel
        
    }
    
    func setStarFilterButton() {
        let imageName = isStarFiltered ? "star.fill":"star"
        starFilterButton.image = UIImage(systemName: imageName)
    }
    
    
    @IBAction func starFilterTapped(_ sender: Any) {
        // Toggle the star filter status
        isStarFiltered.toggle()
        
        // Run the query
        if isStarFiltered {
            notesModel.getNotes(true)
        }
        else {
            notesModel.getNotes()
        }
        
        // Update the star button
        setStarFilterButton()
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body
        
        return cell
        
    }
}

extension ViewController: NotesModelProtocol {
    
    func notesRetrieved(notes: [Note]) {
        
        // Set notes property and refresh the tableView
        self.notes = notes
        tableView.reloadData()
    }
    
    
    
}

