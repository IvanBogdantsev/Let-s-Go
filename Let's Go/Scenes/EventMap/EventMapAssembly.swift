//
//  MapAssembly.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 22.09.2023.
//

import UIKit

struct EventMapAssembly: SceneAssembly {
    private let sceneOutput: EventMapSceneOutput?
    
    init(sceneOutput: EventMapSceneOutput?) {
        self.sceneOutput = sceneOutput
    }
    
    func makeScene() -> UIViewController {
        let viewModel = EventMapViewModel(sceneOutput: sceneOutput)
        let viewController = EventMapViewController(viewModel: viewModel)
        return viewController
    }
}
