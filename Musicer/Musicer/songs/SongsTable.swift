//
//  PlayingTable.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit

protocol SongsTableDataSource: NSObjectProtocol {
    
    /// 该函数返回 cell 是否可以进行编辑
    /// - Parameter table: SongsTable 实例
    /// - Returns: 返回值，表示是否可以编辑
    func couldCellBeEditableForSongsTbale(_ table: SongsTable)->Bool
}

extension SongsTableDataSource {
    func couldCellBeEditableForSongsTbale(_ table: SongsTable)->Bool { false }
}

protocol SongsTableDelegate: NSObjectProtocol {
    
    /// 当选中某一行 cell 时的回调
    /// - Parameters:
    ///   - table: SongsTable 实例
    ///   - index: 所选中的 cell 的索引
    func songsTable(_ table: SongsTable, didSelectAtIndex index: Int)
    
    /// 把一首歌添加歌单的事件回调
    /// - Parameters:
    ///   - table: SongsTable 实例
    ///   - index: 所要添加的歌曲对应的 cell 的索引
    func songsTable(_ table: SongsTable, addSongToListWithIndex index: Int)
    
    /// 从一个列表中删除一首歌曲的事件回调
    /// - Parameters:
    ///   - table: SongsTable 实例
    ///   - index: 所要删除的歌曲对应的 cell 的索引
    func songsTable(_ table: SongsTable, deleteSongWithIndex index: Int)
}

extension SongsTableDelegate {
    func songsTable(_ table: SongsTable, didSelectAtIndex index: Int) { }
    func songsTable(_ table: SongsTable, addSongToListWithIndex index: Int) { }
    func songsTable(_ table: SongsTable, deleteSongWithIndex index: Int) { }
}

//MARK: -- 列表类
class SongsTable: UIView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_gray_dark()
        self.songs = []
        self.setupSubViews()
    }
    
    /// 刷新列表数据
    func reload(songs: [Song]) {
        self.songs = songs
        self.tableView.reloadData()
    }
    
    func reloadCell(index: Int) {
        
    }
    
    func deleteCell(index: Int) {
        
    }
    
    weak var delegate: SongsTableDelegate?
    weak var dataSource: SongsTableDataSource?
    
    //MARK: -- lazy
    private lazy var songs: [Song] = { [] }()
    private lazy var tableView: UITableView = { UITableView(frame: .zero, style: .grouped) }()
}

extension SongsTable: UITableViewDelegate, UITableViewDataSource {
    
    func setupSubViews() {
        self.tableView.backgroundColor = R.color.mu_color_gray_dark()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.separatorStyle = .none
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    //MARK: -- delegate / dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.songs.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongInfoCell.cell(withTableView: tableView)
        cell.refresh(withSong: self.songs[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.songsTable(self, didSelectAtIndex: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let editable = self.dataSource?.couldCellBeEditableForSongsTbale(self) else { return nil }
        guard editable else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, handler) in
            self.delegate?.songsTable(self, deleteSongWithIndex: indexPath.section)
        }
        deleteAction.image = R.image.mu_image_song_remove()
        deleteAction.backgroundColor = R.color.mu_color_orange_dark()
        
        let addingAction = UIContextualAction(style: .normal, title: nil) { (action, view, handler) in
            self.delegate?.songsTable(self, addSongToListWithIndex: indexPath.section)
        }
        addingAction.image = R.image.mu_image_song_add_list()
        addingAction.backgroundColor = R.color.mu_color_gray_light()
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, addingAction])
        return config
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
