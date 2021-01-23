//
//  JustPublisherViewController.swift
//  CombineOperators
//
//  Created by naz on 1/5/21.
//

import UIKit
import Combine

struct Todo: Decodable {
    var title: String
}

class JustPublisherViewController: UIViewController {
    var store = Set<AnyCancellable>()
    let label = UILabel(frame: .zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func constructLabel() {
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23)
        label.textColor = .systemBlue
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0), label.widthAnchor.constraint(greaterThanOrEqualToConstant: 200.0)] )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constructLabel()
        
        getTodos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (todos) in
            self?.label.text = "Found \(todos.count) todo items"
        }.store(in: &store)
    }

    func getTodos() -> AnyPublisher<[Todo], Never> {
        let todoURL = URL(string: "https://jsonplaceholder.typicode.com/todos")

        let todosPublisher = URLSession.shared.dataTaskPublisher(for: todoURL!)
            .map{ $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .catch { err in
                return Just([])
            }
            .eraseToAnyPublisher()
        
        return todosPublisher
    }
}
