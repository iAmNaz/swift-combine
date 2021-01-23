//
//  MulticasPublisherViewController.swift
//  CombinePublishers
//
//  Created by naz on 1/7/21.
//


import UIKit
import Combine

class MulticasPublisherViewController2: UIViewController {
    var cancellables = Set<AnyCancellable>()
    let subject = PassthroughSubject<Int, Never>()
    
    @IBOutlet weak var debugView1: UITextView!
    @IBOutlet weak var debugView2: UITextView!
    @IBOutlet weak var debugView3: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multicast()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DebugViewController
        vc.subject = subject
    }
    
    func valuePublisher() -> Publishers.Zip<Publishers.Sequence<[Int], Never>, Publishers.Autoconnect<Timer.TimerPublisher>> {
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
        return Publishers.Zip([1,2,3,4,5,6,7,8].publisher, timerPublisher)
    }
    
    func simpleMulticast() {
        let zipPublisher = valuePublisher()
        let publisher = zipPublisher
            .map{ tuple -> String in
                return "\(tuple.0)"
            }
            .print()
            .eraseToAnyPublisher()
        
        publisher
            .map {"\(self.debugView1.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView1)
            .store(in: &cancellables)

        publisher
            .map {"\(self.debugView2.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView2)
            .store(in: &cancellables)
    }
    
    func multicast() {
        let zipPublisher = valuePublisher()
        
        let publisher = zipPublisher
            .map { $0.0 }
            .print()
            .eraseToAnyPublisher()
            
       // Create multicast
        let multicastSubject = publisher.multicast { PassthroughSubject<Int, Never>() }
        
        // Create subscriptions
        multicastSubject
            .map {"\(self.debugView1.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView1)
            .store(in: &cancellables)
        
        multicastSubject
            .map {"\(self.debugView2.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView2)
            .store(in: &cancellables)
        
        // To align the new values
        self.debugView3.text = "\n\n\n"
        
        // Connect
        multicastSubject.connect().store(in: &cancellables)
        
        // Late subscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            multicastSubject
                .map {"\(self.debugView3.text ?? "") \n\($0)"}
                .assign(to: \.text, on: self.debugView3)
                .store(in: &self.cancellables)
        }
    }
    
    func shareMulticast() {
        let zipPublisher = valuePublisher()
        
        let publisher = zipPublisher
            .map { $0.0 }
            .print()
            .eraseToAnyPublisher()
            
       let multicastSubject = publisher.share()
        
        multicastSubject
            .map {"\(self.debugView1.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView1)
            .store(in: &cancellables)
        
        multicastSubject
            .map {"\(self.debugView2.text ?? "") \n\($0)"}
            .assign(to: \.text, on: debugView2)
            .store(in: &cancellables)
        
        self.debugView3.text = "\n\n\n"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            multicastSubject
                .map {"\(self.debugView3.text ?? "") \n\($0)"}
                .assign(to: \.text, on: self.debugView3)
                .store(in: &self.cancellables)
        }
    }
}
