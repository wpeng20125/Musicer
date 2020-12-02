//
//  SongsListController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/19.
//

import UIKit

class SongsListController: BaseViewController {

    //MARK: -- private
    private var table: SongsListTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.setupSubViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Toaster.showLoading()
        if let listNames = SongsManager.shared.songListNames {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                Toaster.hideLoading()
                self.table?.refersh(withNames: listNames)
            }
        }
    }
}

extension SongsListController {
    
    func setupSubViews() {
        let titleBar = TitleBar()
        titleBar.dataSource = self
        titleBar.delegate = self
        titleBar.backgroundColor = R.color.mu_color_orange_light()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(TitleBarHeight)
        }
        titleBar.configure()
        
        self.table = SongsListTable()
        self.view.addSubview(self.table!)
        self.table!.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
        
        let createView = SongsListCreateView(frame: CGRect(x: 10, y: 100, width: 200, height: 100))
        self.view.addSubview(createView)
    }
}

extension SongsListController: TitleBarDelegate, TitleBarDataSource {
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left: self.navigationController?.popViewController(animated: true)
        case .right: ffprint("")
        default: return
        }
    }
    
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let property = ItemProperty()
        switch p {
        case .left:
            property.image = R.image.mu_image_nav_back()
            return property
        case .middle:
            property.title = "全部列表"
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 16.0
            return property
        case .right:
            property.image = R.image.mu_image_add()
            property.itemEdgeInset = 22.0;
            return property
        }
    }
}
