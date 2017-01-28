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
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var fruitName:String!{
        didSet(newFruitName){
            if fruitNameLabel != nil {
                refreshUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textContainer.text = Constants.DEFAULT_TEXT
        textContainer.delegate = self
        registerForNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
        
    }
    
    func refreshUI(){
        fruitNameLabel.text = fruitName
        self.title = fruitName
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
}

extension DetailedViewController: FruitSelectionDelegate {
    func fruitSelected(newFruit: String) {
        fruitName = newFruit
    }
}
