//
//  BaseNavigationController.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

final class BaseNavigationController: UINavigationController {

    var navigationBarTintColor = UIColor.letsgo_main_red

    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBarAppearance()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    func handlePoppedViewControllerIfNeeded(_ navigationController: UINavigationController) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            if let fromViewController = coordinator.viewController(forKey: .from),
               !navigationController.viewControllers.contains(fromViewController) {
                // viewController is going to be popped
                if coordinator.isInteractive {
                    // if viewController is going to be poppoed via back swipe
                    // we must wait until transition is finished, to make sure that
                    // it isn't cancelled.
                    coordinator.notifyWhenInteractionChanges { [weak self] context in
                        if !context.isCancelled {
                            // handle pop event for viewController
                            self?.postNotificationThatViewControllerWasPopped()
                        }
                    }
                } else {
                    // viewController is popped after user taps back button
                    // we handle pop event immediately
                    postNotificationThatViewControllerWasPopped()
                }
            }
        }
    }

    private func postNotificationThatViewControllerWasPopped() {
        NotificationCenter.default.post(name: NSNotification.Name("didPerformPopViewController"), object: nil)
    }

    private func updateNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor : UIColor.letsgo_white]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = navigationBarTintColor
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        handlePoppedViewControllerIfNeeded(navigationController)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
