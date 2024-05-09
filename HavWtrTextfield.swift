import UIKit

enum TextfieldNameLabelFontOption {
    case standart
    case norwester
}

@IBDesignable
final class HavWtrTextfield: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var textfieldNameLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var dropDownActionView: UIView!
    @IBOutlet private weak var dropDownIcon: UIImageView!
    @IBOutlet private weak var phonebookView: UIView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var phonebookIcon: UIImageView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Private constants
    private let enteredTextfiledColor = ColorManager.primaryBrand.getColor()
    private let emptyTextfieldColor = ColorManager.gray.getColor()
    private let errorTextfieldColor = ColorManager.errorColor.getColor()
    private let inactiveTextfieldColor = ColorManager.noItemsGray.getColor()
    
    // MARK: - Priate variables
    private var isCorrect = true {
        didSet {
            if isCorrect {
                configureCorrectTextfield()
            } else {
                configureErrorTextfield()
            }
        }
    }
    
    private var dropDownIsActive = false {
        didSet {
            dropDownActionView.isHidden = !dropDownIsActive
        }
    }
    
    private var phonebookButtonIsActive = false {
        didSet {
            phonebookView.isHidden = !phonebookButtonIsActive
        }
    }
    
    private var dropDownShown = false {
        didSet {
            dropDownIcon.transform = dropDownIcon.transform.rotated(by: .pi)
        }
    }
    
    private var isInactive = false {
        didSet {
            textfield.textColor = isInactive ? inactiveTextfieldColor : enteredTextfiledColor
            configureSeparatorViewColor()
        }
    }
    
    // MARK: - Variables
    weak var delegate: UITextFieldDelegate? {
        get {
            return textfield.delegate
        }
        set {
            guard let delegate = newValue else { return }
            textfield.delegate = delegate
        }
    }
    
    var dropDownAppearanceAction: (()->())?
    var phonebookAction: (()->())?
    
    // MARK: - Intializators
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commoninit()
    }
    
    // MARK: - Setup
    private func commoninit() {
        let bundle = Bundle(for: HavWtrTextfield.self)
        bundle.loadNibNamed("HavWtrTextfield",
                            owner: self,
                            options: nil)
        
        configureContentView()
        setupUI()
    }
    
    private func configureContentView() {
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupUI() {
        textfieldNameLabel.textColor = enteredTextfiledColor
        setupTextfield()
        dropDownIsActive = false
        dropDownIcon.image = ImageAssetManager.downBlackArrow.getImage()
        phonebookIcon.image = ImageAssetManager.phonebookIcon.getImage()
        phonebookButtonIsActive = false
        configureSeparatorViewColor()
        separatorView.layer.cornerRadius = 1
        setupErrorLabel()
    }
    
    private func setupTextfield() {
        textfield.font = FontManager.openSansRegular.getFont(size: 14)
        textfield.textColor = enteredTextfiledColor
    }
    
    private func setupErrorLabel() {
        errorLabel.font = FontManager.openSansRegular.getFont(size: 12)
        errorLabel.textColor = errorTextfieldColor
    }
    
    private func configureSeparatorViewColor() {
        if isInactive {
            separatorView.backgroundColor = inactiveTextfieldColor
        } else {
            separatorView.backgroundColor = textfield.text == "" ? emptyTextfieldColor : enteredTextfiledColor
        }
    }
    
    private func configureCorrectTextfield() {
        separatorView.backgroundColor = enteredTextfiledColor
        errorLabel.isHidden = true
    }
    
    private func configureErrorTextfield() {
        separatorView.backgroundColor = errorTextfieldColor
        errorLabel.isHidden = false
    }
    
    // MARK: - IBActions
    @IBAction private func showDropDownButtonIsPressed(_ sender: UIButton) {
        dropDownShown.toggle()
        dropDownAppearanceAction?()
    }
    
    @IBAction private func phonebookIconIsPressed(_ sender: UIButton) {
        phonebookAction?()
    }
    
    // MARK: - Flow functions
    func setupTextfieldName(with name: String, with option: TextfieldNameLabelFontOption = .standart) {
        textfieldNameLabel.font = getTextfieldNameFont(for: option)
        textfieldNameLabel.text = name
    }
    
    private func getTextfieldNameFont(for option: TextfieldNameLabelFontOption) -> UIFont? {
        switch option {
        case .standart:
            return FontManager.openSansRegular.getFont(size: 14)
        case .norwester:
            return FontManager.norwesterRegular.getFont(size: 20)
        }
    }
    
    func setupPlaceholder(with text: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: emptyTextfieldColor as Any])
        configureSeparatorViewColor()
    }
    
    func setupKeyboardType(_ keyboardType: UIKeyboardType) {
        textfield.keyboardType = keyboardType
    }
    
    func setupError(isCorrect: Bool, with text: String? = nil) {
        errorLabel.text = text
        self.isCorrect = isCorrect
    }
    
    func enableDropDown(dropDownIsActive: Bool = true) {
        self.dropDownIsActive = dropDownIsActive
    }
    
    func enablePhonebook(phonebookIsActive: Bool = true) {
        self.phonebookButtonIsActive = phonebookIsActive
    }
    
    func setupInputView(_ inputView: UIView, toolBar: UIToolbar? = nil) {
        textfield.inputView = inputView
        textfield.inputAccessoryView = toolBar
    }
    
    func setupText(_ text: String?) {
        textfield.text = text
        configureSeparatorViewColor()
    }
    
    func makeDropDownArrowGetToTheFirstPostion() {
        if dropDownShown {
            dropDownShown = false
        }
    }
    
    func capitalizeFirstLetter() {
        textfield.autocapitalizationType = .words
    }
    
    func capitalizeAllLetters() {
        textfield.autocapitalizationType = .allCharacters
    }
    
    func textfieldIsInactive(_ isInactive: Bool) {
        self.isInactive = isInactive
    }
    
    func checkText(_ text: String?) {
        if isInactive {
            separatorView.backgroundColor = inactiveTextfieldColor
        } else {
            separatorView.backgroundColor = text == "" ? emptyTextfieldColor : enteredTextfiledColor
        }
    }
    
    func hideTextfield() {
        textfield.resignFirstResponder()
    }
}
