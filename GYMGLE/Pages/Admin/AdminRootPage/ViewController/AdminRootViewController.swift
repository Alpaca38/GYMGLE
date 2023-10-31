//
//  AdminRootViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class AdminRootViewController: UIViewController {
    // MARK: - properties
    
    private let adminRootView = AdminRootView()
    var isAdmin: Bool?
    var ref = Database.database().reference()
    
    // MARK: - life cycle
    
    override func loadView() {
        view = adminRootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        configuredView()
        viewSetting()
    }
}

// MARK: - extension
private extension AdminRootViewController {
    func configuredView() {
        navigationController?.navigationBar.isHidden = true
        adminRootView.adminTableView.adminRootDelegate = self
    }
    func viewSetting() {
        allButtonTapped()
        let gymName = DataManager.shared.realGymInfo?.gymName
        let gymPhoneNumber = DataManager.shared.realGymInfo?.gymPhoneNumber
        adminRootView.dataSetting("\(gymName!)", "\(gymPhoneNumber!)")
    }
    func allButtonTapped() {
        adminRootView.gymSettingButton.addTarget(self, action: #selector(gymSettingButtonTapped), for: .touchUpInside)
    }
}

// MARK: - @objc func
extension AdminRootViewController {
    //로그아웃 버튼
    @objc private func gymSettingButtonTapped() {
        signOut()
        dismiss(animated: true) {
            let vc = AdminLoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - Firebase Auth
private extension AdminRootViewController {
    
    // MARK: - 로그아웃
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DataManager.shared.realGymInfo = nil
        } catch _ as NSError { }
    }
    
    // MARK: - 회원탈퇴
    func deleteAccount() {
        // 계정 삭제
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if error != nil {
                } else {
                    let adminLoginVC = AdminLoginViewController()
                    self.navigationController?.pushViewController(adminLoginVC, animated: true)
                }
            }
            //탈퇴한 헬스장의 유저들 삭제
            let query = ref.child("accounts").queryOrdered(byChild: "adminUid").queryEqual(toValue: DataManager.shared.gymUid!)
            query.observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        snapshot.ref.removeValue()
                    }
                }
            }
            // 헬스장 관리자를 데이터베이스에서 삭제
            let userRef = Database.database().reference().child("users").child(user.uid)
            userRef.removeValue()
            signOut()
        } else {}
    }
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        toastView.font = FontGuide.size16Bold
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            toastView.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) + 40),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 24),
        ])
        UIView.animate(withDuration: 2.0, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}

extension AdminRootViewController: AdminTableViewDelegate {
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 공지사항을 선택한 경우
            let adminNoticeVC = AdminNoticeViewController()
            self.navigationController?.pushViewController(adminNoticeVC, animated: true)
            break
        case 1:
            // 회원등록 선택한 경우
            self.navigationController?.pushViewController(UserRegisterViewController(), animated: true)
            break
        case 2:
            // 회원관리를 선택한 경우
            self.navigationController?.pushViewController(UserManageViewController(), animated: true)
            break
        case 3:
            // QR스캐너를 선택한 경우
            self.navigationController?.pushViewController(QRcodeCheckViewController(), animated: true)
            break
        case 4:
            // 정보변경을 선택한 경우
            let adminRegisterVC = AdminRegisterViewController()
            adminRegisterVC.gymInfo = DataManager.shared.realGymInfo
            self.navigationController?.pushViewController(adminRegisterVC, animated: true)
            break
        case 5:
            if isAdmin == false {
                showToast(message: "이 아이디는 탈퇴할 수 없습니다!")
            } else {
                deleteAccount()
            }
            break
        default:
            break
        }
    }
}