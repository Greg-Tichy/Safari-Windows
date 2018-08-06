//
//  WindowController.swift
//  Outback
//
//  Created by Greg Tichy on 06/08/2018.
//  Copyright © 2018 Greg Tichy. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        let vs = self.contentViewController as? ViewController
        if vs != nil {
            print("ViewController found")
            vs?.closeDelegate = closeMe
        }
    }
    func closeMe() -> Void {
        self.close()
    }
}
