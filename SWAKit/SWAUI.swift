//
//  SWAUI.swift
//  SWAKit
//
//  Created by Vasiliy Kharitonov on 17/04/2018.
//

import Foundation

protocol SWAUIObject {
    
    //This protocol is used for all UI objects
    
    func makeHTML() -> String
    
}

enum Icon {
    case None
    case Home
    case Plus
    case SignOut
    case Download
}

func getIconParameter(icon: Icon) -> String {
    var iconParameter = " "
    switch icon {
    case .Home:
        iconParameter += "uk-icon='icon: home'"
    case .Plus:
        iconParameter += "uk-icon='icon: plus'"
    case .SignOut:
        iconParameter += "uk-icon='icon: sign-out'"
    case .Download:
        iconParameter += "uk-icon='icon: download'"
    default:
        iconParameter = ""
    }
    return iconParameter
}

public struct Block: SWAUIObject {
    
    var title = ""
    var icon: Icon = .None
    var badge = ""
    var style = Style.None
    var contents = [ SWAUIObject ]()
    
    func makeHTML() -> String {
        
        var html = ""
        
        var ukStyle = ""
        
        switch style {
        case .Default:
            ukStyle = " uk-card-default"
        case .Primary:
            ukStyle = " uk-card-primary"
        case .Secondary:
            ukStyle = " uk-card-secondary"
        case .Danger:
            ukStyle = " uk-card-danger"
        default:
            ukStyle = ""
        }
        
        html += "<div class='uk-card uk-card-small uk-card-body" + ukStyle + "'>\n"
        
        if badge != "" {
            html += "<div class='uk-card-badge uk-label'>" + badge + "</div>\n"
        }
        
        if title != "" {
            html += "<h3>" + title + "</h3>\n"
        }
        for content in contents {
            html += content.makeHTML()
        }
        
        html += "</div>\n"
        
        return html
        
    }
    
}

enum GridStyle {
    case Standard
    case Sidebar
}

public struct Grid: SWAUIObject {
    
    var contents = [SWAUIObject]()
    var columns = 4
    var style = GridStyle.Standard
    
    func makeHTML() -> String {
        
        var html = ""
        
        switch style {
            
        case .Sidebar:
            html += "<div class='uk-grid-small' uk-grid>\n"
            var first = true
            for content in contents {
                if first == true {
                    html += "<div class='uk-width-1-3'>\n" +
                        content.makeHTML() +
                    "</div>\n"
                    first = false
                } else {
                    html += "<div class='uk-width-2-3'>\n" +
                        content.makeHTML() +
                    "</div>\n"
                }
            }
            html += "</div>\n"
            
        default:
            html += "<div class='uk-grid-small' uk-grid>\n"
            for content in contents {
                html += "<div class='uk-width-1-" + String(columns) + "'>\n" +
                    content.makeHTML() +
                "</div>\n"
            }
            html += "</div>\n"
        }
        
        return html
    }
    
}

public enum Style {
    case None
    case Default
    case Primary
    case Secondary
    case Danger
}

public enum Size {
    case Small
    case Large
    case Default
}

public struct Button: SWAUIObject {
    
    var title = ""
    var icon: Icon = .None
    var link = ""
    var style = Style.None
    var size = Size.Default
    var toggle = false
    
    func makeHTML() -> String {
        
        var ukStyle = ""
        
        switch style {
        case .Default:
            ukStyle = " uk-button-default"
        case .Primary:
            ukStyle = " uk-button-primary"
        case .Secondary:
            ukStyle = " uk-button-secondary"
        case .Danger:
            ukStyle = " uk-button-danger"
        default:
            ukStyle = ""
        }
        
        var ukSize = ""
        
        switch size {
        case .Default:
            ukSize = ""
        case .Small:
            ukSize = " uk-button-small"
        case .Large:
            ukSize = " uk-button-large"
        }
        
        var toggleParameter = ""
        
        if toggle {
            toggleParameter = " uk-toggle"
        }
        
        let html = "<a href='" + link + "' class='uk-button" + ukStyle + ukSize + "'" + toggleParameter + ">" + title + "</a>\n"
        
        return html
    }
    
}

enum LinkStyle {
    case None
    case Bold
    case Heading
    case Reset // Color is not changed
}

public struct Link: SWAUIObject {
    
    var title = ""
    var icon: Icon = .None
    var link = ""
    var style = LinkStyle.None
    var toggle = false
    
