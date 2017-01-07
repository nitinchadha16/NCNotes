//
//  BaseViewController.swift
//  SplitViewControllerIpad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

class BaseViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Override point for customization after application launch.

        let leftNavController = self.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! MasterTableViewController
        let detailViewController = (self.viewControllers.last as! UINavigationController).viewControllers.first as! DetailedViewController

        let firstFruit = masterViewController.dataSource.first
        masterViewController.delegate = detailViewController
        detailViewController.fruitName = firstFruit
        masterViewController.currentSplitViewController = self
        
        self.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
