//
//  LoginCoordinator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 17.08.2023.
//

import UIKit

protocol LoginSceneOutput {
    func goToSignUp()
    func goToLogin()
    func login()
    func goToEnterCode()
}

final class LoginCoordinator: BaseCoordinator {
    
    var onFinish: (() -> Void)?
    
    override func start() {
        let scene = EntryOptionsViewController(sceneOutput: self)
        startingViewController = scene
        UIView.transition(
            with: router.root.view,
            duration: AnimationDuration.macroRegular.timeInterval,
            options: .transitionCrossDissolve,
            animations: {
                self.router.setRootModule(scene, hideBar: false, animated: false)
            },
            completion: nil
        )
    }
    
}

extension LoginCoordinator: LoginSceneOutput {
    func goToEnterCode() {
        let scene = EnterCodeAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
    
    func goToSignUp() {
        let scene = SignUpAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
    
    func goToLogin() {
        let scene = LoginAssembly(sceneOutput: self).makeScene()
        router.push(scene, animated: true)
    }
    
    func login() {
        onFinish?()
    }
}
