//
//  PresentationViewController.swift
//  GitHub
//
//  Created by Rafael Escaleira on 14/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices

class PresentationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func projectManagementButtonAction(_ sender: UIButton) {
        
        guard let url = URL(string: "https://github.com/features/project-management/") else { return }
        let safariController = SFSafariViewController(url: url)
        DispatchQueue.main.async { self.present(safariController, animated: true, completion: nil) }
    }
}
