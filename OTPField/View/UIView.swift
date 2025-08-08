//
//  UIView.swift
//  OTPField
//
//  Created by Engin Bolat on 7.08.2025.
//

import UIKit

class OTPView: UIView {

    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let textFields: [BackspaceTextField] = (0..<6).map { _ in
        let tf = BackspaceTextField()
        tf.keyboardType = .numberPad
        return tf
    }
    
    let nextButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.setTitle("Title", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.backgroundColor = UIColor.gray.cgColor
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(textFieldStackView)
        addSubview(nextButton)
        UITextField.appearance().tintColor = .black
        textFields.forEach { textFieldStackView.addArrangedSubview($0) }
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            textFieldStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
