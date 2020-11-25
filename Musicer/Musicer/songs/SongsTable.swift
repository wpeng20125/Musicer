//
//  PlayingTable.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit

protocol SongsTableDelegate: NSObjectProtocol {
    func songsTable(_ table: SongsTable, didSelectSong song: Song)
}

extension SongsTableDelegate {
    func songsTable(_ table: SongsTable, didSelectSong song: Song) { }
}

class SongsTable: UIView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_gray_dark()
        self.songs = []
        self.setupSubViews()
    }
    
    weak var delegate: SongsTableDelegate?
    
    /**
     刷新列表数据
     */
    func reload(_ songs: [Song]) {
        self.songs = songs
        self.tableView.reloadData()
    }
    
    
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
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.songsTable(self, didSelectSong: self.songs[indexPath.section])
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
