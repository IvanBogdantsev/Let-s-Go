//
//  SignUpAssembly.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 02.09.2023.
//

import UIKit

struct SignUpAssembly: SceneAssembly {
    private let sceneOutput: LoginSceneOutput?
    
    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
    }
    
    func makeScene() -> UIViewController {
        let viewModel = SignUpViewModel(sceneOutput: sceneOutput)
        let viewController = SignUpViewController(viewModel: viewModel)
        return viewController
    }
}
