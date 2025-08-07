//
//  +UIStackView.swift
//  OTPField
//
//  Created by Engin Bolat on 7.08.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
