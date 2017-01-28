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
    
        let notes:Notes = (noteIndexInstance.notesDataSource[indexPath.row] as! Notes)
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
        if UIDevice.current.userInterfaceIdiom == .pad{
            if selectedIndex == nil {
                selectedIndex = indexPath
                notesList.reloadRows(at: [indexPath], with: .none)
            }else{
                let oldIndexPath = selectedIndex
                selectedIndex = indexPath
                notesList.reloadRows(at: [indexPath,oldIndexPath!], with: .none)
            }
        }
        self.delegate?.noteSelected(seletecedNote: noteIndexInstance.notesDataSource[indexPath.row] as! Notes)
        pushToDetailedViewController()
    }

    //MARK: BarButton Action Handler
    @IBAction func newBarButtonTapped(_ sender: AnyObject) {
        (delegate as? DetailedViewController)?.currentNote = nil
        pushToDetailedViewController()
    }
    
    func pushToDetailedViewController(){
        if UIDevice.current.userInterfaceIdiom == .phone {
            currentSplitViewController?.showDetailViewController((delegate as? DetailedViewController)!, sender: nil)
        }else{
            currentSplitViewController?.showDetailViewController(currentSplitViewController?.viewControllers.last as! UINavigationController, sender: nil)
        }
    }
    
    
    
}
