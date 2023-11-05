//
//  UserCommunityViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/18.
//

import UIKit
import Firebase

class UserCommunityViewController: UIViewController, CommunityTableViewDelegate {
    
    func didSelectCell(at indexPath: IndexPath) {
        let destinationViewController = BoardDetailViewController()
        let data = first.posts[indexPath.row]
        let key = first.keys[indexPath.row]
        destinationViewController.board = data
        destinationViewController.boardUid = key
        
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    let first = UserCommunityView()
    let second = CommunityCell()
    
    var blockedUsers: [String] = [] // 차단한 유저
    
    override func loadView() {
        view = first
        
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
        //        decodeData {
        //            self.first.appTableView.reloadData()
        //        }
        fetchPosts {
            self.first.appTableView.reloadData()
        }
    }
    
    @objc func writePlaceTap() {
        let userCommunityWriteViewController = UserCommunityWriteViewController()
        //        navigationController?.pushViewController(userCommunityWriteViewController, animated: true)
        userCommunityWriteViewController.modalPresentationStyle = .fullScreen
        self.present(userCommunityWriteViewController, animated: true)
    }
    
    func fetchPosts(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("accounts/\(Auth.auth().currentUser!.uid)/blockedUserList")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let blockedUserData = snapshot.value as? [String: Bool] {
                    // 차단 유저 리스트 배열로 저장
                    self.blockedUsers = Array(blockedUserData.keys)
                    
                    let databaseRef = Database.database().reference().child("boards")
                    let numberOfPostsToRetrieve = 30  // 가져올 게시물 개수 (원하는 개수로 수정)
                    
                    databaseRef.queryOrdered(byChild: "date")
                        .queryLimited(toLast: UInt(numberOfPostsToRetrieve))
                        .observeSingleEvent(of: .value) { snapshot in
                            self.first.posts.removeAll() // 데이터를 새로 받을 때 배열 비우기
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
                                            self.first.keys.append(key)
                                        } catch {
                                            print("디코딩 에러")
                                        }
                                    }
                                }
                            }
                            completion()
                        }
                }
            }
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
                for childSnapshot in snapshot.children {
                    if let snapshot = childSnapshot as? DataSnapshot,
                       let data = snapshot.value as? [String: Any],
                       let key = snapshot.key as? String {
                        do {
                            let dataInfoJSON = try JSONSerialization.data(withJSONObject: data, options: [])
                            let dataInfo = try JSONDecoder().decode(Board.self, from: dataInfoJSON)
                            self.first.posts.insert(dataInfo, at: 0) // 가장 최근 게시물을 맨 위에 추가
                            self.first.keys.append(key)
                        } catch {
                            print("디코딩 에러")
                        }
                    }
                }
                completion()
                // 테이블 뷰에 업데이트된 순서대로 표시
                //                self.appTableView.reloadData()
            }
    }
}
