import UIKit
import Then
import SnapKit

class InitialView: UIView {
    
    // MARK: - Properties
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "GYMGLE")
    }
    
    private lazy var loginLabel = UILabel().then {
        $0.textColor = ColorGuide.black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "로그인"
    }
    
    lazy var idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "아이디"
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
        $0.font = FontGuide.size14
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호"
        $0.autocapitalizationType = .none // 자동으로 맨 앞을 대문자로 할건지
        $0.autocorrectionType = .no // 틀린글자 있을 때 자동으로 잡아 줄지
        $0.spellCheckingType = .no
        $0.font = FontGuide.size14
        $0.isSecureTextEntry = true
    }
    
    lazy var loginButton: UIButton = UIButton.GYMGLEButtonPreset("로그인")
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = .gray
    }
    
    lazy var registerButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .clear, cornerRadius: 10, borderWidth: 0, borderColor: UIColor.clear.cgColor, setTitle: "회원가입", font: FontGuide.size14Bold, setTitleColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.61))
    }

    lazy var adminButton = UIButton().then {
        $0.buttonMakeUI(backgroundColor: .white, cornerRadius: 20, borderWidth: 0.5, borderColor: ColorGuide.shadowBorder.cgColor, setTitle: "관리자모드", font: FontGuide.size14Bold, setTitleColor: ColorGuide.main)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = ColorGuide.background
        
        addSubviews(imageView, loginLabel, idTextField, passwordTextField, loginButton, divider, registerButton, adminButton)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(88)
            $0.left.right.equalToSuperview().inset(124)
            $0.height.equalTo(30)
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(62)
            $0.left.equalToSuperview().offset(29)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(46)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(46)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(28)
            $0.height.equalTo(44)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(0.5)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(46)
        }
        
        adminButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.right.equalToSuperview().offset(-28)
            $0.width.equalTo(90)
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
