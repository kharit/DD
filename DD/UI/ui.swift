//
//  ui.swift
//  Application
//
//  Created by Vasiliy Kharitonov on 20/04/2018.
//

import Foundation

enum LinkType {
    case Home
    case BPM
    case Solution
    case Language
    case Tag
    case Scenario
    case Flow
    case Step
    case AddStep
}

//This structure is used for output of all the data to users
public struct UI {
    
    var header = [SWAUIObject]()
    var article = [SWAUIObject]()
    var section = [SWAUIObject]()
    var footer = [SWAUIObject]()
    
    let app: SWAApp
    let database: Database
    
    mutating func buildMainMenu(bpms: [BPM]) {
        
        let activeBPMID = app.cp["bpm"] ?? ""
        let lang = app.cp["lang"] ?? "EN"
        
        var mainMenu = MenuBar()
        
        var homeLink = Link()
        homeLink.icon = .Home
        homeLink.link = createLink(link: "/", type: .Home)
        mainMenu.contentsLeft.append(homeLink)
        
        var logoutLink = Link()
        logoutLink.title = "KhariV01 "
        logoutLink.icon = .SignOut
        logoutLink.link = "#under-development"
        mainMenu.contentsLeft.append(logoutLink)
        
        var activeNumber = 0
        var currentNumber = 1
        for bpm in bpms {
            
            var bpmLink = Link()
            bpmLink.title = getLangText(bpm.name)
            bpmLink.link = createLink(link: bpm.id, type: .BPM)
            mainMenu.contentsCenter.append(bpmLink)
            
            // calculate active item in menu
            if bpm.id == activeBPMID {
                activeNumber = currentNumber
            } else {
                currentNumber += 1
            }
        }
        
        // Set active item in menu
        if activeNumber == 0 {
            mainMenu.activeLeft = 1
        } else {
            mainMenu.activeCenter = activeNumber
        }
        
        /* Add BPM link
        var addBPMLink = Link()
        addBPMLink.icon = .Plus
        addBPMLink.link = "#"
        mainMenu.contentsCenter.append(addBPMLink)*/
        
        /*var textSeparator = Text()
        textSeparator.text = "<p>|</p>"
        mainMenu.contentsCenter.append(textSeparator)*/
        
        var createRTF = Link()
        createRTF.title = "RTF"
        createRTF.link = "#under-development"
        createRTF.toggle = true
        mainMenu.contentsRight.append(createRTF)
        
        var createPDF = Link()
        createPDF.title = "PDF"
        createPDF.link = "#under-development"
        createPDF.toggle = true
        mainMenu.contentsRight.append(createPDF)
        
        // Languages
        switch lang {
        case "RU":
            mainMenu.activeRight = 4
        default:
            mainMenu.activeRight = 3 // EN
        }
        
        var enLink = Link()
        enLink.title = "EN"
        enLink.link = createLink(link: "EN", type: .Language)
        mainMenu.contentsRight.append(enLink)
        
        /* var ruLink = Link()
         ruLink.title = "RU"
         ruLink.link = createLink(link: "RU", type: .Language)
         mainMenu.contentsRight.append(ruLink) */
        
        /* Add lang link
        var addLangLink = Link()
        addLangLink.icon = .Plus
        addLangLink.link = "#"
        mainMenu.contentsRight.append(addLangLink)*/
        
        // Fill SWAApp sections
        header.append(mainMenu)
        
        var footerText = Text()
        footerText.text = "<p class='uk-text-center uk-text-small'>DD — Global solution for Document Design</p>\n"
        self.footer.append(footerText)
        
        var underDevelopmentText = Text()
        underDevelopmentText.text = "<div id='under-development' uk-modal>\n" +
            "<div class='uk-modal-dialog uk-margin-auto-vertical uk-modal-body'>\n" +
            "<h2 class='uk-modal-title'>Under Development</h2>\n" +
            "<p>Sorry, this feature is still under development. If you want to support the development of this product, please contact Vasiliy Kharitonov.</p>\n" +
            "<p class='uk-text-right'>\n" +
            "<button class='uk-button uk-button-default uk-modal-close' type='button'>Close</button>\n" +
            "</p>\n" +
            "</div>\n" +
            "</div>"
        footer.append(underDevelopmentText)
    }
    
