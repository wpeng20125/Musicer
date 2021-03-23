//
//  SongsListSelectController.swift
//  Musicer
//
//  Created by 王朋 on 2021/3/23.
//

import UIKit

class SongsListSelectController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_black_alpha_3()
        self.setupSubViews()
    }

    private lazy var selectView: SongsListSelectView = { SongsListSelectView() }()
}

fileprivate extension SongsListSelectController {
    
    func setupSubViews() {
        self.view.addSubview(self.selectView)
        
    }
}

fileprivate extension SongsListSelectController {
    
    func refresh() {
        let lists = SongManager.default.totalLists()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            
        }
    }
    
}
