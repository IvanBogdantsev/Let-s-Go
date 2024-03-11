//
//  CodeTextField.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import UIKit

protocol CodeTextFieldDelegate: AnyObject {
    func deleteBackward(sender: CodeTextField, prevValue: String?)
}

final class CodeTextField: UITextField {
    weak var deleteDelegate: CodeTextFieldDelegate?
    override func deleteBackward() {
        let prevValue = text
        super.deleteBackward()
        deleteDelegate?.deleteBackward(sender: self, prevValue: prevValue)
    }
}
