//
//  FeedViewController.swift
//  InstaCloneApp
//
//  Created by Mehmet Sukru Kavak on 28.03.2023.
//

import UIKit

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! FeedCell
        cell.commentLabel.text = "comment"
        cell.likeLabel.text = "0"
        cell.userEmailLabel.text = "user@user.com"
        cell.userImageView.image = UIImage(named: "selectImage")
        return cell;
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
