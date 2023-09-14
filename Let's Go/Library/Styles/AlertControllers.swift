//
//  AlertControllers.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 09.09.2023.
//

import UIKit

extension UIAlertController {
    static func error(_ message: String) -> UIAlertController {
        let alertController = UIAlertController(
          title: Strings.something_wrong,
          message: message,
          preferredStyle: .alert
        )
        alertController.addAction(
          UIAlertAction(
            title: Strings.ok,
            style: .cancel,
            handler: nil
          )
        )

        return alertController
      }
}
