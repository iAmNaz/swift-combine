//
//  PublishedPublisherViewController.swift
//  CombinePublishers
//
//  Created by naz on 1/6/21.
//

import UIKit
import Combine

class PublishedPublisherViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var model = SomeModel()
    var store = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.$state.map{
            return "\($0)"
        }.assign(to: \.text, on: label)
        .store(in: &store)
    }
    
    @IBAction func incrementAction(_ sender: Any) {
        increment()
    }
    
    func increment() {
        model.state += 1
    }
}

class SomeModel {
    @Published var state: Int = 0
}
