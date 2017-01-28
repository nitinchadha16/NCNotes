//
//  DetailedViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class DetailedViewController: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var textContainer: UITextView!
    
    var masterTableView:MasterTableViewController?
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var currentNote:Notes!{
        didSet(newNoteName){
            if textContainer != nil {
                refreshUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textContainer.delegate = self
        registerForNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
        
    }
    
    func refreshUI(){
        if currentNote != nil {
            textContainer.text = currentNote.details
            self.title = currentNote.title
        }else{
            textContainer.text = Constants.DEFAULT_TEXT
            self.title = ""
        }
    }
    
    //MARK: Keyboard Register Notification Methods
    
    func registerForNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textViewBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textViewBottomConstraint.constant = 0
        })
    }
    
    //MARK: TextView Delegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constants.DEFAULT_TEXT {
            textView.text = ""
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(_ sender: AnyObject) {

        let confirmAlertBox = UIAlertController(title: nil, message: "Please provide title to your note", preferredStyle: .alert)
    
        confirmAlertBox.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        confirmAlertBox.addAction(UIAlertAction(title: "Save", style: .default, handler: { action -> Void in
            let textField = confirmAlertBox.textFields?.first
            let note = Notes.init(id: 0, title: (textField?.text)!, details: self.textContainer.text, sortOrder: 0, date: NSDate() as Date, time: NSDate() as Date, favoriteTag: false)
            self.currentNote = note
            let notesIndexInstance = NotesIndex.sharedInstance
            notesIndexInstance.addNoteToDataSource(note: note)
            self.masterTableView?.notesList.reloadData()
            self.goBackToMasterViewController()
        }))
        
        confirmAlertBox.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "add Title"
        })
        
        self.present(confirmAlertBox, animated: true, completion: nil)
    }
    
    func goBackToMasterViewController(){
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.textContainer.resignFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }else{
            self.title = currentNote.title
        }
    }
}

extension DetailedViewController: NoteSelectionDelegate {
    func noteSelected(seletecedNote: Notes) {
        currentNote = seletecedNote
    }
}
