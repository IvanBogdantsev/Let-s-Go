//
//  SplashPresenter.swift
//  HeyDay
//
//  Created by Eugene Kleban on 27.05.22.
//  
//

import Foundation

final class SplashViewModel {
    // MARK: Properties
    weak var output: SplashSceneOutput?
}

// MARK: SplashPresenterInterface
extension SplashViewModel: SplashViewModelInterface {
    func viewDidLoad() {
        displayDesiredFlow()
    }

    private func displayDesiredFlow() {
            self.output?.proceedFromSplash()
    }
}
