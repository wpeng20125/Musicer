//
//  SongInfoEditCell.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/4.
//

import UIKit

class SongInfoEditCell: SongInfoCell {
    
    private var editView: UIButton?

    override class func cell(withTableView tableView: UITableView) -> SongInfoEditCell {
        let cell = super.cell(withTableView: tableView) as! SongInfoEditCell
        cell.setOtherSubViews()
        return cell
    }
}

fileprivate extension SongInfoEditCell {
    
    func setOtherSubViews() {
        
        if nil != editView { return }
        
        self.editView = UIButton()
        self.editView?.adjustsImageWhenHighlighted = false
        
    }
    
}


