//
//  CouchDB.swift
//  SWAKit
//
//  Created by Vasiliy Kharitonov on 20/04/2018.
//

import Foundation
import CouchDB

public struct Database {
    
    let connProperties: ConnectionProperties
    let couchDBClient: CouchDBClient
    
    init(host: String, port: Int16, username: String, password: String) {
        
        self.connProperties = ConnectionProperties(
            host: host,  // httpd address
            port: port,         // httpd port
            secured: false,     // https or http
            username: username,      // admin username
            password: password       // admin password
        )
        
        self.couchDBClient = CouchDBClient(connectionProperties: self.connProperties)
        
    }
    
}
