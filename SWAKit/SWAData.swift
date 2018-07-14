//
//  SWAData.swift
//  SWAKit
//
//  Created by Vasiliy Kharitonov on 17/04/2018.
//

import Foundation

public var SWALanguages = [ "EN" ]

// SWAKit Data Objects
protocol SWAData: Hashable {

    var id: String { get }
    var version: String { get } // Another unique id. All changes are stored in the database. "" is the default (current).
    var name: [String: String] { get set } // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String { get set }
    var changedBy: String { get set }
    
    // No cross-code to be provided here. Use unique IDs (above) or generate codes on the fly. Cross-process Codes are not consistent enough to be a constant reference.
    
}

// This extension uses unique id (string) hashValues to fill hashValues for SWAKit Data Objects
extension SWAData {
    public var hashValue: Int {
        return self.id.hashValue
    }
}
