//
//  UserCommnunityWriteViewController.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 2023/10/19.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class UserCommunityWriteViewController: UIViewController {
    let userCommunityWriteView = UserCommunityWriteView()
    let userCommunityView = UserCommunityView()

    let first = UserCommunityWriteView()

    var isUpdate = false
    var fromBoardClosure = {}
    var boardContent:String?
    var boardUid:String?
    
    var posts: [Board]?
    
    var noticeInfo: Notice? {
        didSet {
            userCommunityWriteView.writePlace.text = noticeInfo?.content
        }
    }
    
    override func loadView() {
        view = first
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createButtonTapped)))
        
        first.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(        createBoardButtonTapped)))
        first.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        if isUpdate {
            self.first.writePlace.text = boardContent!
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension UserCommunityWriteViewController {
    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        if let userInfo = notification.userInfo,
//           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//            let keyboardHeight = keyboardFrame.height
//            let textFieldFrameInWindow = userCommunityWriteView.countNumberLabel.convert(userCommunityWriteView.countNumberLabel.bounds, to: nil)
//            let maxY = textFieldFrameInWindow.maxY
//            if maxY > (userCommunityWriteView.frame.size.height - keyboardHeight) {
//                let scrollOffset = maxY - (userCommunityWriteView.frame.size.height - keyboardHeight)
//                userCommunityWriteView.frame.origin.y = -scrollOffset
//            }
//        }
//    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        userCommunityWriteView.frame.origin.y = 0
    }
    @objc private func createButtonTapped() {
        if userCommunityWriteView.writePlace.text.isEmpty || userCommunityWriteView.writePlace.text == "내용을 입력하세요." {
        } else {
            // 여기에 등록 및 수정 코드 작성❗️
            if noticeInfo == nil {
                let date = Date()
                let content = userCommunityWriteView.writePlace.text
                
                var newNotice = Notice(date: date, content: content ?? "")
                print(newNotice)
                
            } else {
                noticeInfo?.content = userCommunityWriteView.writePlace.text
                noticeInfo?.date = Date()
            }
            
            userCommunityView.appTableView.reloadData()
        }
    }
}
extension UserCommunityWriteViewController{
    
}
extension UserCommunityWriteViewController: UITextViewDelegate {
    
    func createdBoard() {
        if let user = Auth.auth().currentUser {
          let uid = user.uid
          guard let boardText = first.writePlace.text else { return }
          let currentDate = Date()
          if isUpdate {
              if boardText == boardContent{
                  print("테스트 - 같은내용으로 작성함 내용수정 불가")
              } else {
                  let ref = Database.database().reference().child("boards/\(boardUid!)")
                  do {
                      ref.updateChildValues(["content":boardText,"isUpdated":true])
                  } catch {
                      print("게시물을 저장하는 동안 오류 발생: \(error)")
                  }
              }
          } else {
            // 이 부분에서 DataManager.shared.profile을 사용하여 프로필 정보를 가져옵니다.
            if let profile = DataManager.shared.profile {
              // 게시물을 생성하고 DataManager.shared.profile을 할당합니다.
                let newBoard = Board(uid: uid, content: boardText, date: currentDate, isUpdated: false, likeCount: 0, commentCount: 0)
              // Firebase에 게시물을 저장합니다.
              let ref = Database.database().reference().child("boards").childByAutoId()
              do {
                let boardData = try JSONEncoder().encode(newBoard)
                let boardJSON = try JSONSerialization.jsonObject(with: boardData, options: [])
                ref.setValue(boardJSON)
              } catch {
                print("게시물을 저장하는 동안 오류 발생: \(error)")
              }
            } else {
              print("프로필 정보가 없습니다.")
            }
          }
        }
      }

    @objc private func createBoardButtonTapped() {
        if let text = userCommunityWriteView.writePlace.text {
            self.createdBoard()
            dismiss(animated: true, completion: nil)
            self.fromBoardClosure()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if userCommunityWriteView.writePlace.text == "내용을 입력하세요." {
            userCommunityWriteView.writePlace.text = nil
            userCommunityWriteView.writePlace.textColor = ColorGuide.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if userCommunityWriteView.writePlace.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            userCommunityWriteView.writePlace.text = "내용을 입력하세요."
            userCommunityWriteView.writePlace.textColor = .lightGray
        }
    }
    
    
//    func textViewDidChange(_ textView: UITextView) {
//        if userCommunityWriteView.writePlace.text.count > 1000 {
//            userCommunityWriteView.writePlace.deleteBackward()
//        }
//        userCommunityWriteView.countNumberLabel.text = "\(userCommunityWriteView.writePlace.text.count)/1000"
//        
//        if userCommunityWriteView.writePlace.text.count > 880 {
//            let attributedString = NSMutableAttributedString(string: "\(userCommunityWriteView.writePlace.text.count)/1000")
//            attributedString.addAttribute(.foregroundColor, value: ColorGuide.main, range: ("\(userCommunityWriteView.writePlace.text.count)/1000" as NSString).range(of:"\(userCommunityWriteView.writePlace.text.count)"))
//            userCommunityWriteView.countNumberLabel.attributedText = attributedString
//        }
//    }
}


