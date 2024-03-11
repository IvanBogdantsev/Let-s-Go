//
//  EnterCodeAssembly.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import UIKit

struct EnterCodeAssembly: SceneAssembly {
    private let sceneOutput: LoginSceneOutput?

    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
    }

    func makeScene() -> UIViewController {
        let viewModel = EnterCodeViewModel(sceneOutput: sceneOutput)
        let viewController = EnterCodeViewController(viewModel: viewModel)
        return viewController
    }
}
