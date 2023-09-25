//
//  FeedTableViewController.swift
//  PrototypeJorge
//
//  Created by jfuentescasillas on 11/09/23.
//


import UIKit


// MARK: - FeedImageViewModel
struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}


// MARK: - FeedTableViewController Class
class FeedTableViewController: UITableViewController {
    // MARK: - Properties
    private var feed = [FeedImageViewModel]()
    
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        tableView.setContentOffset(CGPoint(x: 0,
                                           y: -tableView.contentInset.top),
                                   animated: false)
    }
    
    
    // MARK: - Custom Methods
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.feed.isEmpty {
                self.feed = FeedImageViewModel.prototypeFeed
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    

    // MARK: - Table view data source
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
