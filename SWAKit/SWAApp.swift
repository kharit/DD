//
//  SWAApp.swift
//  SWAKit
//
//  Created by Vasiliy Kharitonov on 20/04/2018.
//

import Foundation

// Main Application Structure
public struct SWAApp {
    
    var title = ""
    var currentTitle = ""
    let database: Database
    
    //CSS
    let css = [ "https://cdnjs.cloudflare.com/ajax/libs/uikit/3.0.0-beta.42/css/uikit.min.css" ]
    
    //JavaScript
    let js = [ "https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js",
               "https://cdnjs.cloudflare.com/ajax/libs/uikit/3.0.0-beta.42/js/uikit.min.js",
               "https://cdnjs.cloudflare.com/ajax/libs/uikit/3.0.0-beta.42/js/uikit-icons.min.js" ]
    
    var headerContents = [SWAUIObject]()
    var articleContents = [SWAUIObject]()
    var sectionContents = [SWAUIObject]()
    var footerContents = [SWAUIObject]()
    
    // custom parameters
    var cp = [String: String]()
    
    func makeHTMLBody() -> String {
        //Makes full HTML5 body
        
        var htmlBody = ""
        
        //Creation of CSS structure
        var cssHTML = ""
        for cssLine in css {
            cssHTML += "<link rel='stylesheet' href='" + cssLine + "' />\n"
        }
        
        //Creation of JavaScript structure
        var jsHTML = ""
        for jsLine in js {
            jsHTML += "<script src='" + jsLine + "'></script>\n"
        }
        
        //Creation of HTML for the top of the document
        let preContent = "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='utf-8'>" +
            "<title>" +
            currentTitle +
            " | " +
            title +
            "</title>" +
            cssHTML +
            jsHTML +
            "</head>" +
        "<body>"
        
        //Creaction of HTML for the bottom of the document
        let postContent = "</body>" +
        "</html>"
        
        htmlBody += preContent
        
        // Header
        var header = ""
        header += "<header>\n"
        for headerContent in headerContents {
            header += headerContent.makeHTML()
        }
        header += "</header>\n"
        htmlBody += header
        
        // Main grid section
        htmlBody += "<div class='uk-grid-small' uk-grid>\n" +
            "<div class='uk-width-1-3'><div class='uk-card uk-card-small uk-card-body'>\n"
        
        // Section
        var section = ""
        section += "<section>\n"
        for sectionContent in sectionContents {
            section += sectionContent.makeHTML()
        }
        section += "</section>\n"
        htmlBody += section
        
        // Main grid article
        htmlBody += "</div></div><div class='uk-width-2-3'><div class='uk-card uk-card-small uk-card-body'>\n"
        
        // Article
        var article = ""
        article += "<article class='uk-article'>\n"
        for articleContent in articleContents {
            article += articleContent.makeHTML()
        }
        article += "</article>\n"
        htmlBody += article
        
        // Main grid end
        htmlBody += "</div></div></div>\n"
        
        // Footer
        var footer = ""
        footer += "<footer class='uk-padding'>\n"
        for footerContent in footerContents {
            footer += footerContent.makeHTML()
        }
        footer += "</footer>\n"
        htmlBody += footer
        
        htmlBody += postContent
        
        return htmlBody
    }
    
    func makeHTTPResponse() -> String {
        //Makes full HTTP Response ready to send
        
        var httpResponse = ""
        let responseBody = self.makeHTMLBody()
        
        httpResponse += "HTTP/1.0 200 OK\n"
        httpResponse += "Content-Type: text/html\n"
        
        httpResponse += "Content-Length: \(responseBody.count) \n\n"
        httpResponse += responseBody
        
        return httpResponse
    }
    
    init(database: Database) {
        self.database = database
    }
    
}
