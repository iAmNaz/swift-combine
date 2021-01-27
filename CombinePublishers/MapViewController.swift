//
//  MapViewController.swift
//  CombinePublishers
//
//  Created by naz on 1/24/21.
//

import Combine
import UIKit

struct FormField1 {
    var value: Int
}

class MapViewController: UIViewController {

    let textField1 = UITextField(frame: .zero)
    
    var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        constructTextFields()
        textField1.textPublisher
            .map({ value -> FormField1 in
                FormField1(value: Int(value) ?? 0)
            })
            .sink { value in
            print(value)
        }.store(in: &cancellables)
    }
}

private extension MapViewController {

    func constructTextFields() {
        textField1.translatesAutoresizingMaskIntoConstraints = false
        textField1.borderStyle = .roundedRect
        textField1.keyboardType = .numberPad
        textField1.textColor = .darkGray
        textField1.font = .systemFont(ofSize: 40)

        view.addSubview(textField1)

        NSLayoutConstraint.activate([
            textField1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            textField1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField1.widthAnchor.constraint(equalToConstant: 250),
            textField1.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
