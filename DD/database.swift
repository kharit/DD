//
//  database.swift
//  DD
//
//  Created by Vasiliy Kharitonov on 20/04/2018.
//

import Foundation

extension Database {
    
    func getBPM(id: String) -> BPM? {
        
        var bpm: BPM? = nil
        
        let bpmsDB = couchDBClient.database("bpms")
        
        bpmsDB.retrieve(id) {
            document, error in
            
            if let document = document, error == nil {
                bpm = BPM(document)
            } else {
                print(error!)
            }
        }
        
        return bpm
        
    }
    
    func getBPMs() -> [BPM] {
        
        let bpmsDB = couchDBClient.database("bpms")
        
        var bpms = [BPM]()
        
        bpmsDB.retrieveAll(includeDocuments: true) {
            document, error in
            
            if let document = document, error == nil {
                bpms = parseBPMs(document)
            } else {
                print(error!)
            }
        }
        
        return bpms
        
    }
    
    func getSolution(id: String) -> Solution? {
        
        var solution: Solution? = nil
        
        let solutionsDB = couchDBClient.database("solutions")
        
        solutionsDB.retrieve(id) {
            document, error in
            
            if let document = document, error == nil {
                solution = Solution(document)
            } else {
                print(error!)
            }
        }
        
        return solution
        
    }
    
    func getSolutions(bpmID: String) -> [Solution] {
        
        let solutionsDB = couchDBClient.database("solutions")
        
        var solutions = [Solution]()
        
        solutionsDB.retrieveAll(includeDocuments: true) {
            document, error in
            
            if let document = document, error == nil {
                solutions = parseSolutions(document)
            } else {
                print(error!)
            }
        }
        
        // Filter solutions
        solutions = solutions.filter( { $0.bpmID == bpmID })
        
        return solutions
        
    }
    
    func getTags(bpmID: String) -> [Tag] {
        
        let tagsDB = couchDBClient.database("tags")
        
        var tags = [Tag]()
        
        tagsDB.retrieveAll(includeDocuments: true) {
            document, error in
            
            if let document = document, error == nil {
                tags = parseTags(document)
            } else {
                print(error!)
            }
        }
        
        tags = tags.filter( { $0.bpmID == bpmID })
        
        return tags
        
    }
    
    func getScenario(id: String) -> Scenario? {
        
        var scenario: Scenario? = nil
        
        let scenariosDB = couchDBClient.database("scenarios")
        
        scenariosDB.retrieve(id) {
            document, error in
            
            if let document = document, error == nil {
                scenario = Scenario(document)
            } else {
                print(error!)
            }
        }
        
        return scenario
        
    }
    
    func getScenarios(tagID: String, solutionID: String?, stepID: String?) -> [Scenario] {
        
        let scenariosDB = couchDBClient.database("scenarios")
        
        var scenarios = [Scenario]()
        
        scenariosDB.retrieveAll(includeDocuments: true) {
            document, error in
            
            if let document = document, error == nil {
                scenarios = parseScenarios(document)
            } else {
                print(error!)
            }
        }
        
        /* View testing here
        scenariosDB.queryByView("standard-view", ofDesign: "standardDesignDoc", usingParameters: [.includeDocs(true), .keys([["0a4e837510bfc91fade30170c70070e6"] as AnyObject])]) {
            document, error in
            
            if let document = document, error == nil {
                print(document)
                scenarios = parseScenarios(document)
            } else {
                print(error!)
            }
        }*/
        
        
        // Filtering is below. Changed it to filter based on views?
        scenarios = scenarios.filter( {
            //Closure for filtering
            var suitable = true
            let scenario = $0
            // Tag
            if !scenario.tagIDs.contains(tagID) {
                suitable = false
            }
            // Solution?
            if let solutionID = solutionID {
                if !scenario.solutionIDs.contains(solutionID) {
                    suitable = false
                }
            }
            // StepID?
            if scenario.highLevelStepID != stepID {
                suitable = false
            }
            return suitable
        })

        return scenarios
        
    }
    
    func getStep(id: String) -> Step? {
        
        var step: Step? = nil
        
        let stepDB = couchDBClient.database("solutions")
        
        stepDB.retrieve(id) {
            document, error in
            
            if let document = document, error == nil {
                step = Step(document)
            } else {
                print(error!)
            }
        }
        
        return step
        
    }
    
    func getSteps(tagID: String, solutionID: String?, scenarioID: String?) -> [Step] {
        
        let stepsDB = couchDBClient.database("steps")
        
        var steps = [Step]()
        
        stepsDB.retrieveAll(includeDocuments: true) {
            document, error in
            
            if let document = document, error == nil {
                steps = parseSteps(document)
            } else {
                print(error!)
            }
        }
        
        // Filter. Change it to based on view?
        steps = steps.filter( {
            //Closure for filtering
            var suitable = true
            let step = $0
            // Tag
            if !step.tagIDs.contains(tagID) {
                suitable = false
            }
            // Solution?
            if let solutionID = solutionID {
                if !step.solutionIDs.contains(solutionID) {
                    suitable = false
                }
            }
            // Scenario?
            if let scenarioID = scenarioID {
                if !step.scenarioIDs.contains(scenarioID) {
                    suitable = false
                }
            } else {
                if step.scenarioIDs.count > 0 {
                    suitable = false
                }
            }
            return suitable
        })
        
        return steps
        
    }
    
}