    mutating func buildFilters(solutions: [Solution], tags: [Tag], scenarios: [Scenario]) {
        
        // Request parameters
        let activeSolutionID = app.cp["solution"]!
        let activeTagID = app.cp["tag"]!
        let activeScenarioID = app.cp["scenario"]!
        let activeFlowID = app.cp["flow"]!
        let activeLangID = app.cp["lang"]!
        
        // Languages processing (Demo)
        var solutionsTitle = "Solutions"
        var tagsTitle = "Tags"
        var scenariosTitle = "Scenarios"
        var allText = "All"
        var flowsTitle = "Flows"
        switch activeLangID {
        case "RU":
            solutionsTitle = "Решения"
            tagsTitle = "Тэги"
            scenariosTitle = "Сценарии"
            allText = "Все"
            flowsTitle = "Потоки"
        default:
            _ = "do nothing"
        }
        
        var navGrid = Grid()
        navGrid.columns = 4
        
        // Solutions
        var solutionBlock = Block()
        
        var solutionGrid = Grid()
        solutionGrid.columns = 2
        
        var solutionText = Text()
        solutionText.text = "<h4 class='uk-text-right'>" + solutionsTitle + "</h4>"
        solutionGrid.contents.append(solutionText)
        
        var solutionMenu = Menu()
        
        var currentNumber = 1
        for solution in solutions {
            
            var solutionLink = Link()
            solutionLink.title = getLangText(solution.name)
            solutionLink.link = createLink(link: solution.id, type: .Solution)
            solutionMenu.contents.append(solutionLink)
            
            // calculate active item in menu
            if solution.id == activeSolutionID {
                solutionMenu.active = currentNumber
            }
            currentNumber += 1
            
        }
        
        /* Add solution
         var addSolutionLink = Link()
         addSolutionLink = .Plus
         addSolutionLink.link = "#"
         tagMenu.contents.append(addSolutionLink)*/
        
        solutionGrid.contents.append(solutionMenu)
        solutionBlock.contents.append(solutionGrid)
        
        navGrid.contents.append(solutionBlock)
        
        // Tags
        var tagBlock = Block()
        
        var tagGrid = Grid()
        tagGrid.columns = 2
        
        var tagText = Text()
        tagText.text = "<h4 class='uk-text-right'>" + tagsTitle + "</h4>"
        tagGrid.contents.append(tagText)
        
        var tagMenu = Menu()
        
        currentNumber = 1
        for tag in tags {
            
            var tagLink = Link()
            tagLink.title = getLangText(tag.name)
            tagLink.link = createLink(link: tag.id, type: .Tag)
            tagMenu.contents.append(tagLink)
            
            // calculate active item in menu
            if tag.id == activeTagID {
                tagMenu.active = currentNumber
            }
            currentNumber += 1
            
        }
        
        /* Add tag
        var addTagLink = Link()
        addTagLink.icon = .Plus
        addTagLink.link = "#"
        tagMenu.contents.append(addTagLink)*/
        
        tagGrid.contents.append(tagMenu)
        tagBlock.contents.append(tagGrid)
        
        navGrid.contents.append(tagBlock)
        
        
        // Flows
        var flowBlock = Block()
        
        var flowGrid = Grid()
        flowGrid.columns = 2
        
        var flowText = Text()
        flowText.text = "<h4 class='uk-text-right'>" + flowsTitle + "</h4>"
        flowGrid.contents.append(flowText)
        
        var flowMenu = Menu()
        switch activeFlowID {
        case "regular":
            flowMenu.active = 2
        case "exception":
            flowMenu.active = 3
        default:
            flowMenu.active = 1
        }
        
        var happyLink = Link()
        happyLink.title = "Happy"
        happyLink.link = createLink(link: "happy", type: .Flow)
        flowMenu.contents.append(happyLink)
        
        var regularLink = Link()
        regularLink.title = "Regular"
        regularLink.link = createLink(link: "regular", type: .Flow)
        flowMenu.contents.append(regularLink)
        
        var exceptionLink = Link()
        exceptionLink.title = "Exception"
        exceptionLink.link = createLink(link: "exception", type: .Flow)
        flowMenu.contents.append(exceptionLink)
        
        flowGrid.contents.append(flowMenu)
        flowBlock.contents.append(flowGrid)
        
        navGrid.contents.append(flowBlock)
        
        
        // Scenarios
        var scenarioBlock = Block()
        //scenarioBlock.title = "Scenarios"
        
        var scenarioGrid = Grid()
        scenarioGrid.columns = 2
        
        var scenarioText = Text()
        scenarioText.text = "<h4 class='uk-text-right'>" + scenariosTitle + "</h4>"
        scenarioGrid.contents.append(scenarioText)
        
        var scenarioMenu = Menu()
        
        var allLink = Link()
        allLink.title = allText
        allLink.link = createLink(link: "all", type: .Scenario)
        scenarioMenu.contents.append(allLink)
        
        scenarioMenu.active = 1
        currentNumber = 2
        for scenario in scenarios {
            
            var scenarioLink = Link()
            scenarioLink.title = getLangText(scenario.name)
            scenarioLink.link = createLink(link: scenario.id, type: .Scenario)
            scenarioMenu.contents.append(scenarioLink)
            
            // calculate active item in menu
            if scenario.id == activeScenarioID {
                scenarioMenu.active = currentNumber
            }
            currentNumber += 1
            
        }
        
        var addSceLink = Link()
        addSceLink.icon = .Plus
        addSceLink.link = "#under-development"
        addSceLink.toggle = true
        scenarioMenu.contents.append(addSceLink)
        
        scenarioGrid.contents.append(scenarioMenu)
        scenarioBlock.contents.append(scenarioGrid)
        
        navGrid.contents.append(scenarioBlock)
        
        
        var navigationDivider = Text()
        navigationDivider.text = "<hr>\n"
        
        header.append(navGrid)
        header.append(navigationDivider)
        
    }
    
