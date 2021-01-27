//
//  MapViewController.swift
//  CombinePublishers
//
//  Created by naz on 1/24/21.
//

import UIKit
import Combine
/*
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
 
 https://jsonplaceholder.typicode.com/posts/
 */


struct PostQuery {
    let id: String
}

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

class FlatMapViewController: UIViewController {
    var blogPublisher = PassthroughSubject<PostQuery, URLError>()
    var cancellable: AnyCancellable!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let publisher = blogPublisher.flatMap(maxPublishers: .max(1)) { query -> URLSession.DataTaskPublisher in
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(query.id)")!
            return URLSession.shared.dataTaskPublisher(for: url)
        }.eraseToAnyPublisher()
        
        cancellable = publisher.map {
            $0.data
        }
        .decode(type: Post.self, decoder: JSONDecoder())
        .sink { (completion) in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        } receiveValue: { value in
            print(value.id)
        }
        
        blogPublisher.send(PostQuery(id: "1"))
        blogPublisher.send(PostQuery(id: "2"))
        blogPublisher.send(PostQuery(id: "3"))
    }
}

