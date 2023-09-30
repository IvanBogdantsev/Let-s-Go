//
//  MapAssembly.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 22.09.2023.
//

import UIKit

struct MapAssembly: SceneAssembly {
    func makeScene() -> UIViewController {
        let viewModel = MapViewModel()
        let viewController = MapViewController(viewModel: viewModel)
        return viewController
    }
}
