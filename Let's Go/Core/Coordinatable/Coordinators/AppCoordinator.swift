//
//  AppCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

protocol ApplicationCoordinatorInterface: Coordinatable {
    func startLoginFlow()
    func startAuthorizedFlow()
}

final class AppCoordinator: BaseCoordinator {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        let navigationController = BaseNavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        super.init(router: Router(rootController: navigationController))
    }
    
    override func start() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        router.root.navigationBar.standardAppearance = appearance
        router.setRootModule(SplashAssembly(sceneOutput: self).makeScene())
    }
    
}

extension AppCoordinator: ApplicationCoordinatorInterface {
    func startAuthorizedFlow() {
        DispatchQueue.main.async {
            let tabCoordinator = TabCoordinator(
                navigationController: self.router.root,
                delegate: self
            )
            self.add(tabCoordinator)
            tabCoordinator.start()
        }
    }
    
    func startLoginFlow() {
        DispatchQueue.main.async {
            let loginCoordinator = LoginCoordinator(router: self.router)
            loginCoordinator.onFinish = { [weak self, weak loginCoordinator] in
                guard let self, let loginCoordinator else { return }
                self.startAuthorizedFlow()
                self.remove(loginCoordinator)
            }
            self.add(loginCoordinator)
            loginCoordinator.start()
        }
    }
}

extension AppCoordinator: TabCoordinatorDelegate {
    func didLogoutUser(_ coordinator: TabCoordinator) {
        Task {
            do {
                try await UserAccount.shared.deleteSession()
            } catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            self.startLoginFlow()
            self.remove(coordinator)
        }
    }
}

extension AppCoordinator: SplashSceneOutput {
    func proceedFromSplash() {
        Task {
            do {
                try await UserAccount.shared.login()
                self.startAuthorizedFlow()
            } catch {
                print(error)
                self.startLoginFlow()
            }
        }
    }
}

