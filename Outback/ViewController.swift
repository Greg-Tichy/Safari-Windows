//
//  ViewController.swift
//  Outback
//
//  Created by Greg Tichy on 04/08/2018.
//  Copyright © 2018 Greg Tichy. All rights reserved.
//

import Cocoa
import Foundation
import SafariScripting
import ScriptingUtilities


class ViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    var selectedWin = -1, selectedTab = -1
    var content : sourceType = [elem(0, 0, "first", "first url"), elem(0, 1, "second", "second url")]

    @IBOutlet weak var theList: NSOutlineView!
    @IBAction func refrash(_ sender: Any) {
        content.removeAll()
        let loaded = loadAll()
        content = loaded.0
        windowCount = loaded.1
        numberOfWindows.stringValue = "Number of windows \(windowCount)"
        theList.reloadData()
    }
    
    @IBOutlet weak var numberOfWindows: NSTextFieldCell!
    @IBAction func quit(_ sender: Any) {
        closeDelegate()
    }
    var closeDelegate : () -> Void = {() -> Void in }
    
    @IBAction func activateAndQuit(_ sender: Any) {
        if selectedTab > -1 && selectedWin > -1 {
            let safari = ScriptingUtilities.application(name: "Safari") as! SafariApplication
            let windows = safari.windows!() as! [SafariWindow]
            let selectedWindow = windows[selectedWin] as SafariWindow
            let tabs = selectedWindow.tabs!() as! [SafariTab]
            let selected = tabs[selectedTab]
            selectedWindow.setCurrentTab!(selected)
            selectedWindow.setVisible!(true)
            safari.activate()
            closeDelegate()
        }
    }
    
    var windowCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loaded = loadAll()
        content = loaded.0
        windowCount = loaded.1
        numberOfWindows.stringValue = "Number of windows \(windowCount)"

        theList.dataSource = self
        theList.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func loadAll() -> (sourceType, Int) {
        let safari = ScriptingUtilities.application(name: "Safari") as! SafariApplication
        
        var windowCnt = 0;
        var tabCnt = 0
        var all = sourceType()
        for win in safari.windows!() {
            if let window : SafariWindow = win as? SafariWindow {
                print(window.description)
                let tabs = window.tabs!().count
                //        print ("window \(windowCnt) has \(tabs) tabs")
                tabCnt += tabs
                var tabNr = 0
                for tab in window.tabs!() {
                    if let Tab = tab as? SafariTab {
                        //                print("Title is \(Tab.name ?? "unknown") url \(Tab.URL ?? "unknown")")
                        all.append(elem(windowCnt, tabNr, Tab.name!, Tab.URL!))
                        tabNr += 1
                    }
                }
            }
            windowCnt += 1
        }
        return (all, windowCnt)
    }
    // n-th child
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any{
        if let el = item as? elem {
            print("get \(index)-th child of \(el.window)/\(el.tab)")
            for i in 0..<content.count {
                if content[i].window == el.window && content[i].tab == index + 1 {
                    return content[i]
                }
            }
        }
        print("get \(index)-th child of nil")
        for i in 0..<content.count {
            if content[i].window == index && content[i].tab == 0 {
                return content[i]
            }
        }
        print("WRONG")
        return content[index]
    }
    // is item expandable?
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let Item = item as! elem
        print("is \(Item.window)/\(Item.tab) expandable?")
        return Item.tab == 0
    }
    // number of children
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let el = item as? elem {
            print("number of children of \(el.window)/\(el.tab)")
            var whereIam : State = State.before
            var count = 0
            for i in 0..<content.count {
                if content[i].window == el.window {
                    if whereIam == State.before {
                        whereIam = State.inside
                    }
                    else {
                        count += 1
                    }
                }
                else if whereIam == State.inside {
                    break
                }
            }
            return count
        }
        print("number of children of root")
        return windowCount
    }
    // data for column
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let col = tableColumn, let Item = item as? elem {
            switch col.title {
            case "Window":
                let u = String(Item.window)
                print("get data 'w' of \(Item.window)/\(Item.tab)")
                return u as NSString
            case "Tab":
                let u = String(Item.tab)
                print("get data 't' of \(Item.window)/\(Item.tab)")
                return u as NSString
            case "Title":
                print("get data 'i' of \(Item.window)/\(Item.tab)")
                return Item.title as NSString
            case "URL":
                let u = Item.url ?? String()
                print("get data 'u' of \(Item.window)/\(Item.tab)")
                return u as NSString
            default:
                print("get data '?' of \(Item.window)/\(Item.tab)")
                return nil as Any?
            }
        }
        print("get data '?' of '?'")
        return nil as Any?
    }
    func outlineView(_ outlineView: NSOutlineView,
                     shouldSelectItem item: Any) -> Bool {
        let Item = item as! elem
        print("selected \(Item.window)/\(Item.tab)")
        return true
    }
    func outlineViewSelectionDidChange(_ notification: Notification) {
        print("CHANGED activated \(theList.selectedRow)")
        if (theList.selectedRow > -1) {
            let Item = theList.item(atRow: theList.selectedRow) as! elem
            selectedTab = Item.tab
            selectedWin = Item.window
            print("selected \(Item.window)/\(Item.tab)")
        }
    }
}