    mutating func buildNavigation(currentSolution: Solution?, steps: [Step], stepScenarios: [Scenario], scenarios: [Scenario], scenarioSteps: [Step])  {
        
        // Add buttons
        
        var addStepButton = Button()
        addStepButton.title = "Add Step"
        addStepButton.link = createLink(link: "", type: .AddStep)
        addStepButton.size = .Small
        addStepButton.style = .Default
        section.append(addStepButton)
        
        var addScenarioButton = Button()
        addScenarioButton.title = "Add Scenario"
        addScenarioButton.link = "#under-development"
        addScenarioButton.toggle = true
        addScenarioButton.size = .Small
        addScenarioButton.style = .Default
        section.append(addScenarioButton)
        
        var separatorText = Text()
        separatorText.text = "<br><br>\n"
        section.append(separatorText)
        
        // Solution Navigation
        
        if let currentSolution = currentSolution {
            var solutionLink = Link()
            solutionLink.title = getLangText(currentSolution.name)
            solutionLink.style = .Bold
            solutionLink.link = createLink(link: currentSolution.id, type: .Solution)
            self.section.append(solutionLink)
        }

        var currentNavigationList = List()
        
        var currentTopIndex: Int
        
        // Build top-level Scenarios
        currentTopIndex = 1
        for scenario in scenarios {
            var scenarioLink = Link()
            scenarioLink.title = getLangText(scenario.name)
            scenarioLink.link = createLink(link: scenario.id, type: .Scenario)
            currentNavigationList.level1Contents[currentTopIndex] = scenarioLink
            // Create links for subscenarios
            var currentSubIndex = 1
            for scenarioStep in scenarioSteps where scenarioStep.scenarioIDs.contains(scenario.id) {
                var scenarioStepLink = Link()
                scenarioStepLink.title = getLangText(scenarioStep.name)
                scenarioStepLink.link = createLink(link: scenario.id, type: .Step, scenarioID: scenarioStep.id)
                currentNavigationList.level2Contents[currentTopIndex] = [currentSubIndex: scenarioStepLink]
                currentSubIndex += 1
            }
            currentTopIndex += 1
        }
        
        // Build top-level Steps
        currentTopIndex = 1
        for step in steps {
            var stepLink = Link()
            stepLink.title = getLangText(step.name)
            stepLink.link = createLink(link: step.id, type: .Step)
            currentNavigationList.level1Contents[currentTopIndex] = stepLink
            // Create links for subscenarios
            var currentSubIndex = 1
            for stepScenario in stepScenarios where stepScenario.highLevelStepID == step.id {
                var stepScenarioLink = Link()
                stepScenarioLink.title = getLangText(stepScenario.name)
                stepScenarioLink.link = createLink(link: step.id, type: .Scenario, scenarioID: stepScenario.id)
                currentNavigationList.level2Contents[currentTopIndex] = [currentSubIndex: stepScenarioLink]
                currentSubIndex += 1
            }
            currentTopIndex += 1
        }
        
        self.section.append(currentNavigationList)
        
    }
    
