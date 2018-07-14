import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        
        let database = Database(host: "localhost", port: Int16(5984), username: "khariv01", password: "0Gs29FxCU6mH")
        //let database = Database(host: "ac88284c-b035-474f-9743-df43822423eb-bluemix.cloudant.com", port: Int16(443), username: "ac88284c-b035-474f-9743-df43822423eb-bluemix", password: "3b9b1cea966e149e9ee595cc7ebc47fe6ff90fe1c56d3034bb8a6e554860e278")
        
        // Handle HTTP GET requests to /
        router.get("/dashboard/") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.buildHome(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.get("/addStep/") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.addStep(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.post("/saveStep/") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.saveStep(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.get("/") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.buildSolution(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.get("/steps/:step") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.buildStep(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.get("/scenarios/:scenario") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.buildScenario(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
        
        router.get("/connections/:connection") {
            request, response, next in
            var swaApp = SWAApp(database: database)
            swaApp.buildConnection(request: request)
            response.status(.OK).send(swaApp.makeHTMLBody())
            next()
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
