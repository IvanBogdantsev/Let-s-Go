//
//  SplashConfigurator.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import UIKit

struct SplashAssembly: SceneAssembly {
    private let sceneOutput: SplashSceneOutput

    init(sceneOutput: SplashSceneOutput) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController(viewModel: viewModel)
        viewModel.output = sceneOutput
        return viewController
    }
}