    mutating func buildInformation(currentSolution: Solution?, currentStep: Step?, currentScenario: Scenario?) {
        
        if let solution = currentSolution {
            
            var informationText = Text()
            informationText.text = "<h4>Information about solution \(solution.name["EN"]!)</h4>\n" +
                "<table class='uk-table uk-table-small'>" +
                "<tbody>" +
                "<tr>" +
                "<td>ID</td>" +
                "<td>\(solution.id)" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td>Title</td>" +
                "<td>\(getLangText(solution.title))" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td>Prefix</td>" +
                "<td>\(solution.codePrefix)" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td>Changed</td>" +
                "<td>\(solution.changedAt) (\(solution.changedBy))</td>" +
                "</tr>" +
                "<tr>" +
                "<td>To be approved</td>" +
                "<td>" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td>Approved by</td>" +
                "<td>" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td>Revisions</td>" +
                "<td>" +
                "</td>" +
                "</tr>" +
                "</tbody>" +
                "</table>"
            
            section.append(informationText)
            
        } else if let step = currentStep {
            
            
            
        } else if let scenario = currentScenario {
            
            
            
        }
        
    }
    
    mutating func buildContent(currentSolution: Solution?, steps: [Step], stepScenarios: [Scenario], scenarios: [Scenario], scenarioSteps: [Step]) {
        
        // If this is solution, then process it as a solution
        if let solution = currentSolution {
            
            var editButton = Button()
            editButton.title = "Edit Solution"
            editButton.link = "#under-development"
            editButton.toggle = true
            editButton.size = .Small
            editButton.style = .Default
            article.append(editButton)
            
            var approveButton = Button()
            approveButton.title = "Approve"
            approveButton.link = "#under-development"
            approveButton.toggle = true
            approveButton.size = .Small
            approveButton.style = .Primary
            article.append(approveButton)
            
            var commentButton = Button()
            commentButton.title = "Comment"
            commentButton.link = "#under-development"
            commentButton.toggle = true
            commentButton.size = .Small
            commentButton.style = .Secondary
            article.append(commentButton)
            
            // Title
            var solutionTitle = Text()
            solutionTitle.text = "<h1>\(getLangText(solution.name)). \(getLangText(solution.title))</h1>\n"
            article.append(solutionTitle)
            
            // Foreword
            var solutionForeword = Text()
            solutionForeword.text = getLangText(solution.foreword)
            article.append(solutionForeword)
            
            // Process descriptions
            var descriptionText = Text()
            descriptionText.text = "<h2>Process Description</h2>\n"
            
            // Build codes
            var codes = [String: String]()
            var topIndex = 1
            var subIndex = 1
            var scenarioIndex = 1
            for step in steps {
                codes[step.id] = "\(solution.codePrefix)\(topIndex)"
                for stepScenario in stepScenarios where stepScenario.highLevelStepID == step.id {
                    if codes[stepScenario.id] == nil {
                        codes[stepScenario.id] = "\(topIndex).\(scenarioIndex)"
                        scenarioIndex += 1
                    }
                    
                    for scenarioStep in scenarioSteps where scenarioStep.scenarioIDs.contains(stepScenario.id) {
                        if codes[scenarioStep.id] == nil {
                            codes[scenarioStep.id] = "\(solution.codePrefix)\(topIndex).\(subIndex)"
                            subIndex += 1
                        }
                    }
                }
                topIndex += 1
            }
            
            // Actual descriptions with codes
            for step in steps {
                
                descriptionText.text += "<h3>\(codes[step.id]!). \(getLangText(step.name))</h3>\n" +
                    "<p>\(getLangText(step.processDescription))</p>\n" +
                    "<img src='https://fakeimg.pl/1280x768/?text=\(codes[step.id]!). \(getLangText(step.name))&font=bebas&font_size=80'>"
                    //"<img src='https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Haber-Bosch-En.svg/1280px-Haber-Bosch-En.svg.png'>"
                
                for stepScenario in stepScenarios where stepScenario.highLevelStepID == step.id {
                    descriptionText.text += "<h4>\(codes[stepScenario.id]!). \(getLangText(stepScenario.name))</h4>\n"
                    
                    for scenarioStep in scenarioSteps where scenarioStep.scenarioIDs.contains(stepScenario.id) {
                        descriptionText.text += "<h5>\(codes[scenarioStep.id]!). \(getLangText(scenarioStep.name))</h5>\n" +
                        "<p>\(getLangText(scenarioStep.processDescription))</p>\n"
                    }
                }
                
                // Technical description
                descriptionText.text += "<h4>Technical description</h4>\n"
                
                for scenarioStep in scenarioSteps {
                    descriptionText.text += "<h5>\(codes[scenarioStep.id]!). \(getLangText(scenarioStep.name))</h5>\n" +
                    "<p>\(getLangText(scenarioStep.technicalDescription))</p>\n"
                }
            }
            article.append(descriptionText)
            
        }
        
    }
    
