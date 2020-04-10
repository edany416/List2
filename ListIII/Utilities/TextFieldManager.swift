//
//  TextFieldManager.swift
//  ListIII
//
//  Created by Edan on 4/1/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TextFieldManagerDelegate: class {
    @objc optional func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect)
    @objc optional func keyboardWillHide()
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class TextFieldManager: NSObject {
    static let manager = TextFieldManager()
    private var viewControllerStack: [TextFieldManagerDelegate]
    private var selectedTextField: UITextField?
    
    weak var delegate: TextFieldManagerDelegate?
    
    private override init() {
        viewControllerStack = [TextFieldManagerDelegate]()
        super.init()
        registerNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func register(_ viewController: TextFieldManagerDelegate) {
        delegate = viewController
        viewControllerStack.append(viewController)
        print("register - \(viewControllerStack.count)")
    }
    
    func unregister() {
        print("unregister - \(viewControllerStack.count)")
        if viewControllerStack.count > 1 {
            viewControllerStack.removeLast()
            delegate = viewControllerStack.last!
        } else {
            viewControllerStack.removeLast()
            delegate = nil
        }
    }
    
    func resignFirstResponder() {
        selectedTextField?.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let selectedTextField = self.selectedTextField {
                delegate?.keyboardWillShow?(selectedTextField, keyboardRect)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        delegate?.keyboardWillHide?()
        selectedTextField = nil
    }
}

extension TextFieldManager: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn?(textField) ?? false
    }
}
