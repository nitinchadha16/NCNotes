//
//  BaseSplitViewController.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class BaseSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftNavController = self.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! MasterTableViewController
        let detailViewController = (self.viewControllers.last as! UINavigationController).viewControllers.first as! DetailedViewController
        detailViewController.masterTableView = masterViewController
     //   let firstFruit = masterViewController.dataSource.first
        masterViewController.delegate = detailViewController
     //   detailViewController.fruitName = firstFruit
        masterViewController.currentSplitViewController = self
        
        self.preferredDisplayMode = .allVisible
    }
}
