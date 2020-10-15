//
//  ViewController.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let server = UploaderServer()
        self.present(server, animated: true, completion: nil)
    }
}

