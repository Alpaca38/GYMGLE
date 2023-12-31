//
//  UserCommunityViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserCommunityViewController: UIViewController, CommunityTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        let destinationViewController:BoardDetailViewController
        if first.nowSearching {
            let data = first.filteredPost[indexPath.row]
            destinationViewController = BoardDetailViewController(board: data)
            let key = first.filteredKeys[indexPath.row]
            destinationViewController.boardUid = key
            

        }else {
            let data = first.posts[indexPath.row]
            destinationViewController = BoardDetailViewController(board: data)
            let key = first.keys[indexPath.row]
            destinationViewController.boardUid = key
        }
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    let first = UserCommunityView()
    let second = CommunityCell()
    
    var blockedUsers: [String] = [] // 차단한 유저
    
    override func loadView() {
        view = first
        
    }
    
    deinit{
        removeAllObserve()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.writePlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writePlaceTap)))
        first.delegate = self
        self.view = first
    }
    
    override func viewWillAppear(_ animated: Bool) { // 네비게이션바 보여주기
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false

        first.refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        first.appTableView.refreshControl = first.refreshController
        self.getBlockedUserList {
            self.decodeData {
                print("테스트 - \(self.first.posts)")
                self.downloadProfiles {
                    self.first.appTableView.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        first.endEditing(true)
    }
    
    @objc func writePlaceTap() {
        if DataManager.shared.profile == nil {
            self.showToast(message: "프로필 설정 후 게시글 작성을 이용해주세요.")
        } else {
            let userCommunityWriteViewController = UserCommunityWriteViewController()
            userCommunityWriteViewController.modalPresentationStyle = .fullScreen
            self.present(userCommunityWriteViewController, animated: true)
        }
    }
    @objc private func refreshData() {
        self.getBlockedUserList {
            self.decodeData {
                self.downloadProfiles {
                    DispatchQueue.main.async {
                        self.first.refreshController.endRefreshing()
                        self.first.appTableView.reloadData()
                    }
                }
            }
        }
    }
    func getBlockedUserList(completion: @escaping () -> ()) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let blockedUserData = snapshot.value as? [String: Bool] {
                    // 차단 유저 리스트 배열로 저장
                    self.blockedUsers = Array(blockedUserData.keys)
                }
            }
            completion()
        }
    }
}

extension UserCommunityViewController {
    func decodeData(completion: @escaping () -> Void) {
        let databaseRef = Database.database().reference().child("boards")
        
        let numberOfPostsToRetrieve = 30  // 가져올 게시물 개수 (원하는 개수로 수정)
        databaseRef.queryOrdered(byChild: "date")
            .queryLimited(toLast: UInt(numberOfPostsToRetrieve))
            .observeSingleEvent(of: .value) { snapshot in
                self.first.posts.removeAll() // 데이터를 새로 받을 때 배열 비우기
                self.first.keys.removeAll()
                for childSnapshot in snapshot.children {
                    if let snapshot = childSnapshot as? DataSnapshot,
                       let data = snapshot.value as? [String: Any],
                       let key = snapshot.key as? String,
                       let uid = data["uid"] as? String {
                        
                        // 차단한 유저인지 확인
                        if !self.blockedUsers.contains(uid) {
                            do {
                                let dataInfoJSON = try JSONSerialization.data(withJSONObject: data, options: [])
                                let dataInfo = try JSONDecoder().decode(Board.self, from: dataInfoJSON)
                                self.first.posts.insert(dataInfo, at: 0)
                                self.first.keys.insert(key, at: 0)
                            } catch {
                                print("디코딩 에러2")
                            }
                        }
                    }
                }
                
                completion()
                // 테이블 뷰에 업데이트된 순서대로 표시
                //                self.appTableView.reloadData()
            }
    }
    
    func downloadProfiles( complition: @escaping () -> () ){
        self.first.profiles.removeAll()
        var count = self.first.posts.count {
            didSet(oldVal){
                if count == 0 {
                    for i in temp {
                        self.first.profiles.append(tempProfiles[i]!)
                    }
                    complition()
                }
            }
        }
        
        let ref = Database.database().reference()
        var temp:[String] = []
        var tempProfiles:[String:Profile] = [:]
        let emptyProfile = Profile(image: URL(fileURLWithPath: "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F2513B53E55DB206927"), nickName: "탈퇴한 회원")
        for i in self.first.posts {
            temp.append(i.uid)
            ref.child("accounts/\(i.uid)/profile").observeSingleEvent(of: .value) {DataSnapshot    in
                do {
                    if DataSnapshot.value! is NSNull {
                        tempProfiles.updateValue(emptyProfile, forKey: i.uid)
                        self.first.profilesWithKey.updateValue(emptyProfile, forKey: i.uid)
                        count -= 1
                    }else {
                        let JSONdata = try JSONSerialization.data(withJSONObject: DataSnapshot.value!)
                        let profile = try JSONDecoder().decode(Profile.self, from: JSONdata)
                        tempProfiles.updateValue(profile, forKey: i.uid)
                        self.first.profilesWithKey.updateValue(profile, forKey: i.uid)
                        count -= 1
                    }
                }catch {
                    print("테스트 - fail - 커뮤니티뷰 프로필 불러오기 실패")
                    self.first.profilesWithKey.updateValue(emptyProfile, forKey: i.uid)
                }
                
            }
            
        }
        
        
    }
    func removeAllObserve() {
        let databaseRef = Database.database().reference().child("boards")
        databaseRef.removeAllObservers()
    }

    
    func getCommentCountForBoard(boardUid: String, completion: @escaping (Int) -> Void) {
        let databaseRef = Database.database().reference()
        let boardRef = databaseRef.child("boards").child(boardUid)
        
        boardRef.observeSingleEvent(of: .value) { snapshot in
            if let boardData = snapshot.value as? [String: Any] {
                if let commentCount = boardData["commentCount"] as? Int {
                    completion(commentCount)
                } else {
                    completion(0)
                }
            } else {
                completion(0)
            }
        }
    }
    
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 17),
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) { //2.5초
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}

extension URL {
    init(staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }
}
