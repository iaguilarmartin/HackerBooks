//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        do {
            if let json = try DataDownloader.downloadApplicationData() {
                let library = Library(json: json)
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                
                let libraryVC = LibraryViewController(model: library)
                let libraryNav = UINavigationController(rootViewController: libraryVC)
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    var book: Book?
                    
                    if library.tags.count > 0 {
                        book = library.getBookFromTag(library.tags[0], atIndex: 0)
                    }
                    
                    let bookVC = BookViewController(model: book)
                    let bookNav = UINavigationController(rootViewController: bookVC)
                    let splitVC = UISplitViewController()
                    splitVC.viewControllers = [libraryNav, bookNav]
                    window?.rootViewController = splitVC
                    
                    libraryVC.delegate = bookVC
                    
                } else {
                    window?.rootViewController = libraryNav
                }
                
                window?.makeKeyAndVisible()
                
            } else {
                fatalError("ERROR: Unable to load application data")
            }
        } catch ApplicationErrors.invalidJSONURL {
            print("ERROR: Invalid JSON URL")
            
        } catch ApplicationErrors.cantSaveJSONFile {
            print("ERROR: While trying to save JSON on documents folder")
            
        } catch {
            print("ERROR: Unknown error")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

