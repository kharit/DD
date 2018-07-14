//
//  data.swift
//  Application
//
//  Created by Vasiliy Kharitonov on 17/04/2018.
//

import Foundation
import SwiftyJSON

// Protocol for the objects, that should be approvable
protocol Approvable {
    
    // No People who should approve by default
    var toBeApprovedBy: [ddUser]? { get set }
    
    // No People who already approved by default
    var approvedBy: [ddUser]? { get set }
    
    // No approval flow by default
    var approvalFlow: [Int: ddUser]? { get set }
    
}

// Represents a physical person
public struct ddUser: SWAData, Approvable {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var company: String
    var position: String
    var projectPosition: String? = nil
    var currentLoginAttempts: Int
    var locked: Bool
    
    // Calculated properties
    
}

// Business Process Model. Multilevel structure, which represents all the steps for connected processes.
public struct BPM: SWAData, Approvable {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    init?(_ bpmJSON: JSON) {
        
        guard let id = bpmJSON["_id"].string,
            let changedAt = bpmJSON["changedAt"].string,
            let changedBy = bpmJSON["changedBy"].string else {
                return nil
        }
        
        let nameJSON = bpmJSON["name"]
        self.name = parseLangText(nameJSON)
        
        self.id = id
        self.version = ""
        
        self.changedAt = changedAt
        self.changedBy = changedBy
        self.toBeApprovedBy = nil
        self.approvedBy = nil
        self.approvalFlow = nil
        
    }
    
}

public func parseBPMs(_ document: JSON) -> [BPM] {
    
    guard let rows = document["rows"].array else {
        return [BPM]()
    }
    
    let bpms: [BPM] = rows.compactMap {
        let bpmJSON = $0["doc"]
        guard let bpm = BPM(bpmJSON) else {
            return nil
        }
        return bpm
    }
    return bpms
    
}

public struct Solution: SWAData, Approvable {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    var title: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    
    // Prefix for step codes. Needed to create nice looking step codes.
    var codePrefix = ""
    
    // Business Process Model
    var bpmID: String
    
    // Connection to scenarios defined in Scenarios
    
    var foreword = [String:String]()
    var afterword = [String:String]()
    
    // Solutions are always created for JSON parsing
    init?(_ solutionJSON: JSON) {
        
        guard let id = solutionJSON["_id"].string,
            let changedAt = solutionJSON["changedAt"].string,
            let changedBy = solutionJSON["changedBy"].string,
            let bpmID = solutionJSON["bpmID"].string,
            let codePrefix = solutionJSON["codePrefix"].string else {
                return nil
        }
        
        let nameJSON = solutionJSON["name"]
        self.name = parseLangText(nameJSON)
        
        let titleJSON = solutionJSON["title"]
        self.title = parseLangText(titleJSON)
        
        self.id = id
        self.version = ""
        
        self.changedAt = changedAt
        self.changedBy = changedBy
        self.toBeApprovedBy = nil
        self.approvedBy = nil
        self.approvalFlow = nil
        
        self.codePrefix = codePrefix
        self.bpmID = bpmID
        
    }
}

public func parseSolutions(_ document: JSON) -> [Solution] {
    
    guard let rows = document["rows"].array else {
        return [Solution]()
    }
    
    let solutions: [Solution] = rows.compactMap {
        let solutionJSON = $0["doc"]
        guard let solution = Solution(solutionJSON) else {
            return nil
        }
        return solution
    }
    return solutions
    
}

// Tags are used to determine if the object is Global or local for some country (or several countries). If the object is global, the tags for the countries still should be provided.
public struct Tag:SWAData {
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String : String]
    var changedAt: String
    var changedBy: String
    var bpmID = ""
    
    init?(_ tagJSON: JSON) {
        
        guard let id = tagJSON["_id"].string,
            let changedAt = tagJSON["changedAt"].string,
            let changedBy = tagJSON["changedBy"].string,
            let bpmID = tagJSON["bpmID"].string else {
                return nil
        }
        
        let nameJSON = tagJSON["name"]
        self.name = parseLangText(nameJSON)
        
        self.id = id
        self.version = ""
        
        self.changedAt = changedAt
        self.changedBy = changedBy
        self.bpmID = bpmID

    }
}

