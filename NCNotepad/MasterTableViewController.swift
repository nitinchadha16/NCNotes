//
//  MasterTableViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

protocol NoteSelectionDelegate: class {
    func noteSelected(seletecedNote: Notes)
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
        notesList.register(UITableViewCell.self, forCellReuseIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER)
        notesList.dataSource = self
        notesList.delegate = self
        notesList.backgroundColor = Colors.APP_BACKGROUND_COLOR
        notesList.separatorColor = Colors.NAVIGATION_BAR_COLOR
        
        separatorView.backgroundColor = UIDevice.current.userInterfaceIdiom == .phone ? UIColor.clear :  Colors.NAVIGATION_BAR_COLOR
        currentSplitViewController?.delegate = self
        self.title = Constants.APPLICATION_TITLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER, for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Cell_Identifier.NOTES_LIST_IDENTIFIER )
        }
        
        let totalCount = noteIndexInstance.notesDataSource.count - 1
    
        let notes:Notes = (noteIndexInstance.notesDataSource[totalCount - indexPath.row] as! Notes)
        cell?.textLabel?.text = notes.title
        cell?.textLabel?.textColor = UIColor.black
        cell?.backgroundColor = Colors.APP_BACKGROUND_COLOR
        cell?.selectionStyle = .none
        
        if UIDevice.current.userInterfaceIdiom == .pad && indexPath == selectedIndex{
            cell?.backgroundColor = Colors.NAVIGATION_BAR_COLOR
            cell?.textLabel?.textColor = UIColor.white
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
            noteIndexInstance.removeNoteAtIndex(index: noteIndexInstance.notesDataSource.count - 1 - indexPath.row)
            notesList.beginUpdates()
            notesList.deleteRows(at: [indexPath], with: .automatic)
            notesList.endUpdates()
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
        self.delegate?.noteSelected(seletecedNote: noteIndexInstance.notesDataSource[count - indexPath.row - 1] as! Notes)
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
    
    func addNewNoteToDataSource() -> Notes{
        let demoNote = Notes(id: 0, title: "Untitled Note", details: "", sortOrder: 0, date: NSDate() as Date, time: NSDate() as Date, favoriteTag: false, newNoteFlag: true)
        NotesIndex.sharedInstance.addNoteToDataSource(note: demoNote)
        return demoNote
    }
    
}
