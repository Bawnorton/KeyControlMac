//
//  AppDelegate.swift
//  KeyControlSBMac
//
//  Created by Benjamin Norton on 2021-12-05.
//

import Cocoa
import SwiftUI

@main
struct KeyControlMBApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    var viewController = ViewController.newInstance()
    func applicationDidFinishLaunching(_ notification: Notification) {
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = viewController
        popOver.contentViewController?.view.window?.makeKey()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
        if let MenuButton = statusItem?.button {
            MenuButton.image = NSImage(systemSymbolName: "icloud.and.arrow.up.fill", accessibilityDescription: nil)
            MenuButton.action = #selector(MenuButtonToggle)
        }
    }
    
    @objc func MenuButtonToggle(sender: AnyObject) {
        if popOver.isShown {
            popOver.performClose(sender)
        } else {
            if let menuButton = statusItem?.button {
                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
                if viewController.presentedViewControllers!.count == 0 {
                    let browser = viewController.startBrowser()
                    browser.view.frame = (popOver.contentViewController?.view.frame)!
                    viewController.presentAsSheet(browser)
                }
            }
        }
    }
}



