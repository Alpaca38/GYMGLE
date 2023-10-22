//
//  myPageTableView.swift
//  GYMGLE
//
//  Created by 조규연 on 10/22/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class MyPageTableView: UITableView {
    // MARK: - Properties
    
    lazy var cellContents = ["이름", "공지사항", "로그아웃", "탈퇴하기"]
    weak var myPageDelegate: MyPageTableViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        self.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        myPageDelegate?.didSelectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.transform = .identity
        }
    }
}

extension MyPageTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
        cell.label.text = cellContents[indexPath.row]
        
        if indexPath.row == 0 {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "person")
            
            cell.addSubviews(imageView)
            
            imageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(32)
            }
            
            cell.label.snp.makeConstraints {
                $0.left.equalTo(imageView.snp.right).offset(10)
                $0.centerY.equalToSuperview()
            }
        } else {
            cell.label.snp.makeConstraints {
                $0.left.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
