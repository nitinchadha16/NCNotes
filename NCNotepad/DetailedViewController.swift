//
//  DetailedViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var fruitNameLabel: UILabel!
    
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
        registerForNotification()
        initializeUserInterface()
        setUpNavigationBarUserInterface()
    }
    
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

    
    
    
    func initializeUserInterface(){
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.976, green: 0.949, blue: 0.494, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    func setUpNavigationBarUserInterface(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.341, green: 0.247, blue: 0.212, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Nitin Chadha"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func refreshUI(){
        fruitNameLabel.text = fruitName
    }
}

extension DetailedViewController: FruitSelectionDelegate {
    func fruitSelected(newFruit: String) {
        fruitName = newFruit
    }
}