public func parseTags(_ document: JSON) -> [Tag] {
    
    guard let rows = document["rows"].array else {
        return [Tag]()
    }
    
    let tags: [Tag] = rows.compactMap {
        let tagJSON = $0["doc"]
        guard let tag = Tag(tagJSON) else {
            return nil
        }
        return tag
    }
    return tags
    
}

protocol Tags {
    var tagIDs: [String] { get set }
}

public struct Scenario: SWAData, Approvable, Tags {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String : String]
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    // Tags protocol
    var tagIDs: [String]
    
    // Scenario can be relevant for several solutions
    var solutionIDs = [String]()
    
    // Business Process Model
    var bpmID: String
    
    // Higher level step in BPM if exists
    var highLevelStepID: String?
    
    // Connection to steps defined in Steps
    
    init?(_ scenarioJSON: JSON) {
        
        guard let id = scenarioJSON["_id"].string,
            let changedAt = scenarioJSON["changedAt"].string,
            let changedBy = scenarioJSON["changedBy"].string,
            let bpmID = scenarioJSON["bpmID"].string else {
                return nil
        }

        let nameJSON = scenarioJSON["name"]
        self.name = parseLangText(nameJSON)
        
        self.tagIDs = [String]()
        if let tagsJSON = scenarioJSON["tagIDs"].array {
            for tagJSON in tagsJSON {
                if let tagID = tagJSON.string  {
                    self.tagIDs.append(tagID)
                }
            }
        }
        
        if let solutions = scenarioJSON["solutionIDs"].array {
            for solution in solutions {
                if let solutionID = solution.string {
                    self.solutionIDs.append(solutionID)
                }
            }
        }
        
        if let highLevelStepID = scenarioJSON["highLevelStepID"].string {
            self.highLevelStepID = highLevelStepID
        }
        
        self.id = id
        self.version = ""
        
        self.changedAt = changedAt
        self.changedBy = changedBy
        self.bpmID = bpmID
        
    }
    
}

public func parseScenarios(_ document: JSON) -> [Scenario] {
    
    guard let rows = document["rows"].array else {
        return [Scenario]()
    }
    
    let scenarios: [Scenario] = rows.compactMap {
        let scenarioJSON = $0["doc"]
        guard let scenario = Scenario(scenarioJSON) else {
            return nil
        }
        return scenario
    }
    return scenarios
    
}

public var StepTypes = [ "manualStep", "automatedStep", "start", "end", "decisionPoint"  ]

