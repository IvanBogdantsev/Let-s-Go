//
//  EventPageViewModelAssembly.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit

struct EventPageAssembly: SceneAssembly {
    private let sceneOutput: EventPageSceneOutput?

    init(sceneOutput: EventPageOutput?) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewModel = EventPageViewModel(sceneOutput: sceneOutput)
        let viewController = EventPageViewController(viewModel: viewModel)
        return viewController
    }
}
