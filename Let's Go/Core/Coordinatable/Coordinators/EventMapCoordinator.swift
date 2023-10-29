//
//  MapCoordinator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

protocol EventMapSceneOutput {
    func showEventPreview(_: Event)
    func showEventPage(_: Event)
}

final class EventMapCoordinator: BaseCoordinator {
        
    override func start() {
        let scene = EventMapAssembly(sceneOutput: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene)
    }
    
}

extension EventMapCoordinator: EventMapSceneOutput {
    func showEventPreview(_ event: Event) {
        let scene = EventPreviewAssembly(event, sceneOutput: self).makeScene()
        router.present(scene, animated: true)
    }
    
    func showEventPage(_ event: Event) {
        let scene = EventPageAssembly(event, sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
}
