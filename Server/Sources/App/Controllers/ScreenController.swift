//
//  ScreenController.swift
//  
//
//  Created by Leif on 4/5/22.
//

import ScreenData
import Vapor

struct ScreenController: RouteCollection {
    enum Screen: String {
        case index
    }
    
    private let staticScreens: [String: SomeScreen] = [
        Screen.index.rawValue: SomeScreen(
            id: Screen.index.rawValue,
            title: "Index Screen",
            backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
            headerView: nil,
            someView: SomeContainerView(
                isScrollable: true,
                axis: .vertical,
                views: [
                    SomeLabel(
                        title: "View Screens",
                        font: .title,
                        style: SomeStyle(
                            foregroundColor: SomeColor(red: 0, green: 0, blue: 0)
                        ),
                        destination: Destination(type: .screen, toID: "screens")
                    )
                    .someView
                ]
            )
            .someView,
            footerView: nil
        )
    ]
    
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: index)
        routes.get(":screen", use: getScreen)
        routes.get("screens", use: getScreens)
    }
    
    func index(req: Request) throws -> SomeScreen {
        staticScreens[Screen.index.rawValue]!
    }
    
    func getScreen(req: Request) throws -> SomeScreen {
        guard let id = req.parameters.get("screen") else {
            throw Abort(.badRequest)
        }
        
        guard let screen = staticScreens[id] else {
            throw Abort(.noContent)
        }
        
        return screen
    }
    
    func getScreens(req: Request) throws -> SomeScreen {
        SomeScreen(
            id: "screens",
            title: "Screens",
            backgroundColor: SomeColor(red: 1, green: 1, blue: 1),
            headerView: nil,
            someView: SomeContainerView(
                isScrollable: true,
                axis: .vertical,
                views: staticScreens.map { (key, screen) in
                    SomeLabel(
                        title: screen.title,
                        font: .body,
                        style: SomeStyle(
                            foregroundColor: SomeColor(red: 0, green: 0, blue: 0)
                        ),
                        destination: screen.id.map {
                            Destination(
                                type: .screen,
                                toID: $0
                            )
                        }
                    )
                    .someView
                }
            )
            .someView,
            footerView: nil
        )
    }
}
