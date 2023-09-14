//
//  BaseCoordinator.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

class BaseCoordinator: NSObject, Coordinatable {
    let router: Router
    var children: [Coordinatable]

    weak var startingViewController: UIViewController?
    weak var parent: Coordinatable?

    init(router: Router) {
        children = [Coordinatable]()
        self.router = router
        super.init()
    }

    deinit {
        children.removeAll()
    }

    func start() {}

    // MARK: - Manage dependencies
    func add(_ child: Coordinatable) {
        for element in children where  child === element {
            return
        }
        children.append(child)
    }

    func remove(_ child: Coordinatable) {
        guard !children.isEmpty else { return }
        for (index, element) in children.enumerated() where element === child {
            children.remove(at: index)
            break
        }
    }
}
