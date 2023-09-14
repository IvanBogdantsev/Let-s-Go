//
//  LoginAssembly.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit

struct LoginAssembly: SceneAssembly {
    private let sceneOutput: LoginSceneOutput?

    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewModel = LoginViewModel(sceneOutput: sceneOutput)
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }
}
