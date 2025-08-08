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
        wireUp()
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
        let code = body.textFields.compactMap { $0.text }.joined()
        print("OTP Code: \(code)")
    }

    @objc private func onTextFieldChanged() {
        let isFilled = body.textFields.allSatisfy { ($0.text?.count ?? 0) == 1 }
        body.nextButton.isEnabled = isFilled
        body.nextButton.backgroundColor = isFilled ? .black : .gray
    }
    
    private func suspendEditingChanged(_ suspend: Bool) {
        body.textFields.forEach { tf in
            if suspend {
                tf.removeTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
            } else {
                tf.addTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
            }
        }
    }
    
    private func wireUp() {
        // TextFields
        body.textFields.forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
            // Boşken backspace ile geri odaklanma
            $0.onEmptyBackspace = { [weak self, weak tf = $0] in
                guard
                    let self,
                    let tf,
                    tf.tag > 0
                else { return }
                let prev = self.body.textFields[tf.tag - 1]
                if prev.text?.isEmpty == false {
                    prev.text = ""
                }
                prev.becomeFirstResponder()
            }
        }
        
        // İlk kutuya fokus
        body.textFields.first?.becomeFirstResponder()
        
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

        if let index = body.textFields.firstIndex(of: textField as! BackspaceTextField) {
            for i in index..<body.textFields.count {
                body.textFields[i].text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.gray.cgColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let index = body.textFields.firstIndex(of: textField as! BackspaceTextField) else { return true }

        // Şu anki textField'ın text'ini alıyoruz
        let currentText = textField.text ?? ""

        // Eğer yeni metin boş ise, backspace tuşuna basıldığı anlamına gelir
        if string.isEmpty && currentText.isEmpty && range.length == 1 {
            // Eğer textField boş ise, bir önceki textField'a geçiş yap
            if index > 0 {
                body.textFields[index - 1].becomeFirstResponder()
            }
            return false
        }

        // Eğer metin ekleniyorsa (string boş değilse)
        if !string.isEmpty {
            textField.text = string
            // Eğer bir sonraki textField varsa, ona geçiş yap
            if index + 1 < body.textFields.count {
                body.textFields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }

        return true
    }
}
