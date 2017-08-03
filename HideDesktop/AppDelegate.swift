//
//  AppDelegate.swift
//  HideDesktop
//
//  Created by zhihao on 8/2/17.
//  Copyright © 2017 zhihao. All rights reserved.
//

import Cocoa
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let hideMenuItem = NSMenuItem.init(title: "隐藏桌面图标", action: #selector(toggleHideDesktopFiles(sender:)), keyEquivalent: "")
    let startAtLoginItem = NSMenuItem.init(title: "开机启动", action: #selector(startAtLoginTog), keyEquivalent: "")
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    var desktopCreated = "unknown"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let button = statusItem.button
        button?.title = "🐱"
        let menu = NSMenu()
        
        let DevelopMenuItem = NSMenuItem.init(title: "Developped by Zhihao", action: #selector(toMyGithub), keyEquivalent: "")
        
       
        
        menu.addItem(self.hideMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(self.startAtLoginItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(DevelopMenuItem)
        menu.addItem(NSMenuItem.separator())
        let MenuItem = NSMenuItem.init(title: "好用记得star.", action: nil, keyEquivalent: "")
        menu.addItem(MenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem.init(title: "退出", action: #selector(quit), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let pipe = Pipe()
        let task = Process()
        
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["read", "com.apple.finder", "CreateDesktop"]
        task.standardOutput = pipe
        
        let file = pipe.fileHandleForReading
        task.launch()
        desktopCreated = NSString.init(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)! as String
        desktopCreated = desktopCreated.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Desktop is Hide
        if desktopCreated == "false" {
            hideMenuItem.state = NSOnState
        }
        
        statusItem.menu = menu
        
    }
    
    func startAtLoginTog(){
        if startAtLoginItem.state == NSOnState{
            startAtLoginItem.state = NSOffState
            LaunchAtLogin.isEnabled = false
            
        }else{
            startAtLoginItem.state = NSOnState
            LaunchAtLogin.isEnabled = true
        }
    }
    
    func toMyGithub(){
        
        
        if let url = URL(string: "https://github.com/zhihaozhang/HideDesktop"), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func toggleHideDesktopFiles(sender: NSMenuItem) {
        let workTask = Process()
        workTask.launchPath = "/usr/bin/defaults"
        
        if desktopCreated == "true" {
            workTask.arguments = ["write", "com.apple.finder", "CreateDesktop", "false"]
            sender.state = NSOnState
            desktopCreated = "false"
        } else {
            workTask.arguments = ["write", "com.apple.finder", "CreateDesktop", "true"]
            sender.state = NSOffState
            desktopCreated = "true"
        }
        
        workTask.launch()
        workTask.waitUntilExit()
        let killtask = Process()
        killtask.launchPath = "/usr/bin/killall"
        killtask.arguments = ["Finder"]
        killtask.launch()
    }
    
    func quit() {
    
        if desktopCreated == "false" {
            let workTask = Process()
            workTask.launchPath = "/usr/bin/defaults"
            workTask.arguments = ["write", "com.apple.finder", "CreateDesktop", "true"]
            self.hideMenuItem.state = NSOffState
            desktopCreated = "true"
            workTask.launch()
            workTask.waitUntilExit()
            let killtask = Process()
            killtask.launchPath = "/usr/bin/killall"
            killtask.arguments = ["Finder"]
            killtask.launch()
        }
        
        NSApplication.shared().terminate(self)
    }



}

