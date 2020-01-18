//
//  ReadMeViewController.swift
//  GitHub
//
//  Created by Rafael Escaleira on 15/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import MarkdownView

class ReadMeViewController: UIViewController {
    
    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var readme: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.markdownView.load(markdown: self.readme)
    }
}
