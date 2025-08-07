//
//  ViewController.swift
//  OTPField
//
//  Created by Engin Bolat on 7.08.2025.
//

import UIKit

class ViewController: UIViewController {
    let body = OTPView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
    }
}

//MARK: ACTION

extension ViewController {
    private func setup() {
        body.nextButton.addTarget(self, action: #selector(onPressNext), for: .touchUpInside)
        body.nextButton.isEnabled = false
        body.nextButton.backgroundColor = .gray

        body.textFields.forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
        }
    }

    @objc private func onPressNext() {
        let code = body.textFields.map { $0.text ?? "" }.joined()
    }

    @objc private func onTextFieldChanged() {
        let isFilled = body.textFields.allSatisfy { ($0.text ?? "").count == 1 }
        body.nextButton.isEnabled = isFilled
        body.nextButton.backgroundColor = isFilled ? .black : .gray
    }
}

//MARK: STYLE
extension ViewController {
    private func layout() {
        view.backgroundColor = .white
        body.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(body)
        
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: view.topAnchor),
            body.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}


extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

        textField.layer.borderColor = UIColor.black.cgColor

        if let index = body.textFields.firstIndex(of: textField) {
            for i in index..<body.textFields.count {
                body.textFields[i].text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = body.textFields.firstIndex(of: textField) else { return true }

        let currentText = textField.text ?? ""
        let updated = (currentText as NSString).replacingCharacters(in: range, with: string)

        if updated.count > 1 { return false }

        if !string.isEmpty {
            textField.text = string
            if index + 1 < body.textFields.count { body.textFields[index + 1].becomeFirstResponder() }
            else { textField.resignFirstResponder() }
            return false
        }

        if string.isEmpty && range.length == 1 {
            textField.text = ""
            if index > 0 { body.textFields[index - 1].becomeFirstResponder() }
            return false
        }

        return true
    }
}
