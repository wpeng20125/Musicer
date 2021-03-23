//
//  SongsListTable.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/1.
//

import UIKit

protocol SongsListTableDelegate: NSObjectProtocol {
    
    /// 选中某一个歌单的回调
    /// - Parameters:
    ///   - table: SongsListTable 实例
    ///   - index: 所选中的列表的索引
    func songsListTable(_ table: SongsListTable, didSelectListAtIndex index: Int)
    
    /// 删除一个歌单
    /// - Parameters:
    ///   - table: SongsListTable 实例
    ///   - index: 所要删除的列表的索引
    func songsListTable(_ table: SongsListTable, deleteListAtIndex index: Int)
}

class SongsListTable: UIView {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_gray_dark()
        self.setupSubViews()
    }
    
    func refersh(withNames names: [String]) {
        self.titles = names
        self.table.reloadData()
    }
    
    var delegate: SongsListTableDelegate?
    
    //MARK: -- private
    private var table: UITableView = { UITableView(frame: .zero, style: .grouped) }()
    private lazy var titles: [String] = { [] }()
}

fileprivate extension SongsListTable {
    
    func setupSubViews() {
        self.table.backgroundColor = R.color.mu_color_gray_dark()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.showsVerticalScrollIndicator = false
        self.table.separatorStyle = .none
        self.table.estimatedRowHeight = 0
        self.table.estimatedSectionHeaderHeight = 0
        self.table.estimatedSectionFooterHeight = 0
        self.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

extension SongsListTable: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: -- delegate / dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongsListCell.cell(withTableView: tableView)
        var img: UIImage?
        if 0 == indexPath.section { img = R.image.mu_image_songs_folder_icon_all() }
        if 1 == indexPath.section { img = R.image.mu_image_songs_folder_icon_like() }
        if 2 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_1() }
        if 3 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_2() }
        if 4 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_3() }
        if 5 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_4() }
        if 6 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_5() }
        if 7 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_6() }
        if 8 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_7() }
        if 9 == indexPath.section { img = R.image.mu_image_songs_folder_icon_custom_8() }
        cell.refresh(withTitle: self.titles[indexPath.section], image: img)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.songsListTable(self, didSelectListAtIndex: indexPath.section)
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
