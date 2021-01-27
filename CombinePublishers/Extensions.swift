//
//  Extensions.swift
//  CombinePublishers
//
//  Created by naz on 1/6/21.
//

import UIKit
import Combine

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
            NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: self)
                .compactMap { $0.object as? UITextField }
                .map { $0.text ?? "" }
                .eraseToAnyPublisher()
        }
}
