//
//  ViewController.swift
//  swiftUnity
//
//  Created by Ahmed Iqbal on 6/22/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOpen(_ sender: UIButton) {
        Unity.shared.show()
    }
}

