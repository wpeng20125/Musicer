//
//  BaseViewController.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/1.
//

import UIKit

class BaseViewController: UIViewController {
    
    deinit {
        ffprint("\(type(of: self)) is released")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.view.backgroundColor = R.color.mu_color_gray_dark()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
