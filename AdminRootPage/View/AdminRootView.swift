//
//  AdminRootView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/13.
//
import UIKit

final class AdminRootView: UIView {
    // MARK: - UIProperties
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size32Bold, textAligment: .center)
        label.text = "헬스장 등록"
        return label
    }()
    private lazy var gymNameLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
        label.text = "JP 헬스장"
        return label
    }()
    private lazy var gymNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size14, textAligment: .left)
        label.text = "010-0000-0000"
        return label
    }()
    private lazy var gymLabelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gymNameLabel,gymNumberLabel])
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    lazy var gymSettingButton: UIButton = {
        let button = UIButton()
        button.shadowButtonMakeUI(backgroundColor: .white, cornerRadius: 16, shadowColor: ColorGuide.shadowBorder.cgColor, shadowOpacity: 1.0, shadowRadius: 8, setTitle: "개인/보안", font: FontGuide.size14, setTitleColor: ColorGuide.main)
        return button
    }()
    // 회원등록 버튼
    lazy var gymUserRegisterButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.white, cornerRadius: 10.0, borderWidth: 1.0, borderColor: ColorGuide.textHint.cgColor, setTitle: "회원등록", font: FontGuide.size19Bold, setTitleColor: ColorGuide.black)
        return button
    }()
    //회원관리 버튼
    lazy var gymUserManageButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.white, cornerRadius: 10.0, borderWidth: 1.0, borderColor: ColorGuide.textHint.cgColor, setTitle: "회원관리", font: FontGuide.size19Bold, setTitleColor: ColorGuide.black)
        return button
    }()
    //QR 스캐너 버튼
    lazy var gymQRCodeButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.white, cornerRadius: 10.0, borderWidth: 1.0, borderColor: ColorGuide.textHint.cgColor, setTitle: "QR스캐너", font: FontGuide.size19Bold, setTitleColor: ColorGuide.black)
        return button
    }()
    //공지사항 버튼
    lazy var gymNoticeButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.white, cornerRadius: 10.0, borderWidth: 1.0, borderColor: ColorGuide.textHint.cgColor, setTitle: "공지작성", font: FontGuide.size19Bold, setTitleColor: ColorGuide.black)
        return button
    }()
    //로그아웃 버튼
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "로그아웃", font: FontGuide.size19Bold, setTitleColor: UIColor.white)
        return button
    }()
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        viewMakeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extension
private extension AdminRootView {
    func viewMakeUI() {
        topMakeUI()
        middleMakeUI()
        bottomMakeUI()
    }
    func topMakeUI() {

        let topView = [pageTitleLabel, gymLabelStackView, gymSettingButton]
        for view in topView {
            self.addSubview(view)
        }
        NSLayoutConstraint.activate([
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            pageTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 88),
            pageTitleLabel.widthAnchor.constraint(equalToConstant: 149),
            
            gymLabelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            gymLabelStackView.topAnchor.constraint(equalTo: self.pageTitleLabel.bottomAnchor, constant: 26),
            gymLabelStackView.trailingAnchor.constraint(equalTo: self.gymSettingButton.leadingAnchor, constant: 0),
            
            gymSettingButton.centerYAnchor.constraint(equalTo: self.gymLabelStackView.centerYAnchor),
            gymSettingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            gymSettingButton.widthAnchor.constraint(equalToConstant: 75),
            gymSettingButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    func middleMakeUI() {
        var middleView = [gymUserRegisterButton, gymUserManageButton, gymQRCodeButton, gymNoticeButton]
        for view in middleView {
            self.addSubview(view)
        }
        NSLayoutConstraint.activate([
            gymUserRegisterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            gymUserRegisterButton.topAnchor.constraint(equalTo: self.gymLabelStackView.bottomAnchor, constant: 45),
            gymUserRegisterButton.widthAnchor.constraint(equalToConstant: 161),
            gymUserRegisterButton.heightAnchor.constraint(equalToConstant: 161),
            
            gymUserManageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            gymUserManageButton.topAnchor.constraint(equalTo: self.gymLabelStackView.bottomAnchor, constant: 45),
            gymUserManageButton.widthAnchor.constraint(equalToConstant: 161),
            gymUserManageButton.heightAnchor.constraint(equalToConstant: 161),
            
            gymQRCodeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            gymQRCodeButton.topAnchor.constraint(equalTo: self.gymUserRegisterButton.bottomAnchor, constant: 20),
            gymQRCodeButton.widthAnchor.constraint(equalToConstant: 161),
            gymQRCodeButton.heightAnchor.constraint(equalToConstant: 161),
            
            gymNoticeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            gymNoticeButton.topAnchor.constraint(equalTo: self.gymUserManageButton.bottomAnchor, constant: 20),
            gymNoticeButton.widthAnchor.constraint(equalToConstant: 161),
            gymNoticeButton.heightAnchor.constraint(equalToConstant: 161),
        ])
    }
    func bottomMakeUI() {
        self.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            logOutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            logOutButton.topAnchor.constraint(equalTo: self.gymQRCodeButton.bottomAnchor, constant: 76),
            logOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}