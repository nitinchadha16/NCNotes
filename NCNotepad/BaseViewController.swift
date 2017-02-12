//
//  BaseViewController.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserInterface()
        setUpNavigationBarUserInterface()
    }
    
    func initializeUserInterface(){
        self.view.backgroundColor = Constants_Color.APP_BACKGROUND_COLOR
    }
    
    func setUpNavigationBarUserInterface(){
        self.navigationController?.navigationBar.barTintColor = Constants_Color.NAVIGATION_BAR_COLOR
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}
