//
//  AppDelegate.swift
//  PWGena
//
//  Created by Artem Turanov on 6/5/20.
//  Copyright © 2020 Artem Turanov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("pwIcon"))
        }
        popover.contentViewController = PWViewController.freshController()
        popover.behavior = .transient
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func constructMenu() {
      let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Generate new password", action: #selector(AppDelegate.togglePopover(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "About", action: #selector(AppDelegate.showAbout(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

      statusItem.menu = menu
    }
    
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }
    
    @objc func showAbout(_ sender: Any?) {
            let alert = NSAlert()
            alert.messageText = "About"
            alert.informativeText = "Password generation widget PWGena v1.0\n" +
                                    "Author: Artem Turanov\n"
            alert.runModal()
    }
    
}

