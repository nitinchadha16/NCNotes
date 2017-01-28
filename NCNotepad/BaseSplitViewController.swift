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
        detailViewController.masterTableViewController = masterViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad && NotesIndex.sharedInstance.notesDataSource.count > 0 {
            let firstFruit = NotesIndex.sharedInstance.notesDataSource.lastObject as! Notes
            detailViewController.currentNote = firstFruit
        }
        
        masterViewController.delegate = detailViewController
        masterViewController.currentSplitViewController = self
        
        self.preferredDisplayMode = .allVisible
    }
}
