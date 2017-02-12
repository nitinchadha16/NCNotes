//
//  MasterTableViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

protocol NoteSelectionDelegate: class {
    func noteSelected(seletecedNote: Note)
}

class MasterTableViewController: BaseViewController,UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notesList: UITableView!
    
    weak var delegate: NoteSelectionDelegate?
    weak var currentSplitViewController: BaseSplitViewController?
    @IBOutlet weak var separatorView: UIView!

    var selectedIndex:IndexPath?
    var noteIndexInstance:NotesIndex = NotesIndex.sharedInstance
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesList.dataSource = self
        notesList.delegate = self
        notesList.backgroundColor = Constants_Color.APP_BACKGROUND_COLOR
        notesList.separatorColor = Constants_Color.NAVIGATION_BAR_COLOR
        
        separatorView.backgroundColor = UIDevice.current.userInterfaceIdiom == .phone ? UIColor.clear :  Constants_Color.NAVIGATION_BAR_COLOR
        currentSplitViewController?.delegate = self
        self.title = Constants_Application.TITLE
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .pad && noteIndexInstance.notesDataSource.count == 0 {
            pushToDetailedViewController(creatingNewNote: true)
        }else{
            if noteIndexInstance.notesDataSource.count > 0 {
                let lastNote:Note = noteIndexInstance.notesDataSource.lastObject as! Note
                if lastNote.title == Constants_Editor.DEFAULT_NOTE_NAME && lastNote.details == Constants_String.nEmptyString{
                    noteIndexInstance.notesDataSource.remove(lastNote)
                }
            }
        }
        notesList.reloadData()
    }
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteIndexInstance.notesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants_Cell_Identifier.NOTES_LIST_IDENTIFIER)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants_Cell_Identifier.NOTES_LIST_IDENTIFIER )
        }
        
        let totalCount = noteIndexInstance.notesDataSource.count - 1
    
        let notes:Note = (noteIndexInstance.notesDataSource[totalCount - indexPath.row] as! Note)
        cell?.textLabel?.text = notes.title
        cell?.textLabel?.textColor = UIColor.black
        cell?.detailTextLabel?.text = ServiceManager.convertDateFormater(date: notes.date!) + "  " + notes.details!
        cell?.detailTextLabel?.textColor = UIColor.black
         
        cell?.backgroundColor = Constants_Color.APP_BACKGROUND_COLOR
        cell?.selectionStyle = .none
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "favorite")
        cell?.accessoryView = notes.favoriteTag! ? imageView : UIView()
        
        if UIDevice.current.userInterfaceIdiom == .pad && indexPath == selectedIndex{
            cell?.backgroundColor = Constants_Color.NAVIGATION_BAR_COLOR
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.white
            imageView.image = #imageLiteral(resourceName: "favorite_ipad_yellow")
            cell?.accessoryView = notes.favoriteTag! ? imageView : UIView()
        }
        return cell!
    }
    
    //MARK: TableView Delegate Methods
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewDidSelect(indexPath: indexPath)
        pushToDetailedViewController(creatingNewNote: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let noteToRemove:Note = noteIndexInstance.notesDataSource[noteIndexInstance.notesDataSource.count - 1 - indexPath.row] as! Note
            noteIndexInstance.notesDataSource.remove(noteToRemove)
            notesList.beginUpdates()
            notesList.deleteRows(at: [indexPath], with: .automatic)
            notesList.endUpdates()
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if noteIndexInstance.notesDataSource.count == 0 {
                    pushToDetailedViewController(creatingNewNote: true)
                }else if noteToRemove == (delegate as? DetailedViewController)?.currentNote{
                    tableViewDidSelect(indexPath: IndexPath(row: 0, section: 0))
                }
            }
            
        }
    }
    
    func tableViewDidSelect(indexPath:IndexPath){
        if UIDevice.current.userInterfaceIdiom == .pad{
            if selectedIndex == nil  {
                selectedIndex = indexPath
                notesList.reloadRows(at: [indexPath], with: .none)
            }else{
                selectedIndex = indexPath
                notesList.reloadRows(at: notesList.indexPathsForVisibleRows!, with: .none)
            }
        }
        let count = noteIndexInstance.notesDataSource.count
        self.delegate?.noteSelected(seletecedNote: noteIndexInstance.notesDataSource[count - indexPath.row - 1] as! Note)
    }
    

    //MARK: BarButton Action Handler
    
    @IBAction func newBarButtonTapped(_ sender: AnyObject) {
        pushToDetailedViewController(creatingNewNote: true)
    }
    
    func pushToDetailedViewController(creatingNewNote:Bool){
        if UIDevice.current.userInterfaceIdiom == .phone {
            currentSplitViewController?.showDetailViewController((delegate as? DetailedViewController)!, sender: nil)
            if  (creatingNewNote) {
                (delegate as? DetailedViewController)?.currentNote = addNewNoteToDataSource()
            }
        }else{
            currentSplitViewController?.showDetailViewController(currentSplitViewController?.viewControllers.last as! UINavigationController, sender: nil)
            if  (creatingNewNote) {
                    selectedIndex = nil
                    (delegate as? DetailedViewController)?.currentNote = addNewNoteToDataSource()
                    notesList.reloadData()
                    tableViewDidSelect(indexPath: IndexPath(row: 0, section: 0))
            }
        }
    }
    
    func addNewNoteToDataSource() -> Note{
        let demoNote = Note(id: 0, title: Constants_Editor.DEFAULT_NOTE_NAME, details: Constants_String.nEmptyString, sortOrder: 0, date: NSDate() as Date, time: NSDate() as Date, favoriteTag: false, newNoteFlag: true)
        NotesIndex.sharedInstance.addNoteToDataSource(note: demoNote)
        return demoNote
    }
    
}
