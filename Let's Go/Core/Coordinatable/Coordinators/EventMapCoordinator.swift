//
//  MapCoordinator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

protocol EventMapSceneOutput {
    //func showEventPreview
}

final class EventMapCoordinator: BaseCoordinator {
        
    override func start() {
        let scene = EventMapAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene)
    }
    
}

extension EventMapCoordinator: EventMapSceneOutput {
    
}
