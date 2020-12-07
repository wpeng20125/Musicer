//
//  BaseViewController.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/1.
//

import UIKit

protocol LoadingProtocol: NSObjectProtocol {
    func reload()
}

extension LoadingProtocol {
    func reload() { }
}

class BaseViewController: UIViewController {
    
    weak var delegate: LoadingProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.view.backgroundColor = R.color.mu_color_white()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
