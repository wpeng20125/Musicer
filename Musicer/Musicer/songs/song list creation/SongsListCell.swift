//
//  SongsListCell.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/1.
//

import UIKit

class SongsListCell: UITableViewCell {
    
    /// 返回一个 cell 实例
    static func cell(withTableView tableView: UITableView)->SongsListCell {  self.cell(tableView) }

    /// 刷新数据
    ///
    /// - Parameters:
    ///   - title: 列表名称
    ///   - image: 列表对应的 icon
    func refresh(withTitle title: String, image icon: UIImage?) { self.set(title, icon) }
    
    
    //MARK: -- lazy
    private lazy var iconView: UIImageView = {
       return UIImageView()
    }()
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.textColor = R.color.mu_color_white()
        return lbl
    }()
    
    private(set) lazy var arrowView: UIImageView = {
       return UIImageView(image: R.image.mu_image_arrow_right())
    }()
}

fileprivate extension SongsListCell {
    
    static var identifier: String { "k_song_list_cell_reuseable_identifier" }
    
    static func cell(_ table: UITableView)->SongsListCell {
        guard let unwrappedCell = table.dequeueReusableCell(withIdentifier: identifier) as? SongsListCell else {
            let cell = SongsListCell(style: .default, reuseIdentifier: identifier)
            cell.backgroundColor = R.color.mu_color_gray_dark()
            cell.contentView.backgroundColor = R.color.mu_color_gray_dark()
            cell.selectionStyle = .none
            cell.setupSubViews()
            return cell
        }
        return unwrappedCell
    }
    
    func setupSubViews() {
        
        self.contentView.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20.0)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 25.0, height: 25.0))
        }
        
        self.contentView.addSubview(self.arrowView)
        self.arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-20.0)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 15.0, height: 15.0));
        }
        
        self.contentView.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconView.snp.right).offset(20.0)
            make.right.equalTo(self.arrowView.snp.left).offset(-20.0)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(25.0)
        }
    }
    
    func set(_ title: String, _ icon: UIImage?) {
        self.titleLbl.text = title
        self.iconView.image = icon
    }
}
