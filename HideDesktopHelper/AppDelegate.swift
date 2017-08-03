//
//  AppDelegate.swift
//  HideDesktopHelper
//
//  Created by Chih-Hao on 2017/8/3.
//  Copyright © 2017年 XueYu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let mainAppIdentifier = "com.cocos2dev.MainApp"
        let running           = NSWorkspace.shared().runningApplications
        var alreadyRunning    = false
        
        for app in running {
            if app.bundleIdentifier == mainAppIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning {
            DistributedNotificationCenter.defaultCenter().addObserver(self, selector: "terminate", name: "killhelper", object: mainAppIdentifier)
            
            let path = Bundle.mainBundle.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("HideDesktop") //main app name
            
            let newPath = NSString.pathWithComponents(components)
            NSWorkspace.sharedWorkspace().launchApplication(newPath)
        } else {
            self.terminate()
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func terminate() {
        //      NSLog("I'll be back!")
        NSApp.terminate(nil)
    }
    
}
