//
//  BaseTextfield.swift
//  OTPField
//
//  Created by Engin Bolat on 8.08.2025.
//

import UIKit

final class BackspaceTextField: UITextField {
    var onEmptyBackspace: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        textColor = .black
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        font = UIFont.systemFont(ofSize: 16, weight: .bold)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 45),
            heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal")
    }

     override func deleteBackward() {
        let wasEmpty = (text ?? "").isEmpty
        if wasEmpty {
            onEmptyBackspace?()
        }
        super.deleteBackward()
    }
}
