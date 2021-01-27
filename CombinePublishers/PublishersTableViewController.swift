//
//  PublishersTableViewController.swift
//  CombineOperators
//
//  Created by naz on 1/5/21.
//

import UIKit

struct PublisherItem {
    var name: String
    var segue: String
    var viewController: UIViewController.Type?
}

class PublishersTableViewController: UITableViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let cellIdentifier = "Cell"
    var publishers = [PublisherItem(name: "Multicast", segue: "multicast"), PublisherItem(name: "Futures", segue: "future"),PublisherItem(name: "Just", segue: "", viewController: JustPublisherViewController.self), PublisherItem(name: "@Published", segue: "atpublished"), PublisherItem(name: "FlatMap", segue: "", viewController: FlatMapViewController.self), PublisherItem(name: "Map", segue: "", viewController: MapViewController.self)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return publishers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = publishers[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = publishers[indexPath.row]
        guard let vc = item.viewController else {
            performSegue(withIdentifier: item.segue, sender: nil)
            return
        }
        navigationController?.pushViewController(vc.init(), animated: true)
    }
}
