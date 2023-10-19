//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit

final class AdminRootViewController: UIViewController {
    
    private let adminRootView = AdminRootView()
    private let dataManager = DataManager.shared
    var gymInfo: GymInfo?
    var isAdmin: Bool?
    // MARK: - life cycle
    
    override func loadView() {
        view = adminRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configuredView()
    }
    
}

// MARK: - extension
private extension AdminRootViewController {
    func configuredView() {
        navigationController?.navigationBar.isHidden = true
        deletedButtonHidden()
        adminRootView.dataSetting(dataManager.gymInfo.gymName, dataManager.gymInfo.gymnumber)
    }
    
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
        adminRootView.gymUserRegisterButton.addTarget(self, action: #selector(gymUserRegisterButtonTapped), for: .touchUpInside)
        adminRootView.gymUserManageButton.addTarget(self, action: #selector(gymUserManageButtonTapped), for: .touchUpInside)
        adminRootView.gymQRCodeButton.addTarget(self, action: #selector(gymQRCodeButtonTapped), for: .touchUpInside)
        adminRootView.gymNoticeButton.addTarget(self, action: #selector(gymNoticeButtonTapped), for: .touchUpInside)
        adminRootView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    func deletedButtonHidden() {
        switch isAdmin {
        case false: //트레이너 일 때
            adminRootView.logOutButton.isHidden = true
        default:
            adminRootView.logOutButton.isHidden = false
        }
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    //로그아웃 버튼
    @objc private func gymSettingButtonTapped() {
        if let adminLoginVC = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(adminLoginVC, animated: true)
        }
    }
    //회원등록 버튼
    @objc private func gymUserRegisterButtonTapped() {
        let userRegisterVC = UserRegisterViewController()
        self.navigationController?.pushViewController(userRegisterVC, animated: true)
    }
    //회원 관리버튼
    @objc private func gymUserManageButtonTapped() {
        let userManageVC = UserManageViewController()
        self.navigationController?.pushViewController(userManageVC, animated: true)
    }
    //큐알코드 버튼
    @objc private func gymQRCodeButtonTapped() {
        let qrcodeCheckVC = QRcodeCheckViewController()
        self.navigationController?.pushViewController(qrcodeCheckVC, animated: true)
    }
    //공지사항 버튼
    @objc private func gymNoticeButtonTapped() {
        let adminNoticeVC = AdminNoticeViewController()
        adminNoticeVC.gymInfo = gymInfo
        self.navigationController?.pushViewController(adminNoticeVC, animated: true)
    }
    //탈퇴 버튼
    @objc private func logOutButtonTapped() {
        dataManager.gymList.removeAll(where: {$0.gymAccount.id == gymInfo?.gymAccount.id})
        print(dataManager.gymList)
        if let adminLoginVC = self.navigationController?.viewControllers[1] {
            self.navigationController?.popToViewController(adminLoginVC, animated: true)
        }
    }
}