    func buildHome() {
        
    }
    
    func buildFooter() {
        
    }
    
    mutating func buildAddingStepForm(solutions: [Solution], tags: [Tag], scenarios: [Scenario]) {
        
        var tagsText = ""
        var index = 1
        for tag in tags {
            var checked = ""
            if app.cp["tag"]! == tag.id {
                checked = "checked"
            }
            tagsText += "<label><input class='uk-checkbox' type='checkbox' name='tag\(index)' value='\(tag.id)' \(checked)> \(tag.name["EN"]!)</label>"
            index += 1
        }
        
        var solutionsText = ""
        index = 1
        for solution in solutions {
            var checked = ""
            if app.cp["solution"]! == solution.id {
                checked = "checked"
            }
            solutionsText += "<label><input class='uk-checkbox' type='checkbox' name='solution\(index)' value='\(solution.id)' \(checked)> \(solution.name["EN"]!)</label>"
            index += 1
        }
        
        var scenariosText = ""
        index = 1
        for scenario in scenarios {
            var checked = ""
            if app.cp["scenario"]! == scenario.id {
                checked = "checked"
            }
            scenariosText += "<label><input class='uk-checkbox' type='checkbox' name='scenario\(index)' value='\(scenario.id)' \(checked)> \(scenario.name["EN"]!)</label>"
            index += 1
        }
        
        var formText = Text()
        formText.text = "<form action='/saveStep/' method='post'>\n" +
            "<input class='uk-button uk-button-primary' type='submit' value='Save'>" +
            "<h1>New Step</h1>\n" +
            "<fieldset class='uk-fieldset'>\n" +
            "<div class='uk-margin'><input name='nameEN' class='uk-input' type='text' placeholder='Name'></div>\n" +
            "<div class='uk-margin'><textarea name='processDescriptionEN' class='uk-textarea' rows='5' placeholder='Process Description'></textarea></div>\n" +
            "<div class='uk-margin uk-grid-small uk-child-width-auto uk-grid'>" +
            solutionsText +
            "</div>\n" +
            "<div class='uk-margin uk-grid-small uk-child-width-auto uk-grid'>" +
            tagsText +
            "</div>\n" +
            "<div class='uk-margin uk-grid-small uk-child-width-auto uk-grid'>" +
            scenariosText +
            "</div>\n" +
            "<div class='uk-margin'>" +
                "<select class='uk-select uk-form-width-medium' name='stepType'>" +
                    "<option value='manualStep'>Manual step</option>" +
                    "<option value='automatedStep'>Automated step</option>" +
                    "<option value='decisionPoint'>Decision point</option>" +
                    "<option value='start'>Start</option>" +
                    "<option value='end'>End</option>" +
                "</select>" +
            "</div>" +
            "<div class='uk-margin'><input name='badge' class='uk-input uk-form-width-medium' type='text' placeholder='Badge'></div>\n" +
            "<div class='uk-margin'><textarea name='technicalDescriptionEN' class='uk-textarea' rows='5' placeholder='Technical Description'></textarea></div>\n" +
            "</fieldset></form>\n"
        
        article.append(formText)
    }
    
