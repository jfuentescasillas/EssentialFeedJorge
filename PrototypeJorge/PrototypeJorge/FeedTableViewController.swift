//
//  FeedTableViewController.swift
//  PrototypeJorge
//
//  Created by jfuentescasillas on 11/09/23.
//


import UIKit


struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}


class FeedTableViewController: UITableViewController {
    // MARK: - Properties
    private let feed = FeedImageViewModel.prototypeFeed
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feed.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageTableViewCell
        let model = feed[indexPath.row]
        
        cell.configure(with: model)

        return cell
    }
}
