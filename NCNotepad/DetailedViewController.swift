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
    
    var fruitName:String!{
        didSet(newFruitName){
            if fruitNameLabel != nil {
                refreshUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUserInterface()
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