    init(app: SWAApp) {
        self.app = app
        self.database = app.database
    }
    
    func getLangText(_ langTextCollection: [String: String]) -> String {
        
        var returnString = ""
        
        // Try to get current language
        if let lang = app.cp["lang"] {
            if let currentLanguage = langTextCollection[lang] {
                returnString = currentLanguage
            } else {
                guard let defaultLanguage = langTextCollection["EN"] else {
                    return returnString
                }
                returnString = defaultLanguage
            }
        }
        return returnString
        
    }
    
    func createLink(link: String, type: LinkType, scenarioID: String = "") -> String {
        
        var fullLink = "/"
        
        // If parameterValue is not provided a current one will be used
        func addParameter(parameterName: String, parameterValue: String?, parameterCollection: [String: String]) -> [String:String] {
            
            var parameters = parameterCollection
            
            if let parameterValue = parameterValue {
                if parameterValue != "" {
                    parameters[parameterName] = parameterValue
                } else {
                    if let parameter = app.cp[parameterName] {
                        if parameter != "" {
                            parameters[parameterName] = parameter
                        }
                    }
                }
            } else {
                if let parameter = app.cp[parameterName] {
                    if parameter != "" {
                        parameters[parameterName] = parameter
                    }
                }
            }
            
            return parameters
        }
        
        // Create string formatted as GET parameters
        func createLinkFromParameters(parameterCollection: [String: String]) -> String {
            var parametersLink = "?"
            for (name, value) in parameterCollection {
                parametersLink += name + "=" + value + "&"
            }
            parametersLink.remove(at: parametersLink.index(before: parametersLink.endIndex))
            return parametersLink
        }
        
        func getCurrentLink() -> String {
            
            var currentLink = "/"
            
            // If current address is a step, then set it for current link
            if let stepID = app.cp["step"] {
                if stepID != "" {
                    currentLink = "/step/" + stepID
                }
            }
            
            return currentLink
        }
        
        switch type {
        case .Home:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = "/dashboard/" + createLinkFromParameters(parameterCollection: parameters)
        case .BPM:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: link, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = "/"
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        case .Solution:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: link, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = "/"
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        case .Step:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = "/steps/" + link + createLinkFromParameters(parameterCollection: parameters)
        case .AddStep:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = "/addStep/" + createLinkFromParameters(parameterCollection: parameters)
        case .Language:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: link, parameterCollection: parameters)
            fullLink = getCurrentLink()
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        case .Tag:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: link, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = getCurrentLink()
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        case .Scenario:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: link, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = getCurrentLink()
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        case .Flow:
            var parameters = [String:String]()
            parameters = addParameter(parameterName: "bpm", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "solution", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "tag", parameterValue: nil, parameterCollection: parameters)
            parameters = addParameter(parameterName: "scenario", parameterValue: scenarioID, parameterCollection: parameters)
            parameters = addParameter(parameterName: "flow", parameterValue: link, parameterCollection: parameters)
            parameters = addParameter(parameterName: "lang", parameterValue: nil, parameterCollection: parameters)
            fullLink = getCurrentLink()
            fullLink += createLinkFromParameters(parameterCollection: parameters)
        }
        
        return fullLink
        
    }
    
}
