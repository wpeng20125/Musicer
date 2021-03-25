//
//  SongsListSelectView.swift
//  Musicer
//
//  Created by 王朋 on 2021/3/23.
//

import UIKit

class SongsListSelectView: UIView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
    }
    
    var selectRow: ((String)->Void)?
    
    private lazy var tabele: UITableView = { UITableView(frame: .zero, style: .grouped) }()
    private lazy var listNames: [String] = { [] }()
}

extension SongsListSelectView {
    
    func refresh(withListNames names: [String]) {
        self.listNames = names
        self.tabele.reloadData()
    }
}

fileprivate extension SongsListSelectView {
    
    func setupSubViews() {
        self.tabele.delegate = self
        self.tabele.dataSource = self
        self.tabele.showsVerticalScrollIndicator = false
        self.tabele.isScrollEnabled = false
        self.tabele.separatorStyle = .none
        self.tabele.backgroundColor = R.color.mu_color_gray_dark()
        self.addSubview(self.tabele)
        self.tabele.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
}

extension SongsListSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongsListCell.cell(withTableView: tableView)
        var img: UIImage?
        if nil != self.listNames.firstIndex(of: k_list_name_found) {
            if 0 == indexPath.section { img = R.image.mu_image_songs_folder_icon_like() }
            else { img = UIImage(named: "mu_image_songs_folder_icon_custom_" + "\(indexPath.section)") }
        }else {
            img = UIImage(named: "mu_image_songs_folder_icon_custom_" + "\(indexPath.section + 1)")
        }
        cell.refresh(withTitle: self.listNames[indexPath.section], image: img)
        cell.arrowView.isHidden = true
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrappedSelectAction = self.selectRow,
              let unwrappedCell = tableView.cellForRow(at: indexPath) else { return }
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomAnimation.fromValue = 1.0
        zoomAnimation.toValue = 1.3
        zoomAnimation.duration = 0.2
        zoomAnimation.autoreverses = true
        CATransaction.begin()
        CATransaction.setCompletionBlock { [unowned self] in
            unwrappedSelectAction(self.listNames[indexPath.section])
        }
        unwrappedCell.layer.add(zoomAnimation, forKey: "k_cell_zoom_animation_key")
        CATransaction.commit()
    }
    
    // header / footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 1.0))
        topLine.backgroundColor = R.color.mu_color_black()
        footer.addSubview(topLine)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: 1, width: ScreenWidth, height: 1.0))
        bottomLine.backgroundColor = R.color.mu_color_gray_light()
        footer.addSubview(bottomLine)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
}

