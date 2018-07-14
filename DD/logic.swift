//
//  logic.swift
//  DD
//
//  Created by Vasiliy Kharitonov on 17/04/2018.
//

import Foundation
import Kitura

enum CurrentObjectType {
    case Solution
    case Home
    case Step
    case Connection
    case Scenariot
}

public var bufferDDUsers = [ddUser]()
public var bufferBPMs = [BPM]()
public var bufferSolutions = [Solution]()
public var bufferTags = [Solution]()
public var bufferSteps = [Step]()
public var bufferScenarios = [Scenario]()
public var bufferSystems = [System]()
public var bufferRoles = [Role]()

extension SWAApp {
    
    mutating func processUI(ui: UI) {
        // Fill SWAApp sections
        headerContents.append(contentsOf: ui.header)
        articleContents.append(contentsOf: ui.article)
        sectionContents.append(contentsOf: ui.section)
        footerContents.append(contentsOf: ui.footer)
    }
    
    
    
    // Init used to generate common content for all requests
    mutating func basicInit(request: RouterRequest) {
        
        SWALanguages.append(contentsOf: [ "RU", "IT", "CR", "NL" ])
        
        title = "DD"
        
        // Request parameters
        let bpms  = database.getBPMs()
        cp["bpm"] = request.parameters["bpm"] ?? bpms[0].id
        cp["step"] = request.parameters["step"] ?? ""
        let solutions = database.getSolutions(bpmID: cp["bpm"]!)
        cp["solution"] = request.queryParameters["solution"] ?? solutions[0].id
        let tags = database.getTags(bpmID: cp["bpm"]!)
        cp["tag"] = request.queryParameters["tag"] ?? tags[0].id
        cp["scenario"] = request.queryParameters["scenario"] ?? "all"
        cp["flow"] = request.queryParameters["flow"] ?? "happy"
        cp["lang"] = request.queryParameters["lang"] ?? "EN"
        
        var ui = UI(app: self)
        ui.buildMainMenu(bpms: bpms)
        
        processUI(ui: ui)
        
    }
    
    mutating func buildHome(request: RouterRequest) {
        
        basicInit(request: request)
        
    }
    
    mutating func buildSolution(request: RouterRequest) {
        
        basicInit(request: request)
        
        var ui = UI(app: self)
        
        guard let tagID = cp["tag"] else {
            return
        }
        
        let tags = database.getTags(bpmID: cp["bpm"]!)
        let solutions = database.getSolutions(bpmID: cp["bpm"]!)
        
        // Continue only if we can get current solution
        if let currentSolution = database.getSolution(id: cp["solution"]!) {
            
            // There is a solution filter
            
            currentTitle = currentSolution.name["EN"]!
            
            // Get data from the database
            
            let scenarios = database.getScenarios(tagID: tagID, solutionID: currentSolution.id,  stepID: nil)
            let steps = database.getSteps(tagID: tagID, solutionID: currentSolution.id, scenarioID: nil)
            
            var scenarioSteps = [Step]()
            for scenario in scenarios {
                scenarioSteps.append(contentsOf: database.getSteps(tagID: tagID, solutionID: currentSolution.id, scenarioID: scenario.id))
            }
            
            var stepScenarios = [Scenario]()
            for step in steps {
                stepScenarios.append(contentsOf: database.getScenarios(tagID: tagID, solutionID: currentSolution.id, stepID: step.id))
            }
            
            for stepScenario in stepScenarios {
                scenarioSteps.append(contentsOf: database.getSteps(tagID: tagID, solutionID: currentSolution.id, scenarioID: stepScenario.id))
            }
            
            ui.buildFilters(solutions: solutions, tags: tags, scenarios: scenarios)
            
            ui.buildNavigation(currentSolution: currentSolution, steps: steps, stepScenarios: stepScenarios, scenarios: scenarios, scenarioSteps: scenarioSteps)
            
            ui.buildInformation(currentSolution: currentSolution, currentStep: nil, currentScenario: nil)
            
            ui.buildContent(currentSolution: currentSolution, steps: steps, stepScenarios: stepScenarios, scenarios: scenarios, scenarioSteps: scenarioSteps)
            
        }
        
        processUI(ui: ui)
        
    }
    
    mutating func buildStep(request: RouterRequest) {
        
        basicInit(request: request)
        
        // Continue only if we can get current step and parameters
        guard let currentStep = database.getStep(id: cp["step"]!),
            let currentBPMID = cp["bpm"],
            let currentTagID = cp["tag"] else {
            return
        }
        
        currentTitle = currentStep.name["EN"]!
        
        // Get data from the database
        let tags = database.getTags(bpmID: currentBPMID)
        let solutions = database.getSolutions(bpmID: currentBPMID)
        
        var ui = UI(app: self)
        
        if let currentSolution = database.getSolution(id: cp["solution"]!) {
            var scenarios = [Scenario]()
            for scenarioID in currentStep.scenarioIDs {
                if let scenario = database.getScenario(id: scenarioID) {
                    if scenario.solutionIDs.contains(currentSolution.id) {
                        scenarios.append(scenario)
                    }
                }
            }
            
            let steps = database.getSteps(tagID: currentTagID, solutionID: currentSolution.id, scenarioID: nil)
            
            var scenarioSteps = [Step]()
            for scenario in scenarios {
                scenarioSteps.append(contentsOf: database.getSteps(tagID: currentTagID, solutionID: currentSolution.id, scenarioID: scenario.id))
            }
            
            var stepScenarios = [Scenario]()
            for step in steps {
                stepScenarios.append(contentsOf: database.getScenarios(tagID: currentTagID, solutionID: currentSolution.id, stepID: step.id))
            }
            
            ui.buildFilters(solutions: solutions, tags: tags, scenarios: scenarios)
            
            ui.buildNavigation(currentSolution: currentSolution, steps: steps, stepScenarios: stepScenarios, scenarios: scenarios, scenarioSteps: scenarioSteps)
            
            ui.buildContent(currentSolution: currentSolution, steps: steps, stepScenarios: stepScenarios, scenarios: scenarios, scenarioSteps: scenarioSteps)
            
        }
        
        processUI(ui: ui)
        
    }
    
    mutating func buildScenario(request: RouterRequest) {
        
    }
    
    mutating func buildConnection(request: RouterRequest) {
        
    }
    
    mutating func addStep(request: RouterRequest) {
        
        basicInit(request: request)
        
        currentTitle = "Adding a new Step"
        
        // Continue only if we can get current step and parameters
        guard let currentBPMID = cp["bpm"],
            let currentSolutionID = cp["solution"],
            let currentTagID = cp["tag"] else {
                return
        }
        
        var ui = UI(app: self)

        let tags = database.getTags(bpmID: currentBPMID)
        let solutions = database.getSolutions(bpmID: currentBPMID)
        let scenarios = database.getScenarios(tagID: currentTagID, solutionID: currentSolutionID,  stepID: nil)
        
        ui.buildFilters(solutions: solutions, tags: tags, scenarios: scenarios)
        
        ui.buildAddingStepForm(solutions: solutions, tags: tags, scenarios: scenarios)
        
        processUI(ui: ui)
        
    }
    
    mutating func saveStep(request: RouterRequest) {
        
        
        
    }
    
}
