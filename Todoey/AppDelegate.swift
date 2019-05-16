//
//  AppDelegate.swift
//  Todoey
//
//  Created by michael kibler on 4/24/19.
//  Copyright © 2019 michael kibler. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{

            _ = try Realm()
            
        } catch {
            print("error initialising new realm, \(error)")
            
        }
        
    
        return true
    }



}
