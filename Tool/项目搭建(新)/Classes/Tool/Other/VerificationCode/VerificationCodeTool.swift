//
//  VerificationCodeTool.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/2.
//  完全独立出来，不依赖任何库

import UIKit

//MARK: - 验证码
class VerificationCodeTool: UIView {
    static let shared = VerificationCodeTool(frame: UIScreen.main.bounds)
    
    typealias replaceBtnBlock = ((UIImageView) -> ())
    typealias defineBtnBlock = ((String?) -> ())
    
    private var clickReplaceBtnBlock: replaceBtnBlock?  // 点击换一张
    private var clickDefineBtnBlock: defineBtnBlock?    // 点击确认
    
    private let whiteView = UIView()
    private let titleLabel = UILabel()
    private let codeTextField = UITextField()
    private let codeImgView = UIImageView()
    private let replaceBtn = UIButton()
    private let defineBtn = UIButton()
    private let closeBtn = UIButton()
    
    private var closeBtnRect: CGRect?
    
    var textCount = 6

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = colorWithStyleLight(UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), Dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        
        createUI()
        createAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}


//MARK: - UI
extension VerificationCodeTool {
    func createUI() {
        self.addSubview(whiteView)
        self.whiteView.addSubview(titleLabel)
        self.whiteView.addSubview(codeTextField)
        self.whiteView.addSubview(codeImgView)
        self.whiteView.addSubview(replaceBtn)
        self.whiteView.addSubview(defineBtn)
        self.addSubview(closeBtn)
        
        /* 白色背景 */
        whiteView.backgroundColor = self.colorWithStyleLight(.white, Dark: .black)
        whiteView.layer.cornerRadius = 10
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        
        /* 标题 */
        titleLabel.text = "请输入图形验证码"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.init(name: "PingFangSC-Medium", size: 18)
        titleLabel.textColor = self.colorWithStyleLight(.black, Dark: .white)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /* 输入框 */
        let attributedPlaceholder = NSMutableAttributedString(string: "请输入验证码")
        attributedPlaceholder.addForegroundColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        codeTextField.attributedPlaceholder = attributedPlaceholder
        codeTextField.layer.cornerRadius = 4
        codeTextField.layer.borderWidth = 1
        codeTextField.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        codeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        codeTextField.leftViewMode = .always
        codeTextField.delegate = self
        codeTextField.keyboardType = .asciiCapable
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        /* 验证码图片 */
        codeImgView.layer.cornerRadius = 4
        codeImgView.layer.borderWidth = 0.5
        codeImgView.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        codeImgView.isUserInteractionEnabled = true
        codeImgView.translatesAutoresizingMaskIntoConstraints = false
        codeImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickReplaceBtn)))
        
        /* 换一张 */
        replaceBtn.setTitle("换一张", for: .normal)
        replaceBtn.setTitleColor(.systemGray, for: .normal)
        replaceBtn.titleLabel?.font = .systemFont(ofSize: 13)
        replaceBtn.addTarget(self, action: #selector(clickReplaceBtn), for: .touchUpInside)
        replaceBtn.translatesAutoresizingMaskIntoConstraints = false
        
        /* 确认 */
        defineBtn.setTitle("确定", for: .normal)
        defineBtn.setTitleColor(colorWithStyleLight(.black, Dark: .white), for: .normal)
        defineBtn.layer.borderWidth = 1
        defineBtn.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        defineBtn.layer.cornerRadius = 5
        defineBtn.addTarget(self, action: #selector(clickDefineBtn), for: .touchUpInside)
        defineBtn.translatesAutoresizingMaskIntoConstraints = false
        
        /* 关闭按钮 */
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
        closeBtn.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "VerificationCode_CloseImg.png", ofType: nil) ?? ""), for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutWhiteView()
        layoutTitleLabel()
        layoutCodeTextField()
        layoutCodeImgView()
        layoutReplaceBtn()
        layoutDefineBtn()
        layoutCloseBtn()
    }
    
    /**
     布局白色背景
     */
    func layoutWhiteView() {
        let layout_CenterX = NSLayoutConstraint(item: whiteView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let layout_CenterY = NSLayoutConstraint(item: whiteView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        let layout_Left = NSLayoutConstraint(item: whiteView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 25)
        
        let layout_Right = NSLayoutConstraint(item: whiteView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -25)
        
        self.addConstraints([layout_CenterX, layout_CenterY, layout_Left, layout_Right])
    }
    
    /**
     布局标题
     */
    func layoutTitleLabel() {
        let layout_CenterX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: whiteView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let layout_Top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1.0, constant: 20)
        
        let layout_Left = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1.0, constant: 20)
        
        let layout_Right = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1.0, constant: -20)
    
        self.addConstraints([layout_CenterX, layout_Top, layout_Left, layout_Right])
    }
    
    /**
     布局输入框
     */
    func layoutCodeTextField() {
        let layout_Top = NSLayoutConstraint(item: codeTextField, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 20)
        
        let layout_Left = NSLayoutConstraint(item: codeTextField, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1.0, constant: 20)
        
        let layout_Height = NSLayoutConstraint(item: codeTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        
        let layout_Right = NSLayoutConstraint(item: codeTextField, attribute: .right, relatedBy: .equal, toItem: codeImgView, attribute: .left, multiplier: 1.0, constant: -15)
        
        self.addConstraints([layout_Top, layout_Left, layout_Height, layout_Right])
    }
    
    /**
     布局验证码图片
     */
    func layoutCodeImgView() {
        
        let layout_Top = NSLayoutConstraint(item: codeImgView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 20)
        
        let layout_Right = NSLayoutConstraint(item: codeImgView, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1.0, constant: -20)
        
        let layout_Width = NSLayoutConstraint(item: codeImgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        
        let layout_Height = NSLayoutConstraint(item: codeImgView, attribute: .height, relatedBy: .equal, toItem: codeTextField, attribute: .height, multiplier: 1.0, constant: 0)
        
        self.addConstraints([layout_Top, layout_Right, layout_Height, layout_Width])
    }
    
    /**
     布局换一张按钮
     */
    func layoutReplaceBtn() {
        let layout_Top = NSLayoutConstraint(item: replaceBtn, attribute: .top, relatedBy: .equal, toItem: codeImgView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let layout_CenterX = NSLayoutConstraint(item: replaceBtn, attribute: .centerX, relatedBy: .equal, toItem: codeImgView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let layout_Height = NSLayoutConstraint(item: replaceBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        
        self.addConstraints([layout_Top, layout_CenterX, layout_Height])
    }
    
    /**
     布局确认按钮
     */
    func layoutDefineBtn() {
        let layout_CenterX = NSLayoutConstraint(item: defineBtn, attribute: .centerX, relatedBy: .equal, toItem: whiteView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let layout_Top = NSLayoutConstraint(item: defineBtn, attribute: .top, relatedBy: .equal, toItem: replaceBtn, attribute: .bottom, multiplier: 1.0, constant: 15)
        
        let layout_Left = NSLayoutConstraint(item: defineBtn, attribute: .left, relatedBy: .equal, toItem: codeTextField, attribute: .left, multiplier: 1.0, constant: 0)
        
        let layout_Right = NSLayoutConstraint(item: defineBtn, attribute: .right, relatedBy: .equal, toItem: codeImgView, attribute: .right, multiplier: 1.0, constant: 0)
        
        let layout_Bottom = NSLayoutConstraint(item: defineBtn, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .bottom, multiplier: 1.0, constant: -20)
        
        let layout_Height = NSLayoutConstraint(item: defineBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 42)
        
        self.addConstraints([layout_CenterX, layout_Top, layout_Left, layout_Right, layout_Bottom, layout_Height])
    }
    
    /**
     布局关闭按钮
     */
    func layoutCloseBtn() {
        let layout_Right = NSLayoutConstraint(item: closeBtn, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1.0, constant: 0)
        
        let layout_Bottom = NSLayoutConstraint(item: closeBtn, attribute: .bottom, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1.0, constant: -10)
        
        let layout_Width = NSLayoutConstraint(item: closeBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        
        let layout_Height = NSLayoutConstraint(item: closeBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        
        self.addConstraints([layout_Right, layout_Bottom, layout_Width, layout_Height])
    }
    
    /**
     适配暗黑模式颜色
     */
    func colorWithStyleLight(_ light: UIColor, Dark dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return light
                }else {
                    return dark
                }
            }
        } else {
            return light
        }
    }
}

//MARK: - 私有Action
extension VerificationCodeTool: UITextFieldDelegate {
    private func createAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     私有：点击确认
     */
    @objc private func clickDefineBtn() {
        self.endEditing(true)
        self.clickDefineBtnBlock?(codeTextField.text)
    }
    
    /**
     私有：点击换一张或点击图片
     */
    @objc private func clickReplaceBtn() {
        self.clickReplaceBtnBlock?(codeImgView)
    }
    
    /**
     私有： 点击关闭
     */
    @objc private func clickCloseBtn() {
        self.endEditing(true)
        VerificationCodeTool.hide()
    }
    
    /**
     键盘即将弹出
     */
    @objc private func keyBoardWillShow(_ notifacation: Notification) {
        if closeBtnRect == nil {
            closeBtnRect = closeBtn.frame
        }
        
        let keyBoardBounds = notifacation.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect
        let keyBoardY = UIScreen.main.bounds.height - (keyBoardBounds?.height ?? 0)
        let whiteHeightY = whiteView.frame.origin.y + whiteView.frame.size.height + 45
        
        if whiteHeightY > keyBoardY {
            let duration = notifacation.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? CGFloat ?? 0.25
            let value = whiteView.frame.origin.y - (whiteHeightY - keyBoardY)
            
            
            UIView.animate(withDuration: TimeInterval(duration)) { [weak self] in
                self?.whiteView.frame.origin = CGPoint(x: self!.whiteView.frame.origin.x, y: value)
                self?.closeBtn.frame.origin = CGPoint(x: self!.closeBtn.frame.origin.x, y: value - self!.closeBtn.frame.height - 10)
            }
        }
    }
    
    /**
     键盘即将收起
     */
    @objc private func keyBoardWillHide(_ notifacation: Notification) {
        let duration = notifacation.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? CGFloat ?? 0.25
        UIView.animate(withDuration: TimeInterval(duration)) { [weak self] in
            self?.whiteView.center = self!.center
            
            if let rect = self?.closeBtnRect {
                self?.closeBtn.frame = rect
            }else {
                self?.clickCloseBtn()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count ?? 0 >= 6 && string.count > 0 {
            return false
        }
        
        if self.hasEmoji(str: string) {
            return false
        }
        
        return true
    }
    
    /**
     20.判断是不是Emoji Returns: true false
     */
    func hasEmoji(str: String) -> Bool {
        if self.isNineKeyBoard(str: str){
            return false
        }
        for scalar in str.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF,
                  0x1F1FF...0x1F3F3:
                return true
            default:
                continue
            }
        }
        
        return false
    }
    
    /**
     22.判断输入法是不是九宫格
     */
    func isNineKeyBoard(str: String)->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = str.count
        if len == 0 {
            return false
        }
        
        for _ in 0 ..< len {
            if !(other.range(of: str).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
}

//MARK: - 公共Action
extension VerificationCodeTool {
    /**
     展示验证码
     */
    @objc class func show() {
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.last else {
            #if Debug
                fatalError("【VerificationCodeTool】 - 获取window为nil")
            #endif
            return
        }
        window.endEditing(true)
        window.addSubview(VerificationCodeTool.shared)
    }
    
    /**
     隐藏
     */
    @objc class func hide() {
        NotificationCenter.default.removeObserver(self)
        VerificationCodeTool.shared.codeTextField.text = nil
        VerificationCodeTool.shared.codeImgView.image = nil
        VerificationCodeTool.shared.removeFromSuperview()
    }
    
    /**
     点击确认
     */
    @objc class func clickDefineBlock(_ block: @escaping defineBtnBlock) {
        VerificationCodeTool.shared.clickDefineBtnBlock = block
    }
    
    /**
     点击换一张
     */
    @objc class func clickReplaceBlock(_ block: @escaping replaceBtnBlock) {
        VerificationCodeTool.shared.clickReplaceBtnBlock = block
        VerificationCodeTool.shared.clickReplaceBtnBlock?(VerificationCodeTool.shared.codeImgView)
    }
}
