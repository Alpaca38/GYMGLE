//
//  UserMyProfileUpdateViewController.swift
//  GYMGLE
//
//  Created by 박성원 on 10/31/23.
//

import UIKit
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

final class UserMyProfileUpdateViewController: UIViewController {

    // MARK: - pripertise
    let userMyprofileUpdateView = UserMyProfileUpdateView()
    
    // MARK: - life cycle

    override func loadView() {
        view = userMyprofileUpdateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allSetting()
        if DataManager.shared.profile?.nickName == nil {
            showToast(message: "프로필을 먼저 설정해주세요.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}


// MARK: - private extension custom func

private extension UserMyProfileUpdateViewController {
    
    func allSetting() {
        userMyprofileUpdateView.nickNameTextField.delegate = self
        allButtonSetting()
    }
    
    func allButtonSetting() {
        userMyprofileUpdateView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.imageButton.addTarget(self, action:  #selector(imageButtonTapped), for: .touchUpInside)
        userMyprofileUpdateView.successedButton.addTarget(self, action:  #selector(successedButtonTapped), for: .touchUpInside)
    }
    
    func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = Auth.auth().currentUser!.uid + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("profiles").child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    func createdProfile(url: URL) {
        guard let nickName = userMyprofileUpdateView.nickNameTextField.text else { return }
        let newProfile = Profile(nickName: nickName, image: url)
        let ref = Database.database().reference().child("profiles/\(Auth.auth().currentUser!.uid)/profile")
        do {
            let profileData = try JSONEncoder().encode(newProfile)
            let profileJSON = try JSONSerialization.jsonObject(with: profileData, options: [])
            ref.setValue(profileJSON)
        } catch {
            print("테스트 - error")
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
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
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

// MARK: - extension @objc func

extension UserMyProfileUpdateViewController {
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func imageButtonTapped() {
        setupImagePicker()
    }
    @objc private func successedButtonTapped() {
        uploadImage(image: userMyprofileUpdateView.profileImageView.image!) { url in
            if let url = url {
                DataManager.shared.profile?.image = url
                self.createdProfile(url: url)
            }
                
        }
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension UserMyProfileUpdateViewController: UITextFieldDelegate {
    
}

// MARK: - PHPickerViewController

extension UserMyProfileUpdateViewController {
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}


extension UserMyProfileUpdateViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider: NSItemProvider? = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.userMyprofileUpdateView.profileImageView.image = image.resized(to: CGSize(width: 100, height: 100))
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}
