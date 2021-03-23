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
    
    private var tabele: UITableView?
    private var listNames: [String]?
}

extension SongsListSelectView {
    
    func refresh(withListNames names: [String]?) {
        self.listNames = names
        self.tabele?.reloadData()
    }
}

fileprivate extension SongsListSelectView {
    func setupSubViews() {
        self.tabele = UITableView(frame: .zero, style: .plain)
        self.tabele?.delegate = self
        self.tabele?.dataSource = self
        self.tabele?.showsVerticalScrollIndicator = false
        self.tabele?.isScrollEnabled = false
        self.tabele?.separatorStyle = .none
        self.addSubview(self.tabele!)
        self.tabele?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
}

extension SongsListSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let wrappedListnames = self.listNames else { return 0 }
        return wrappedListnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unwrappedCell = tableView.dequeueReusableCell(withIdentifier: "k_song_list_cell_reuseable_identifier")
        if let wrappedCell = unwrappedCell {
            return wrappedCell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "k_song_list_cell_reuseable_identifier")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wrappedNames = self.listNames,
              let wrappedSelectAction = self.selectRow else {
            return
        }
        wrappedSelectAction(wrappedNames[indexPath.row])
    }
}

