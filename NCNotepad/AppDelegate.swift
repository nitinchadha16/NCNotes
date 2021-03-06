//
//  AppDelegate.swift
//  NCNotepad
//
//  Created by Nitin Chadha on 1/7/17.
//  Copyright © 2017 Nitin Chadha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("delegate :  didFinishLaunchingWithOptions\n")
        
        UIApplication.shared.statusBarStyle = .lightContent
        ServiceManager.instance.getNotesDataSourceFromUserDefaults()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("delegate :  applicationWillResignActive\n")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("delegate :  applicationDidEnterBackground\n")
        ServiceManager.instance.saveNotesDataSourceToUserDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("delegate :  applicationWillEnterForeground\n")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("delegate :  applicationDidBecomeActive\n")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ServiceManager.instance.saveNotesDataSourceToUserDefaults()
        print("delegate :  applicationWillTerminate\n")
    }


}

