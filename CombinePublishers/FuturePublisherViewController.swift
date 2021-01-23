//
//  FuturePublisherViewController.swift
//  CombineOperators
//
//  Created by naz on 1/5/21.
//

import UIKit
import Combine

class FuturePublisherViewController: UIViewController {
    var store = Set<AnyCancellable>()
    @IBOutlet weak var label: UILabel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func asycAction(_ sender: Any) {
        performAsyncTask()
    }
    
    @IBAction func futureAction(_ sender: Any) {
        performFutureTask()
    }
    
    @IBAction func futureErrorAction(_ sender: Any) {
        performFutureTaskError()
    }
    
    fileprivate func performAsyncTask() {
        let lib = ThirdPartyLibrary()
        label.text = "Performing async task."
        lib.performAsyncAction { [weak self] in
            self?.label.text = "Async task completed"
        }
    }
    
    fileprivate func performFutureTask() {
        let lib = ThirdPartyLibrary()
        label.text = "Performing future task."
        
        lib.performAsyncActionFuture().sink { [weak self] in
            self?.label.text = "Future task completed"
        }.store(in: &store)
    }
    
    fileprivate func performFutureTaskError() {
        let lib = ThirdPartyLibrary()
        label.text = "Performing future task with error."
        
        lib.performAsyncActionFutureError().sink { [weak self] completion in
            switch completion {
            case .failure(.message(let error)):
                self?.label.text = "\(error)"
            case .finished:
                self?.label.text = "Async task completed"
            }
        } receiveValue: {}.store(in: &store)
    }
}

class ThirdPartyLibrary {
    func performAsyncAction(completionHandler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
            completionHandler()
        }
    }
    
    func performAsyncActionFuture() -> Future <Void, Never> {
        return Future() { promise in
            DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
                promise(Result.success(()))
            }
        }
    }
    
    func performAsyncActionFutureError() -> Future <Void, AsyncError> {
        return Future() { promise in
            DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
                promise(Result.failure(AsyncError.message("Request failed!")))
            }
        }
    }
}

enum AsyncError: Error {
    case message(String)
}
