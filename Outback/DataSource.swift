//
//  DataSource.swift
//  Outback
//
//  Created by Greg Tichy on 05/08/2018.
//  Copyright © 2018 Greg Tichy. All rights reserved.
//

import Foundation
import Cocoa


protocol elemProtocol {
    var window : Int {get}
    var tab : Int {get}
    var title : String {get}
    var url : String? {get}
}

struct elem : elemProtocol{
    private var _w : Int, _t : Int, _i : String, _u : String?
    init(_ w : Int, _ t : Int, _ i : String, _ u : String?) {
        _w = w; _t = t; _i = i; _u = u;
    }
    private func wf () -> Int {
        return _w
    }
    private func wt () -> Int {
        return _t
    }
    private func wi () -> String {
        return _i
    }
    private func wu () -> String? {
        return _u
    }
    var window: Int {get {return wf()}}
    var tab: Int {get {return wt()}}
    var title: String {get {return wi()}}
    var url: String? {get {return wu()}}
}

enum State {
    case before
    case inside
}

typealias sourceType = [elem]
extension Array where Element : elemProtocol { //}: NSOutlineViewDataSource {
    // n-th child if item
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any{
        if let elem = item as? Element {
            for i in 0..<self.count {
                if self[i].window == elem.window && self[i].tab == index {
                    return self[i]
                }
            }
        }
        return self[0]
    }
    // is item expandable?
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let Item = item as! elemProtocol
        return Item.window == 0 && Item.tab == 0
    }
    // number of children
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let elem = item as? Element {
            var whereIam : State = State.before
            var count = 0
            for i in 0..<self.count {
                if self[i].window == elem.window {
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
            return count + 1
        }
        return 0
    }
    // data for column
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        if let col = tableColumn, let Item = item as? Element {
            switch col.title {
            case "w":
                return Item.window
            case "t":
                return Item.tab
            case "Title":
                return Item.title
            case "URL":
                return Item.url
            default:
                return nil as Any?
            }
        }
        return nil as Any?
    }
}
