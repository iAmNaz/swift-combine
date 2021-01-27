//
//  DebugViewController.swift
//  CombinePublishers
//
//  Created by naz on 1/9/21.
//

import UIKit
import Combine

class DebugViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    var subject: PassthroughSubject<String, Never>!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }
    
    func subscribe() {
        subject
            .map { "\(self.textView.text ?? "") \n\($0)" }
            .assign(to: \.text, on: textView)
            .store(in: &cancellables)
    }
}
