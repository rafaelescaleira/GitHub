//
//  RepositoriesViewController.swift
//  GitHub
//
//  Created by Rafael Escaleira on 15/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfRepositories: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var repositories: [RepositoriesCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GitHubAPIV4.getRepositories(urlString: GitHubAPIV4.repositories) { (repositories) in
            
            self.repositories = repositories
            self.numberOfRepositories.text = "\(self.repositories.count)"
            
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func reloadAllRepository(_ sender: UIButton) {
        
        self.repositories = []
        self.activityIndicator.startAnimating()
        self.tableView.reloadData()
        
        self.viewWillAppear(true)
    }
}

// MARK: Table View

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.repositories.count == 0 ? .none : .singleLine
        
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoriesTableViewCell", for: indexPath) as? RepositoriesTableViewCell else { return UITableViewCell() }
        
        let item = self.repositories[indexPath.row]
        
        cell.selectionStyle = .none
        cell.repositoryTitle.text = item.name
        cell.repositoryDescription.text = item.description
        cell.isPrivate.text = ""
        cell.repositoryLanguage.text = item.language
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMMM/YYYY"
        
        let date = dateFormatter.date(from: item.updated_at ?? "")
        
        cell.repositoryUpdate.text = ("Update \(dateFormatter.string(from: date ?? Date()))").replacingOccurrences(of: "/", with: " de ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let item = self.repositories[indexPath.row]
        
        UIView.animate(withDuration: 0.2, animations: { cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }) { (_) in
            UIView.animate(withDuration: 0.2, animations: { cell?.transform = CGAffineTransform(scaleX: 1, y: 1) })
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "ReadMeViewController") as? ReadMeViewController else { return }
        
        GitHubAPIV4.getContents(urlString: item.contents_url?.replacingOccurrences(of: "/{+path}", with: "") ?? "") { (contents) in
            
            guard let readme = (contents.first { (content) -> Bool in return content.name == "README.md" }) else { return }
            
            DispatchQueue.global(qos: .background).async {
                
                guard let url = URL(string: readme.download_url ?? "") else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let readme = String(data: data, encoding: .utf8) else { return }
                
                DispatchQueue.main.async {
                    
                    controller.readme = readme
                    
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
}


// MARK: Cell

class RepositoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    @IBOutlet weak var repositoryLanguage: UILabel!
    @IBOutlet weak var repositoryUpdate: UILabel!
    @IBOutlet weak var isPrivate: UILabel!
}
