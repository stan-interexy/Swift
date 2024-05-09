import UIKit
import DropDown

@IBDesignable
final class MainPersonInfoView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var firstNameTextfield: HavWtrTextfield!
    @IBOutlet private weak var lastNameTextfield: HavWtrTextfield!
    @IBOutlet private weak var emailTextfield: HavWtrTextfield!
    @IBOutlet private weak var sexTextfield: HavWtrTextfield!
    @IBOutlet private weak var femaleOptionCheckboxStackview: UIStackView!
    @IBOutlet private weak var femalesSpacingView: UIView!
    @IBOutlet private var femaleOptionCheckboxes: [HavWtrCheckbox]!
    @IBOutlet private weak var birthDateTextfield: HavWtrTextfield!
    @IBOutlet private weak var valueSwitcherView: UIView!
    @IBOutlet private weak var valueSystemLabelHeader: UILabel!
    @IBOutlet private weak var valueSystemSwitcher: HavWtrSwitcher!
    @IBOutlet private weak var weightTextfield: HavWtrTextfield!
    @IBOutlet private weak var heightTextfield: HavWtrTextfield!
    @IBOutlet private weak var dropdownClimateTextfield: HavWtrTextfield!
    
    // MARK: - Private constants
    private let sexDropDownMenu = DropDown()
    private let climateDropDownMenu = DropDown()
    private let birthDatePicker = UIDatePicker()
    private let weightPickerView = UIPickerView()
    private let heightPickerView = UIPickerView()
    private let textfieldWorker = MainPersonInfoViewWorker()
    
    // MARK: - Private variables
    private var checkButtonState: ((Bool)->())?
    
    // MARK: - Variables
    var isInactive = false {
        didSet {
            self.isUserInteractionEnabled = !isInactive
            firstNameTextfield.textfieldIsInactive(isInactive)
            lastNameTextfield.textfieldIsInactive(isInactive)
            sexTextfield.textfieldIsInactive(isInactive)
            emailTextfield.textfieldIsInactive(isInactive)
            birthDateTextfield.textfieldIsInactive(isInactive)
            for element in femaleOptionCheckboxes {
                element.checkboxIsInactive = isInactive
            }
            valueSystemSwitcher.switcherIsInactive = isInactive
            weightTextfield.textfieldIsInactive(isInactive)
            heightTextfield.textfieldIsInactive(isInactive)
            dropdownClimateTextfield.textfieldIsInactive(isInactive)
        }
    }
    
    var familyMemberInfoHidden = false {
        didSet {
            valueSwitcherView.isHidden = familyMemberInfoHidden
            emailTextfield.isHidden = familyMemberInfoHidden
            textfieldWorker.needsEmail = !familyMemberInfoHidden
        }
    }

    var metricSystem: MetricSystemOption = .metric {
        didSet {
            textfieldWorker.measurement = metricSystem
            textfieldWorker.weightModel.weightOption = metricSystem == .imperial ? .lbs : .kg
            textfieldWorker.heightModel.heightOption = metricSystem == .imperial ? .ft : .cm
            weightTextfield.setupTextfieldName(with: "WEIGHT" + " (\(textfieldWorker.weightModel.weightOption.rawValue.uppercased()))",
                                                    with: .norwester)
            heightTextfield.setupTextfieldName(with: "HEIGHT" + " (\(textfieldWorker.heightModel.heightOption.rawValue.uppercased()))",
                                                    with: .norwester)
        }
    }
    
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
        let bundle = Bundle(for: MainPersonInfoView.self)
        bundle.loadNibNamed("MainPersonInfoView",
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
        setupFirstNameTextfield()
        setupLastNameTextfield()
        setupEmailTextfield()
        setupSexTextfield()
        setupSexDropDown()
        setupFemaleOptionCheckboxes()
        setupBirthDateTextfield()
        setupValueSystemLabelHeader()
        setupValueSystemSwitcher()
        setupWeightTextfield()
        setupHeightTextfield()
        setupDropdownClimateTextfield()
        setupClimateDropDown()
    }

    private func setupFirstNameTextfield() {
        firstNameTextfield.setupTextfieldName(with: "FIRST NAME", with: .norwester)
        firstNameTextfield.setupPlaceholder(with: "Enter your first name")
        firstNameTextfield.capitalizeFirstLetter()
        textfieldWorker.firstNameModel.configureDelegate(for: firstNameTextfield)
        textfieldWorker.firstNameModel.validiteNextButtonAction = validateNextButton
    }
    
    private func setupLastNameTextfield() {
        lastNameTextfield.setupTextfieldName(with: "LAST NAME", with: .norwester)
        lastNameTextfield.setupPlaceholder(with: "Enter your last name")
        lastNameTextfield.capitalizeFirstLetter()
        textfieldWorker.lastNameModel.configureDelegate(for: lastNameTextfield)
        textfieldWorker.lastNameModel.validiteNextButtonAction = validateNextButton
    }
    
    private func setupEmailTextfield() {
        emailTextfield.setupTextfieldName(with: "EMAIL", with: .norwester)
        emailTextfield.setupPlaceholder(with: "Enter your email")
        textfieldWorker.emailModel.configureDelegate(for: emailTextfield)
        textfieldWorker.emailModel.validiteNextButtonAction = validateNextButton
    }
    
    private func setupSexTextfield() {
        sexTextfield.setupTextfieldName(with: "SEX", with: .norwester)
        sexTextfield.setupPlaceholder(with: "Select your sex")
        sexTextfield.enableDropDown()
        sexTextfield.dropDownAppearanceAction = { [weak self] in
            self?.endEditing(true)
            self?.sexDropDownMenu.show()
        }
        textfieldWorker.sexModel.configureDelegate(for: sexTextfield)
        textfieldWorker.sexModel.setupDropDown(sexDropDownMenu)
        femaleOptionCheckboxStackview.isHidden = true
        femalesSpacingView.isHidden = true
    }
    
    private func setupSexDropDown() {
        sexDropDownMenu.anchorView = sexTextfield
        sexDropDownMenu.bottomOffset = CGPoint(x: 0,
                                               y: sexTextfield.frame.size.height - 20)
        sexDropDownMenu.width = DeviceSizeHelper.getScreenWidth() - 24
        
        sexDropDownMenu.dropDownHideAction = { [weak self] in
            self?.sexTextfield.makeDropDownArrowGetToTheFirstPostion()
        }
        
        sexDropDownMenu.selectionAction = { [weak self] _, text in
            self?.sexDropDownSelectionAction(chosenItem: text)
        }
    }
    
    private func sexDropDownSelectionAction(chosenItem: String) {
        sexTextfield.setupText(chosenItem)
        sexTextfield.makeDropDownArrowGetToTheFirstPostion()
        
        textfieldWorker.sexModel.gender = GenderOption.init(rawValue: chosenItem)
        femaleOptionCheckboxStackview.isHidden = textfieldWorker.sexModel.gender != .female
        femalesSpacingView.isHidden = textfieldWorker.sexModel.gender != .female
        
        if textfieldWorker.sexModel.gender != .female {
            textfieldWorker.sexModel.femaleOption = nil
            setupFemaleOptionCheckboxes()
        }
        
        let buttonIsValid = textfieldWorker.checkIfButtonIsValid()
        checkButtonState?(buttonIsValid)
    }
    
    private func setupFemaleOptionCheckboxes() {
        for (checkbox, option) in zip(femaleOptionCheckboxes, FemaleOption.allCases) {
            checkbox.tag = option.rawValue
            checkbox.checkboxSelected = checkbox.tag == textfieldWorker.sexModel.femaleOption?.rawValue
            checkbox.checkboxTitle = option.getFemaleOption()
            checkbox.checkboxAction = { [weak self] in
                self?.checkboxAction(with: option.rawValue)
                self?.validateNextButton()
            }
        }
    }
    
    private func checkboxAction(with tag: Int) {
        for element in femaleOptionCheckboxes {
            element.checkboxSelected = element.tag == tag ? true : false
        }
        guard let option = FemaleOption.init(rawValue: tag) else {
            return
        }
        textfieldWorker.sexModel.femaleOption = option
    }
    
    private func setupBirthDateTextfield() {
        birthDateTextfield.setupTextfieldName(with: "DATE OF BIRTH", with: .norwester)
        birthDateTextfield.setupPlaceholder(with: "Select your date of birth")
        let customToolBar = UIToolbar()
        birthDateTextfield.setupInputView(birthDatePicker,
                                          toolBar: customToolBar.toolbarPiker(saveAction: #selector(saveAction),
                                                                              cancelAction: #selector(cancelAction),
                                                                              tagOption: UserInfoPickerOption.birthDate.rawValue))
        textfieldWorker.birthDateModel.configureDelegate(for: birthDateTextfield)
        setupBirthDatePicker()
    }
    
    private func setupBirthDatePicker() {
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.maximumDate = Date()
        let defaultDate = Date(timeIntervalSince1970: 946684800)
        birthDatePicker.date = defaultDate
    }
    
    private func setupValueSystemLabelHeader() {
        valueSystemLabelHeader.font = FontManager.norwesterRegular.getFont(size: 20)
        valueSystemLabelHeader.text = "MEASUREMENT SYSTEM"
        valueSystemLabelHeader.textColor = ColorManager.primaryBrand.getColor()
    }
    
    private func setupValueSystemSwitcher() {
        valueSystemSwitcher.firstOptionTitle = MetricSystemOption.imperial.rawValue
        valueSystemSwitcher.secondOptionTitle = MetricSystemOption.metric.rawValue
        valueSystemSwitcher.labelsShouldBeHidden = false
        valueSystemSwitcher.switcherAction = { [weak self] isSecondOption in
            guard let self else {
                return
            }
            self.textfieldWorker.setupDataPickers(isFirst: !isSecondOption)
            self.convertValues(isSecondOption: isSecondOption)
            self.weightTextfield.setupTextfieldName(with: "WEIGHT" + " (\(self.textfieldWorker.weightModel.weightOption.rawValue.uppercased()))",
                                                    with: .norwester)
            self.heightTextfield.setupTextfieldName(with: "HEIGHT" + " (\(self.textfieldWorker.heightModel.heightOption.rawValue.uppercased()))",
                                                    with: .norwester)
            let buttonIsValid = self.textfieldWorker.checkIfButtonIsValid()
            self.checkButtonState?(buttonIsValid)
        }
        textfieldWorker.measurement = .imperial
    }
    
    private func convertValues(isSecondOption: Bool) {
        var weight = textfieldWorker.weightModel.getWeight()
        
        switch isSecondOption {
        case true:
            weight = (weight ?? 0) / 2.2
            setConvertedFtValueFromHeight(with: .cm)
        case false:
            weight = (weight ?? 0) * 2.2
            setConvertedFtValueFromHeight(with: .ft)
        }
        if weight != 0.00 {
            textfieldWorker.weightModel.setWeight(from: weight, option: isSecondOption ? .kg : .lbs)
            weightTextfield.setupText("\(String(format: "%.2f", textfieldWorker.weightModel.getWeight() ?? 0))")
        }
    }
    
    private func setupWeightTextfield() {
        weightTextfield.setupTextfieldName(with: "WEIGHT" + " (\(textfieldWorker.weightModel.weightOption.rawValue.uppercased()))", with: .norwester)
        weightTextfield.setupPlaceholder(with: "Select your weight")
        let customToolBar = UIToolbar()
        weightTextfield.setupInputView(weightPickerView,
                                       toolBar: customToolBar.toolbarPiker(saveAction: #selector(saveAction),
                                                                           cancelAction: #selector(cancelAction),
                                                                           tagOption: UserInfoPickerOption.weight.rawValue))
        textfieldWorker.weightModel.configurePickerView(weightPickerView)
    }
    
    private func setupHeightTextfield() {
        heightTextfield.setupTextfieldName(with: "HEIGHT" + " (\(textfieldWorker.heightModel.heightOption.rawValue.uppercased()))", with: .norwester)
        heightTextfield.setupPlaceholder(with: "Select your height")
        let customToolBar = UIToolbar()
        heightTextfield.setupInputView(heightPickerView,
                                       toolBar: customToolBar.toolbarPiker(saveAction: #selector(saveAction),
                                                                           cancelAction: #selector(cancelAction),
                                                                           tagOption: UserInfoPickerOption.height.rawValue))
        textfieldWorker.heightModel.configurePickerView(heightPickerView)
    }
    
    private func setupDropdownClimateTextfield() {
        dropdownClimateTextfield.setupTextfieldName(with: "CLIMATE", with: .norwester)
        dropdownClimateTextfield.setupPlaceholder(with: "Select your climate")
        dropdownClimateTextfield.enableDropDown()
        dropdownClimateTextfield.dropDownAppearanceAction = { [weak self] in
            self?.endEditing(true)
            self?.climateDropDownMenu.show()
        }
        textfieldWorker.dropdownClimateModel.configureDelegate(for: dropdownClimateTextfield)
        textfieldWorker.dropdownClimateModel.setupDropDown(climateDropDownMenu)
    }
    
    private func setupClimateDropDown() {
        climateDropDownMenu.anchorView = dropdownClimateTextfield
        climateDropDownMenu.bottomOffset = CGPoint(x: 0,
                                                   y: dropdownClimateTextfield.frame.size.height - 20)
        climateDropDownMenu.width = DeviceSizeHelper.getScreenWidth() - 24
        climateDropDownMenu.dropDownHideAction = { [weak self] in
            self?.dropdownClimateTextfield.makeDropDownArrowGetToTheFirstPostion()
        }
        
        climateDropDownMenu.selectionAction = { [weak self] _, text in
            self?.climateDropDownSelectionAction(chosenItem: text)
        }
    }
    
    private func climateDropDownSelectionAction(chosenItem: String) {
        dropdownClimateTextfield.setupText(chosenItem)
        dropdownClimateTextfield.makeDropDownArrowGetToTheFirstPostion()
        
        textfieldWorker.dropdownClimateModel.climate = ClimateOption.init(rawValue: chosenItem)
        
        validateNextButton()
    }
    
    private func validateNextButton() {
        let buttonIsValid = textfieldWorker.checkIfButtonIsValid()
        checkButtonState?(buttonIsValid)
    }
    
    private func setConvertedFtValueFromHeight(with option: HeightOption) {
        guard let height = textfieldWorker.heightModel.getHeight() else {
            return
        }
        switch option {
        case .ft:
            let doubleHeight = Double(height) ?? 0
            let ftValue = doubleHeight / 30.48
            setupFtHeight(from: ftValue)
        case .cm:
            let doubleHeight = Double(height) ?? 0
            let mainFtValue = getPostFtValue(from: doubleHeight)
            if height.suffix(2) == "10" {
                let ftHeight = Int(doubleHeight)
                let cmFtHeight = Double(ftHeight) * 30.48
                let inchHeight = (30.48 / 12) * 10
                let cmHeight = cmFtHeight + inchHeight
                textfieldWorker.heightModel.setHeight(from: cmHeight, option: .cm, upperThanTen: false)
                heightTextfield.setupText(textfieldWorker.heightModel.getHeight())
            } else if height.suffix(2) == "11" {
                let ftHeight = Int(doubleHeight)
                let cmFtHeight = Double(ftHeight) * 30.48
                let inchHeight = (30.48 / 12) * 11
                let cmHeight = cmFtHeight + inchHeight
                textfieldWorker.heightModel.setHeight(from: cmHeight, option: .cm, upperThanTen: false)
                heightTextfield.setupText(textfieldWorker.heightModel.getHeight())
            } else {
                let cmValue = mainFtValue * 30.48
                textfieldWorker.heightModel.setHeight(from: cmValue, option: .cm, upperThanTen: false)
                heightTextfield.setupText(textfieldWorker.heightModel.getHeight())
            }
        }
    }
    
    private func setupFtHeight(from ftHeight: Double?) {
        guard let ftHeight = ftHeight else {
            return
        }
        let intValue = ftHeight.rounded(.towardZero)
        let remainder = ftHeight.truncatingRemainder(dividingBy: 1)
        var doubleInchValue = remainder * 12
        let inchValue = Int(round(doubleInchValue))
        let fullFtValue = "\(Int(intValue))' " + "\(inchValue)''"
        let doubleFtValue = "\(Int(intValue))" + "." + "\(inchValue)"
        
        textfieldWorker.heightModel.setHeight(from: Double(doubleFtValue),
                                              ftValue: Int(intValue),
                                              inchValue: inchValue,
                                              option: .ft, upperThanTen: inchValue > 9)
        heightTextfield.setupText(fullFtValue)
    }
    
    private func getPostFtValue(from height: Double) -> Double {
        let intValue = height.rounded(.towardZero)
        var stringNumber = ""
        var startAdding = false
        for element in String(height) {
            if startAdding {
                stringNumber.append(element)
            }
            if element == "." {
                startAdding = true
            }
        }
        let intDecimal = Int(stringNumber) ?? 0
        let percentInchesValue = Double(intDecimal) / 12
        let fullValue = intValue + percentInchesValue
        return fullValue
    }
    
    // MARK: - Bar Button Actions
    @objc private func cancelAction(_ sender: UIBarButtonItem) {
        self.endEditing(true)
    }
    
    @objc private func saveAction(_ sender: UIBarButtonItem) {
        switch UserInfoPickerOption.init(rawValue: sender.tag) {
        case .birthDate:
            let chosenDate = birthDatePicker.date
            let formattedDate = DateFormatManager.getBirthDate(from: chosenDate)
            birthDateTextfield.setupText(formattedDate)
            textfieldWorker.birthDateModel.setDate(formattedDate, date: chosenDate)
            birthDatePicker.date = birthDatePicker.date
        case .weight:
            weightTextfield.setupText(textfieldWorker.weightModel.getValue())
        case .height:
            heightTextfield.setupText(textfieldWorker.heightModel.getValue())
        default:
            break
        }
        validateNextButton()
        self.endEditing(true)
    }
    
    // MARK: - Flow functions
    func validateInfo() -> Bool {
        textfieldWorker.checkIfButtonIsValid()
    }
    
    func setupView(checkButtonState: @escaping (Bool) -> ()) {
        self.checkButtonState = checkButtonState
    }
    
    func getMainUserInfo() -> UserInputModel {
        var userInputModel = UserInputModel()
        
        userInputModel.gender = textfieldWorker.sexModel.gender?.getApiValue()
        userInputModel.femaleState = textfieldWorker.sexModel.femaleOption?.getApiOption()
        userInputModel.birth = Int(textfieldWorker.birthDateModel.getDate()?.millisecondsSince1970 ?? 0)
        userInputModel.firstName = textfieldWorker.firstNameModel.getFirstName()
        userInputModel.lastName = textfieldWorker.lastNameModel.getLastName()
        userInputModel.email = textfieldWorker.emailModel.getEmail()
        userInputModel.measurement = textfieldWorker.measurement?.getApiValue()
        if textfieldWorker.heightModel.heightOption == .cm {
            let doubleHeight = (Double(textfieldWorker.heightModel.getHeight() ?? "") ?? 0) / 100
            userInputModel.height = doubleHeight
        } else {
            if let height = textfieldWorker.heightModel.getHeight() {
                let doubleHeight = Double(height) ?? 0
                if height.suffix(2) == "10" {
                    let ftHeight = Int(doubleHeight)
                    let inchHeight: Double = 10 / 12
                    let postHeight = Double(ftHeight) + inchHeight
                    userInputModel.height = postHeight
                } else if height.suffix(2) == "11" {
                    let ftHeight = Int(doubleHeight)
                    let inchHeight: Double = 11 / 12
                    let postHeight = Double(ftHeight) + inchHeight
                    userInputModel.height = postHeight
                } else {
                    let mainFtValue = getPostFtValue(from: doubleHeight)
                    userInputModel.height = mainFtValue
                }
            }
        }
        userInputModel.weight = textfieldWorker.weightModel.getWeight()
        userInputModel.climate = textfieldWorker.dropdownClimateModel.climate?.getApiOption()
        
        return userInputModel
    }
    
    func configureInfo(with user: UserModel?) {
        firstNameTextfield.setupText(user?.firstName)
        textfieldWorker.firstNameModel.setFirstName(with: user?.firstName)
        
        lastNameTextfield.setupText(user?.lastName)
        textfieldWorker.lastNameModel.setLastName(with: user?.lastName)
        
        emailTextfield.setupText(user?.email)
        textfieldWorker.emailModel.setEmail(with: user?.email)
        
        sexTextfield.setupText(user?.getGender()?.rawValue)
        textfieldWorker.sexModel.setGenderOption(with: user?.getGender())
        textfieldWorker.sexModel.setFemaleOption(with: user?.getFemaleState())
        femaleOptionCheckboxStackview.isHidden = textfieldWorker.sexModel.gender != .female
        femalesSpacingView.isHidden = textfieldWorker.sexModel.gender != .female
        setupFemaleOptionCheckboxes()
        
        if let date = user?.getBirthDate() {
            let formattedDate = DateFormatManager.getBirthDate(from: date)
            birthDateTextfield.setupText(formattedDate)
            textfieldWorker.birthDateModel.setDate(with: user?.getBirthDate())
            birthDatePicker.date = date
        }
        
        textfieldWorker.measurement = UserManager.shared.user?.getMeasurmentSystem()
        valueSystemSwitcher.isSwitched = textfieldWorker.measurement == .metric
        
        if let weight = user?.weight {
            let weightOption: WeightOption = UserManager.shared.user?.getMeasurmentSystem() == .imperial ? .lbs : .kg
            var currentWeight = weight
            if user?.getMeasurmentSystem() != UserManager.shared.user?.getMeasurmentSystem() {
                currentWeight = convertWeight(from: weightOption, value: currentWeight)
            }
            weightTextfield.setupText((String(format: "%.2f", currentWeight)))
            textfieldWorker.weightModel.setWeight(from: Double(currentWeight), option: weightOption)
            weightTextfield.setupTextfieldName(with: "WEIGHT" + " (\(textfieldWorker.weightModel.weightOption.rawValue.uppercased()))", with: .norwester)
        }
        
        if let height = user?.height {
            let heightOption: HeightOption = UserManager.shared.user?.getMeasurmentSystem() == .imperial ? .ft : .cm
            var currentHeight = height
            if user?.getMeasurmentSystem() != UserManager.shared.user?.getMeasurmentSystem() {
                currentHeight = convertHeight(from: heightOption, value: height)
            }
            if heightOption == .ft {
                setupFtHeight(from: Double(currentHeight))
            } else {
                let cmHeight = Int(currentHeight * 100)
                heightTextfield.setupText("\(cmHeight)")
                textfieldWorker.heightModel.setHeight(from: Double(cmHeight), option: heightOption, upperThanTen: false)
            }
            heightTextfield.setupTextfieldName(with: "HEIGHT" + " (\(textfieldWorker.heightModel.heightOption.rawValue.uppercased()))", with: .norwester)
        }
        
        dropdownClimateTextfield.setupText(user?.getClimate()?.rawValue)
        textfieldWorker.dropdownClimateModel.setClimate(with: user?.getClimate())
    }
    
    private func convertWeight(from weightOption: WeightOption, value: Double) -> CGFloat {
        switch weightOption {
        case .lbs:
            return value * 2.2
        case .kg:
            return value / 2.2
        }
    }
    
    private func convertHeight(from heighOption: HeightOption, value: Double) -> CGFloat {
        switch heighOption {
        case .ft:
            return value * 100 / 30.48
        case .cm:
            let newValue = value * 30.48
            return newValue / 100
        }
    }
    
    func checkNameTextfields() -> Bool {
        let firstNameIsValid = textfieldWorker.firstNameModel.getFirstName() != " " &&  textfieldWorker.firstNameModel.getFirstName()?.containsDigits() == false
        let lastNameIsValid = textfieldWorker.lastNameModel.getLastName() != " " &&  textfieldWorker.lastNameModel.getLastName()?.containsDigits() == false
        firstNameTextfield.setupError(isCorrect: firstNameIsValid, with: "Invalid name!")
        lastNameTextfield.setupError(isCorrect: lastNameIsValid, with: "Invalid name!")
        return firstNameIsValid && lastNameIsValid
    }
}
