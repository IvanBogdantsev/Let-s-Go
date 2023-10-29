//
//  EventPageViewModelAssembly.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit

struct EventPageAssembly: SceneAssembly {
    private let event: Event
    private let sceneOutput: EventMapSceneOutput?
    
    init(_ event: Event, sceneOutput: EventMapSceneOutput?) {
        self.event = event
        self.sceneOutput = sceneOutput
    }
    
    func makeScene() -> UIViewController {
        let viewModel = EventPageViewModel(event: event, sceneOutput: sceneOutput)
        let viewController = EventPageViewController(viewModel: viewModel)
        return viewController
    }
}
