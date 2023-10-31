//
//  AdminNoticeViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class AdminNoticeViewController: UIViewController {
    
    // MARK: - properties
    private let adminNoticeView = AdminNoticeView()
    var isAdmin: Bool?
    private let ref = Database.database().reference()
    private let userID = Auth.auth().currentUser?.uid
    
    // MARK: - life cycle
    override func loadView() {
        view = adminNoticeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setCustomBackButton()
        dataReadSetting() {
            self.adminNoticeView.noticeTableView.reloadData()
            self.adminNoticeView.pageTitleLabel.text = "개수: \(DataManager.shared.noticeList.count)"
        }
    }
}

// MARK: - extension custom func
private extension AdminNoticeViewController {
    
    func dataReadSetting( completion: @escaping () -> Void) {
        ref.child("users/\(DataManager.shared.gymUid!)/noticeList").observeSingleEvent(of: .value) { DataSnapshot in
            guard let value = DataSnapshot.value as? [String:[String:Any]] else { return
                completion()
            }
            do {
                let jsonArray = value.values.compactMap { $0 as [String: Any] }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                let notices = try JSONDecoder().decode([Notice].self, from: jsonData)
                DataManager.shared.noticeList = notices
                completion()
            } catch let error {
                print("테스트 - \(error)")
                completion()
            }
        }
    }
    func allSetting() {
        adminNoticeView.backgroundColor = ColorGuide.background
        buttonTappedSetting()
        tableSetting()
    }
    func buttonTappedSetting() {
        adminNoticeView.noticeCreateButton.addTarget(self, action: #selector(noticeCreateButtonTapped), for: .touchUpInside)
        switch isAdmin {
        case false: //트레이너 일 때
            adminNoticeView.noticeCreateButton.isHidden = true
        default:
            adminNoticeView.noticeCreateButton.isHidden = false
        }
    }
    func tableSetting() {
        adminNoticeView.noticeTableView.dataSource = self
        adminNoticeView.noticeTableView.delegate = self
        adminNoticeView.noticeTableView.estimatedRowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.rowHeight = UITableView.automaticDimension
        adminNoticeView.noticeTableView.register(AdminNoticeTableViewCell.self, forCellReuseIdentifier: AdminNoticeTableViewCell.identifier)
    }
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .full
        formatter.dateFormat = "MM/dd"
        
        return formatter.string(from: date)
    }
    
    func setCustomBackButton() {
        navigationController?.navigationBar.topItem?.title = "공지사항"
        navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: -  @objc func
extension AdminNoticeViewController {
    @objc private func noticeCreateButtonTapped() {
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        self.navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AdminNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdminNoticeTableViewCell.identifier, for: indexPath) as! AdminNoticeTableViewCell

        cell.nameLabel.text = DataManager.shared.realGymInfo?.gymName
        cell.contentLabel.text = DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row].content
        cell.dateLabel.text = self.dateToString(date: DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row].date)
        
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        return cell
    }
    
}
// MARK: - UITableViewDelegate
extension AdminNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminNoticeDetailVC = AdminNoticeDetailViewController()
        adminNoticeDetailVC.isUser = isAdmin
        adminNoticeDetailVC.noticeInfo = DataManager.shared.noticeList.sorted{ $0.date > $1.date }[indexPath.row]
        navigationController?.pushViewController(adminNoticeDetailVC, animated: true)
    }

}