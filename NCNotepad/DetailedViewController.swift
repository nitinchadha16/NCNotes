//
//  DetailedViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class DetailedViewController: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textContainer: UITextView!
    
    var masterTableViewController:MasterTableViewController?
    
    var currentNote:Notes!{
        didSet(newNoteName){
            if textContainer != nil {
                refreshUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotification()
        textContainer.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        textContainer.contentSize = CGSize(width: textContainer.frame.size.height, height: textContainer.contentSize.height)
        textContainer.showsHorizontalScrollIndicator = false
        textContainer.keyboardDismissMode = (UIDevice.current.userInterfaceIdiom == .pad) ? .none : .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    func getAttributedTextForString(string: String) -> NSAttributedString{
        textContainer.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 19.0;
        paragraphStyle.maximumLineHeight = 19.0;
        paragraphStyle.minimumLineHeight = 19.0;

        let ats = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16.0)!, NSParagraphStyleAttributeName: paragraphStyle]
        
        return NSAttributedString(string: string, attributes: ats)
    }
    
    func refreshUI(){
        if currentNote.newNoteFlag! {
            textContainer.attributedText = (currentNote.details == "" ? getAttributedTextForString(string: Constants.DEFAULT_TEXT) : getAttributedTextForString(string: currentNote.details!))
            self.title = ""
            rightBarButtonItem.title = "Save"
        }else{
            textContainer.attributedText = getAttributedTextForString(string: currentNote.details!)
            self.title = currentNote.title
            rightBarButtonItem.title = "More"
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.view.endEditing(true)
        }
    }
    
    //MARK: Keyboard Register Notification Methods
    
    func registerForNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedViewController.updateTextViewContentIntent(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil);
   //     NotificationCenter.default.addObserver(self, selector: #selector(DetailedViewController.updateTextViewContentIntent(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil);
    }
    
    //MARK: TextView Delegate Methods
  
    func textViewDidChange(_ textView: UITextView) {
        if currentNote.newNoteFlag! {
            if textContainer.attributedText.string == Constants.DEFAULT_TEXT {
                textContainer.attributedText = getAttributedTextForString(string: "")
            }else{
                if textContainer.attributedText.string.characters.count < 20 {
                    self.title = textContainer.attributedText.string
                }
            }
        }
        if textContainer.attributedText.string != "" && textContainer.attributedText.string != Constants.DEFAULT_TEXT{
            currentNote.details = textContainer.attributedText.string
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if currentNote.newNoteFlag! && textContainer.attributedText.string == Constants.DEFAULT_TEXT {
                textContainer.attributedText = getAttributedTextForString(string: "")
        }
        return true
    }
    

    //MARK: Bar Button Actions
    @IBAction func saveBarButtonTapped(_ sender: AnyObject) {

        if currentNote.newNoteFlag! == false {
            currentNote.details = textContainer.attributedText.string
            showOptionList()
        }else{
            showTitleNameAlertView()
        }
    }
    
    //MARK: Options List Method
    
    func showOptionList(){
        let settingsAlertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let favoriteText = currentNote.favoriteTag! ? "Remove from favorites" : "Add to favorites"
        settingsAlertView.addAction(UIAlertAction(title: favoriteText, style: .default, handler: {(alert: UIAlertAction!) in
                self.currentNote.favoriteTag = !self.currentNote.favoriteTag!
                self.masterTableViewController?.notesList.reloadData()
        }))
        settingsAlertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            settingsAlertView.modalPresentationStyle = .popover
            if let popoverController = settingsAlertView.popoverPresentationController {
                popoverController.barButtonItem = rightBarButtonItem
            }
        }
        
        
        self.present(settingsAlertView, animated: true, completion: nil)
    }
    
    func showTitleNameAlertView(){
    
        let confirmAlertBox = UIAlertController(title: "New Note", message: "Please provide title to your note", preferredStyle: .alert)
    
        confirmAlertBox.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        confirmAlertBox.addAction(UIAlertAction(title: "Save", style: .default, handler: { action -> Void in
        let textField = confirmAlertBox.textFields?.first
            let note = Notes.init(id: 0, title: ((textField?.text)! == "" ? self.title : textField?.text)!, details: self.textContainer.attributedText.string, sortOrder: 0, date: NSDate() as Date, time: NSDate() as Date, favoriteTag: false, newNoteFlag: false)
        let notesIndexInstance = NotesIndex.sharedInstance
        notesIndexInstance.replaceNoteWithOtherNote(replacedNote: self.currentNote, newNote: note)
        self.currentNote = note
        self.masterTableViewController?.notesList.reloadData()
        self.goBackToMasterViewController()
        }))
    
        confirmAlertBox.addTextField(configurationHandler: { (textField) -> Void in
        textField.placeholder = self.title
        })
        self.present(confirmAlertBox, animated: true, completion: nil)
    }
    
    func goBackToMasterViewController(){
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.textContainer.resignFirstResponder()
            self.navigationController?.popViewController(animated: true)
        }else{
            self.title = currentNote.title
            masterTableViewController?.tableViewDidSelect(indexPath: IndexPath(row: NotesIndex.sharedInstance.notesDataSource.count - 1 - NotesIndex.sharedInstance.notesDataSource.index(of: currentNote), section: 0))
        }
    }
    
    func updateTextViewContentIntent(_ notifaction: NSNotification){
        let userInfo = notifaction.userInfo!
        
        let keyboardEndFrameScreenCordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCordinates, to: self.view.window)
        
        if notifaction.name == Notification.Name.UIKeyboardWillChangeFrame{
            textContainer.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: keyboardEndFrame.height, right: 0)
            textContainer.scrollIndicatorInsets = textContainer.contentInset
        }else{
            textContainer.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
            textContainer.scrollIndicatorInsets = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        }
        
        textContainer.scrollRangeToVisible(textContainer.selectedRange)
    }
    
}

extension DetailedViewController: NoteSelectionDelegate {
    func noteSelected(seletecedNote: Notes) {
        currentNote = seletecedNote
    }
}
