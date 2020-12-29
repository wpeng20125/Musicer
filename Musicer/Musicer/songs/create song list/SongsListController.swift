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
        self.refresh()
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
    }
    
    func refresh() {
        Toaster.showLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            Toaster.hideLoading()
            self.table?.refersh(withNames: SongManager.default.totalLists())
        }
    }
    
    func creatList(_ name: String) {
        let error = SongManager.default.creatFolder(withName: name)
        switch error {
        case let .some(desc):
            Toaster.flash(withText: desc, backgroundColor: R.color.mu_color_orange_dark())
        case .none(_):
            self.refresh()
        }
    }
}

extension SongsListController: TitleBarDelegate, TitleBarDataSource {
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left: self.navigationController?.popViewController(animated: true)
        case .right: self.showCreateView()
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

extension SongsListController: CAAnimationDelegate {
    
    func showCreateView() {
        
        let createView = SongsListCreateView()
        createView.tag = 1989
        createView.kw_x = (Double(ScreenWidth) - createView.kw_w) / 2
        createView.kw_y = Double(TitleBarHeight) + 50.0
        createView.cancel = {
            self.hideCreateView()
        }
        createView.confirm = { (text) in
            self.hideCreateView()
            self.creatList(text)
        }
        self.view.addSubview(createView)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.5
        
        let zoomSpring = CASpringAnimation(keyPath: "transform.scale")
        zoomSpring.mass = 1.0
        zoomSpring.stiffness = 100
        zoomSpring.damping = 10
        zoomSpring.initialVelocity = 10
        zoomSpring.fromValue = 0
        zoomSpring.toValue = 1.0
        zoomSpring.duration = zoomSpring.settlingDuration
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.animations = [opacityAnimation, zoomSpring]
        
        createView.layer.add(group, forKey: "kCreateViewShowAnimationKey")
    }
    
    func hideCreateView() {
        
        guard let createView = self.view.viewWithTag(1989) else { return }
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.2
        
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomAnimation.fromValue = 1.0
        zoomAnimation.toValue = 0
        zoomAnimation.duration = 0.2
        
        let group = CAAnimationGroup()
        group.delegate = self
        group.duration = 0.2
        group.animations = [opacityAnimation, zoomAnimation]
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        
        createView.layer.add(group, forKey: "kCreateViewHideAnimationKey")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let createView = self.view.viewWithTag(1989) else { return }
        createView.removeFromSuperview()
    }
    
}