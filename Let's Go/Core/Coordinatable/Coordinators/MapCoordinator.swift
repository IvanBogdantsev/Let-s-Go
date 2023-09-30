//
//  MapCoordinator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

final class MapCoordinator: BaseCoordinator {
        
    override func start() {
        let scene = MapAssembly().makeScene()
        startingViewController = scene
        router.setRootModule(scene)
    }
    
}