// Basic part of the process. Represents block on the flow chart and a section in the document
public struct Step: SWAData, Approvable, Tags {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String : String]
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    // Tags protocol
    var tagIDs: [String]
    
    // Business Process Model
    var bpmID: String
    
    // Step can be relevant for  several solutions
    var solutionIDs: [String]
    
    // Step can be relevant for several scenarios
    var scenarioIDs: [String]
    
    // StepType is a regular manual step by default
    var stepType = "manualStep"
    
    // Badge for use in flows. Can contain transaction code for example
    var badge: String? = nil
    
    var connectionIDs: [String]
    
    // Markdown
    var processDescription: [String: String]
    
    // Markdown
    var technicalDescription: [String: String]
    
    // Decide on this. Is it really needed
    var foreword: [String: String]? = nil // Depending on scenarioID?
    var afterword: [String: String]? = nil // Depending on scenation ID?
    
    // Key User instruction, Markdown
    var KUInstruction: [String: String]? = nil
    
    // If no Role is provided, a System will be considered as a Role
    var roleID: String?
    
    // If no System is provided, the Step will be considered as cross-system
    var systemID: String?
    
    init?(_ stepJSON: JSON) {
        
        guard let id = stepJSON["_id"].string,
            let changedAt = stepJSON["changedAt"].string,
            let changedBy = stepJSON["changedBy"].string,
            let bpmID = stepJSON["bpmID"].string,
            let stepType = stepJSON["stepType"].string else {
                return nil
        }
        
        let nameJSON = stepJSON["name"]
        self.name = parseLangText(nameJSON)
        
        let processDescriptionJSON = stepJSON["processDescription"]
        self.processDescription = parseLangText(processDescriptionJSON)
        
        let technicalDescriptionJSON = stepJSON["technicalDescription"]
        self.technicalDescription = parseLangText(technicalDescriptionJSON)
        
        // ADD OTHER PARAMETERS
        
        self.solutionIDs = [String]()
        if let solutions = stepJSON["solutionIDs"].array {
            for solution in solutions {
                if let solutionID = solution.string {
                    self.solutionIDs.append(solutionID)
                }
            }
        }
        
        self.tagIDs = [String]()
        if let tags = stepJSON["tagIDs"].array {
            for tag in tags {
                if let tagID = tag.string {
                    self.tagIDs.append(tagID)
                }
            }
        }
        
        self.scenarioIDs = [String]()
        if let scenarios = stepJSON["scenarioIDs"].array {
            for scenario in scenarios {
                if let scenarioID = scenario.string {
                    self.scenarioIDs.append(scenarioID)
                }
            }
        }
        
        self.connectionIDs = [String]()
        if let connections = stepJSON["connectionIDs"].array {
            for connection in connections {
                if let connectionID = connection.string {
                    self.connectionIDs.append(connectionID)
                }
            }
        }
        
        self.id = id
        self.version = ""
        
        self.changedAt = changedAt
        self.changedBy = changedBy
        self.bpmID = bpmID
        self.stepType = stepType
        
        if let badge = stepJSON["badge"].string {
            self.badge = badge
        }
        
        if let roleID = stepJSON["roleID"].string {
            self.roleID = roleID
        } else {
            self.roleID = nil
        }
        
        if let systemID = stepJSON["systemID"].string {
            self.systemID = systemID
        } else {
            self.systemID = nil
        }
        
    }
    
}

public func parseSteps(_ document: JSON) -> [Step] {
    
    guard let rows = document["rows"].array else {
        return [Step]()
    }
    
    var steps = [Step]()
    
    for row in rows {
        let stepJSON = row["doc"]
        if let step = Step(stepJSON) {
            steps.append(step)
        }
    }
    
    return steps
    
}

enum ConnectionType {
    case Happy // The most common way of the process, 80% cases happen this way. Came from "Happy flow" - scenario without exceptions, which inludes only happy connections.
    case Regular
    case Exception
    case Interface
}

// Connection tells about sequence of steps. Used for both documents and flow charts. Also defines happy flows and exceptions.
struct Connection: SWAData, Approvable, Tags {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    // Tags protocol
    var tagIDs: [String]
    
    // Connection is considered as Happy by default
    var connectionType = ConnectionType.Happy
    
    var fromID: String
    var toID: String
    
    // No condition by default
    var condition: String? = nil

}

// Role represent responsible for step execution. Will be used to draw flows.
public struct Role: SWAData, Approvable {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    // Calculated properties
    // Hashable protocol
    public var hashValue: Int { return self.id.hashValue }
    
}

public struct System: SWAData, Approvable {
    
    //  SWAData Protocol
    let id: String
    var version: String = ""
    var name: [String: String] // First string is used to define language. We stoped used custom enumeration because of extra complexity for coding interface for database
    var changedAt: String
    var changedBy: String
    
    // Approvable Protocol
    var toBeApprovedBy: [ddUser]? = nil
    var approvedBy: [ddUser]? = nil
    var approvalFlow: [Int : ddUser]? = nil
    
    // Calculated properties
    
}

func parseLangText(_ langTextJSON: JSON) -> [String: String] {
    
    var returnCollection = [String: String]()
    825309825309
    for lang in SWALanguages {
        if let text = langTextJSON[lang].string {
            returnCollection[lang] = text
        }
    }
    
    return returnCollection
    
}
