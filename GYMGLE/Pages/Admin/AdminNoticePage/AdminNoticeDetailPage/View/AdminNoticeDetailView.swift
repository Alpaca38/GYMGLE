//
//  AdminNoticeDetailView.swift
//  GYMGLE
//
//  Created by 박성원 on 2023/10/14.
//

import UIKit

final class AdminNoticeDetailView: UIView {
    // MARK: - UI Properties
    lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size36Bold, textAligment: .center)
        label.text = "내용"
        return label
    }()
    
    lazy var deletedButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10, borderWidth: 0.0, borderColor: UIColor.clear.cgColor, setTitle: "삭제", font: FontGuide.size19, setTitleColor: .white)
        return button
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "500자 이내로 공지사항을 적어주세요!"
        textView.font = FontGuide.size16
        textView.backgroundColor = .white
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 30
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var contentNumberLabel: UILabel = {
        let label = UILabel()
        label.labelMakeUI(textColor: ColorGuide.black, font: FontGuide.size16, textAligment: .center)
        label.text = "\(contentTextView.text.count)/500"
        return label
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.buttonMakeUI(backgroundColor: ColorGuide.main, cornerRadius: 10.0, borderWidth: 0.0, borderColor: UIColor
            .clear.cgColor, setTitle: "등록하기", font: FontGuide.size19Bold, setTitleColor: UIColor.white)
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorGuide.background
        viewMakeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - extension
private extension AdminNoticeDetailView {
    func viewMakeUI() {
        let views = [pageTitleLabel, deletedButton, contentTextView, contentNumberLabel,createButton]
        for view in views {
            self.addSubview(view)
        }
        NSLayoutConstraint.activate([
            pageTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            pageTitleLabel.bottomAnchor.constraint(equalTo: self.contentTextView.topAnchor, constant: -20),
            pageTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 120),
            
            deletedButton.centerYAnchor.constraint(equalTo: self.pageTitleLabel.centerYAnchor, constant: 0),
            deletedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            deletedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 300),
            
            contentTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            contentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            contentNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36),
            contentNumberLabel.topAnchor.constraint(equalTo: self.contentTextView.bottomAnchor, constant: 10),
            contentNumberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -240),
            
        ])
        createButton.snp.makeConstraints{
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            $0.left.equalTo(self.snp.left).offset(22)
            $0.right.equalTo(self.snp.right).offset(-22)
            $0.height.equalTo(48)
        }
    }
}
