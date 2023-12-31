import UIKit
import Then

class TextFieldCell:UITableViewCell {
    
    lazy var textField = CustomTextField()
    lazy var placeHolderLabel = UILabel().then{
        $0.text = "기본값"
        $0.font = FontGuide.size14Bold
        $0.textColor = ColorGuide.textHint
        
    }
    lazy var CheckButton:UIButton = UIButton()
    
    var isPhoneCell = false
    let charSet:CharacterSet = {
        var set = CharacterSet.decimalDigits
        set.insert(charactersIn: "0123456789-")
        return set.inverted
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        textField.textColor = ColorGuide.textHint
        textField.font = FontGuide.size14Bold
        
        textField.backgroundColor = .clear
        textField.delegate = self
        
        self.layer.frame.size.width = 344.5
        self.backgroundColor = .clear
        self.contentView.clipsToBounds = false
        
        makeUI()
        
        self.contentView.addSubview(placeHolderLabel)
        self.contentView.addSubview(textField)
        
        
        placeHolderLabel.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
//        self.contentView.backgroundColor = .gray
    }
    
    
    func setButton(_ title:String){
        CheckButton = UIButton.GYMGLEWhiteButtonPreset(title)
        self.contentView.addSubview(CheckButton)
        CheckButton.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(74)
            $0.height.equalTo(26)
        }
    }
}

extension TextFieldCell: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.placeHolderLabel.transform = CGAffineTransform(translationX: 0, y: -16)
            self.placeHolderLabel.font = UIFont.systemFont(ofSize: 10)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.textField.text == "" {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
                self.placeHolderLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.placeHolderLabel.font = FontGuide.size14Bold
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isPhoneCell {
            if string.count > 0{
                guard string.rangeOfCharacter(from: charSet) == nil else{
                    return false
                }
            }
            return true
        }
        return true
    }

}
