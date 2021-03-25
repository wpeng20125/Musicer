//
//  SongsListController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/19.
//

import UIKit

class SongsListController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
        self.refresh()
    }
    
    //MARK: -- private
    private var table: SongsListTable?
    private var listNames: [String]?
}

fileprivate extension SongsListController {
    
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
        self.table?.delegate = self
        self.view.addSubview(self.table!)
        self.table!.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
    }
}

//MARK: -- Data
fileprivate extension SongsListController {
    
    func refresh() {
        Toaster.showLoading()
        self.listNames = SongManager.default.totalLists()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            Toaster.hideLoading()
            guard let unwrappedNames = self.listNames else {
                Toaster.flash(withText: "暂无歌单，您可以点击 + 创建")
                return
            }
            self.table?.refersh(withNames: unwrappedNames)
        }
    }
}

//MARK: -- create view
fileprivate extension SongsListController {
    
    func showCreateView() {
        
        let maskView = UIView(frame: self.view.bounds)
        maskView.tag = 1979
        maskView.alpha = 0
        maskView.backgroundColor = R.color.mu_color_black_alpha_3()
        self.view.addSubview(maskView)
        
        let createView = SongsListCreateView()
        createView.tag = 1989
        createView.kw_x = (Double(ScreenWidth) - createView.kw_w) / 2
        createView.kw_y = Double(TitleBarHeight) + 150.0
        createView.cancel = {
            self.hideCreateView()
        }
        createView.confirm = { (error) in
            switch error {
            case let .some(desc):
                Toaster.flash(withText: desc)
            case let .none(info):
                self.hideCreateView()
                self.creatList(info)
            }
        }
        self.view.addSubview(createView)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            maskView.alpha = 1.0
        }, completion: nil)
        
        let zoomSpring = CASpringAnimation(keyPath: "transform.scale")
        zoomSpring.mass = 0.5
        zoomSpring.stiffness = 100
        zoomSpring.damping = 5
        zoomSpring.initialVelocity = 0
        zoomSpring.fromValue = 0.01
        zoomSpring.toValue = 1.0
        zoomSpring.duration = zoomSpring.settlingDuration
        
        createView.layer.add(zoomSpring, forKey: "kCreateViewShowAnimationKey")
    }
    
    func hideCreateView() {
        guard let unwrappedCreateView = self.view.viewWithTag(1989),
              let unwrappedMaskView = self.view.viewWithTag(1979) else { return }
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.2
        
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomAnimation.fromValue = 1.0
        zoomAnimation.toValue = 0
        zoomAnimation.duration = 0.2
        
        let group = CAAnimationGroup()
        group.duration = 0.2
        group.animations = [opacityAnimation, zoomAnimation]
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            unwrappedMaskView.alpha = 0
        }) { (complete) in
            unwrappedMaskView.removeFromSuperview()
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { unwrappedCreateView.removeFromSuperview() }
        unwrappedCreateView.layer.add(group, forKey: "kCreateViewHideAnimationKey")
        CATransaction.commit()
    }
    
    func creatList(_ name: String) {
        let error = SongManager.default.creatFolder(withName: name)
        switch error {
        case let .some(desc): Toaster.flash(withText: desc)
        case .none(_): self.refresh()
        }
    }
}

//MARK: -- navigation bar
extension SongsListController: TitleBarDelegate, TitleBarDataSource, SongsListTableDelegate {
   
    //MARK: -- TitleBarDataSource / TitleBarDelegate
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let property = ItemProperty()
        switch p {
        case .left:
            property.image = R.image.mu_image_nav_back()
            return property
        case .middle:
            property.title = "全部歌单"
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 16.0
            return property
        case .right:
            property.image = R.image.mu_image_add()
            property.itemEdgeInset = 22.0;
            return property
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left: self.navigationController?.popViewController(animated: true)
        case .right: self.showCreateView()
        default: return
        }
    }
    
    //MARK: -- SongsListTableDelegate
    func songsListTable(_ table: SongsListTable, didSelectListAtIndex index: Int) {
        guard let unwrappedNames = self.listNames else { return }
        let songsVc = SongsController()
        songsVc.listName = unwrappedNames[index]
        self.navigationController?.pushViewController(songsVc, animated: true)
    }
    
    func songsListTable(_ table: SongsListTable, deleteListAtIndex index: Int) {
        
    }
}