    func makeHTML() -> String {
        
        let iconParameter = getIconParameter(icon: icon)
        
        var toggleParameter = ""
        if toggle {
            toggleParameter = " uk-toggle"
        }
        
        var html = "<a href='" + link + "'" + iconParameter + toggleParameter + ">" + title + "</a>\n"
        
        switch style {
        case .Bold:
            html = "<strong>\n" + html + "</strong>\n"
        default:
            _ = LinkStyle.None
        }
        
        return html
    }
    
}

public struct Field: SWAUIObject {
    
    var title = ""
    var icon: Icon = .None
    var value = ""
    var placeholder = ""
    
    func makeHTML() -> String {
        return "Hellow, World!"
    }
    
}

public struct Text: SWAUIObject {
    
    var text = ""
    
    func makeHTML() -> String {
        return text
    }
    
}

public struct Menu: SWAUIObject {
    
    var contents = [SWAUIObject]()
    var active = 0
    
    func makeHTML() -> String {
        
        var html = ""
        
        var itemsHTML = ""
        
        html += "<ul class='uk-nav uk-nav-default'>\n"
        
        itemsHTML = ""
        var currentIndex = 1
        for content in contents {
            var liClass = ""
            if currentIndex == active {
                liClass = "uk-active"
            }
            itemsHTML += "<li class='" + liClass + "'>" + content.makeHTML() + "</li>\n"
            currentIndex += 1
        }
        
        html += itemsHTML
        
        html += "</ul>\n"
        
        return html
    }
    
}

public struct MenuBar: SWAUIObject {
    
    var contentsLeft = [SWAUIObject]()
    var activeLeft = 0
    var contentsCenter = [SWAUIObject]()
    var activeCenter = 0
    var contentsRight = [SWAUIObject]()
    var activeRight = 0
    
    func makeHTML() -> String {
        
        var html = ""
        
        var itemsHTML = ""
        
        html += "<nav class='uk-navbar-container' uk-navbar>\n" +
            "<div class='uk-navbar-left'>\n" +
        "<ul class='uk-navbar-nav'>\n"
        
        itemsHTML = ""
        var currentIndex = 1
        for content in contentsLeft {
            var liClass = ""
            if currentIndex == activeLeft {
                liClass = "uk-active"
            }
            itemsHTML += "<li class='" + liClass + "'>" + content.makeHTML() + "</li>\n"
            currentIndex += 1
        }
        
        html += itemsHTML
        
        html += "</ul>\n" +
            "</div>\n" +
            "<div class='uk-navbar-center'>\n" +
        "<ul class='uk-navbar-nav'>\n"
        
        itemsHTML = ""
        currentIndex = 1
        for content in contentsCenter {
            var liClass = ""
            if currentIndex == activeCenter {
                liClass = "uk-active"
            }
            itemsHTML += "<li class='" + liClass + "'>" + content.makeHTML() + "</li>\n"
            currentIndex += 1
        }
        
        html += itemsHTML
        
        html += "</ul>\n" +
            "</div>\n" +
            "<div class='uk-navbar-right'>\n" +
        "<ul class='uk-navbar-nav'>\n"
        
        itemsHTML = ""
        currentIndex = 1
        for content in contentsRight {
            var liClass = ""
            if currentIndex == activeRight {
                liClass = "uk-active"
            }
            itemsHTML += "<li class='" + liClass + "'>" + content.makeHTML() + "</li>\n"
            currentIndex += 1
        }
        
        html += itemsHTML
        
        html += "</ul>\n" +
            "</div>\n" +
        "</nav>\n"
        
        return html
    }
    
}

public struct List: SWAUIObject {
    
    var level1Contents = [Int: SWAUIObject]()
    var level2Contents = [Int: [Int: SWAUIObject]]()
    var level3Contents = [Int: [Int: SWAUIObject]]()
    
    func makeHTML() -> String {
        
        var html = "<ul>\n"
        
        for (id, object) in level1Contents {
            html += "<li>\n" + object.makeHTML()
            if let sub1Contents = level2Contents[id] {
                html += "<ul>\n"
                for (sub1ID, sub1Object) in sub1Contents {
                    html += "<li>\n" + sub1Object.makeHTML()
                    if let sub2Contents = level3Contents[sub1ID] {
                        html += "<ul>\n"
                        for (_, sub2Object) in sub2Contents {
                            html += "<li>\n" + sub2Object.makeHTML()
                            // add another structure for level4?
                            html += "</li>\n"
                        }
                        html += "</ul>\n"
                    }
                    html += "</li>\n"
                }
                html += "</ul>\n"
            }
            html += "</li>\n"
        }
        
        html += "</ul>\n"
        
        return html
    }
    
}
