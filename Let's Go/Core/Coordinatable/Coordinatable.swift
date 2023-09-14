//
//  Coordinatable.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit

protocol Coordinatable: AnyObject {
    var startingViewController: UIViewController? { get }
    var parent: Coordinatable? { get }
    var children: [Coordinatable] { get }

    func add(_ child: Coordinatable)
    func remove(_ child: Coordinatable)
    func start()
}
