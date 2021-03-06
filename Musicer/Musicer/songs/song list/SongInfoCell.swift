//
//  SongInfoCell.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit

class SongInfoCell: UITableViewCell {
    
    /// 返回一个 cell 实例
    class func cell(withTableView tableView: UITableView)->SongInfoCell { SongInfoCell.cell(tableView) }
    
    /// 设置 cell 的数据
    func refresh(withSong song: Song) { self.setData(song) }
    
    
    //MARK: -- private
    private lazy var iconView: UIImageView = {
       let icon = UIImageView()
        return icon
    }()
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.textColor = R.color.mu_color_white()
        return lbl
    }()
    
    private lazy var authorLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textColor = R.color.mu_color_white()
        return lbl
    }()
    
    private lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "DIN Alternate", size: 14.0)
        lbl.textColor = R.color.mu_color_white()
        lbl.textAlignment = .right
        return lbl
    }()
}

fileprivate extension SongInfoCell {
    
    static var identifier: String { "k_song_info_cell_reuseable_identifier" }
    
    static func cell(_ table: UITableView)->SongInfoCell {
        guard let unwrappedCell = table.dequeueReusableCell(withIdentifier: identifier) as? SongInfoCell else {
            let cell = SongInfoCell(style: .default, reuseIdentifier: identifier)
            cell.backgroundColor = R.color.mu_color_gray_dark()
            cell.contentView.backgroundColor = R.color.mu_color_gray_dark()
            cell.selectionStyle = .gray
            cell.setupSubViews()
            return cell
        }
        return unwrappedCell
    }
    
    func setupSubViews() {
        self.iconView.layer.cornerRadius = 10.0
        self.iconView.layer.masksToBounds = true
        self.contentView.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(20.0)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 50.0, height: 50.0))
        }
        
        self.contentView.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconView.snp.right).offset(20.0)
            make.bottom.equalTo(self.contentView.snp.centerY).offset(-5.0)
            make.right.equalTo(self.contentView).offset(-60.0)
        }
        
        self.contentView.addSubview(self.authorLbl)
        self.authorLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconView.snp.right).offset(20.0)
            make.top.equalTo(self.contentView.snp.centerY).offset(5.0)
            make.right.equalTo(self.contentView).offset(-60.0)
        }
        
        self.contentView.addSubview(self.timeLbl)
        self.timeLbl.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-20.0)
            make.centerY.equalTo(self.contentView)
        }
    }
}

fileprivate extension SongInfoCell {
    
    func setData(_ song: Song) {
        self.iconView.image = song.album.image ?? R.image.mu_image_album_placeholder()
        self.titleLbl.text = song.name
        self.authorLbl.text = song.author
        self.timeLbl.text = self.formatTime(time: song.duration)
    }
    
    func formatTime(time: Float)->String {
        let total = Int(ceilf(time))
        let sec = total % 60
        let min = (total - sec) / 60
        let minStr = min >= 10 ? "\(min)" : "0\(min)"
        let secStr = sec >= 10 ? "\(sec)" : "0\(sec)"
        return "\(minStr):\(secStr)"
    }
}
