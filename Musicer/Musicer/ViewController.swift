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
        self.view.backgroundColor = R.color.mu_color_gray_dark()
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let server = UploadController()
//        self.present(server, animated: true, completion: nil)
        
        let card = PlayControllingCard()
        self.view.addSubview(card)
        card.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(200)
        }
        
    }
    
    
}

