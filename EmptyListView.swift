import UIKit

enum EmptyListOption {
    case notifications
    case shoppingCart
    case familyMembers
    case currentOrders
    case pastOrders
    case noHydrationData
    case noHEXE
    
    func getIcon() -> UIImage? {
        switch self {
        case .notifications:
            return ImageAssetManager.notificationsEmptyListIcon.getImage()
        case .shoppingCart:
            return ImageAssetManager.emptyShoppingCartIcon.getImage()
        case .familyMembers:
            return ImageAssetManager.familyMembersIcon.getImage()
        case .currentOrders, .pastOrders:
            return ImageAssetManager.emptyShoppingCartIcon.getImage()
        case .noHydrationData:
            return ImageAssetManager.emptyHydrationIcon.getImage()
        case .noHEXE:
            return ImageAssetManager.noHEXEIcon.getImage()
        }
    }
    
    func getText() -> String? {
        switch self {
        case .notifications:
            return "NO NEW NOTIFICATIONS"
        case .shoppingCart:
            return "YOUR CART IS EMPTY"
        case .familyMembers:
            return "YOU HAV NOT YET ADDED ANY FAMILY MEMBERS"
        case .currentOrders:
            return "YOU HAVE NO CURRENT ORDERS"
        case .pastOrders:
            return "YOU HAVE NO PAST ORDERS"
        case .noHydrationData:
            return "THERE WAS NO HYDRATION PROVIDED FOR THE SELECTED DATE"
        case .noHEXE:
            return "THERE ARE NO UPCOMING EVENTS AT THE MOMENT. STAY TUNED FOR FUTURE UPDATES!"
        }
    }
    
    func getActiveButtonText() -> String? {
        switch self {
        case .shoppingCart,
             .currentOrders:
            return "Go to Shop"
        case .familyMembers:
            return "Add family member"
        default:
            return nil
        }
    }
}

@IBDesignable
final class EmptyListView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var itemIconImageView: UIImageView!
    @IBOutlet private weak var itemErrorLabel: UILabel!
    @IBOutlet private weak var emptyListActionButton: BlackButton!
    @IBOutlet private weak var emptyListBottomActionButton: BlackButton!
    @IBOutlet private weak var emptyListBottomActionBorderedButton: BorderedButton!
    
    // MARK: - Private variables
    private var bottomButtonShouldBeVisible = false {
        didSet {
            emptyListActionButton.isHidden = bottomButtonShouldBeVisible
            emptyListBottomActionButton.isHidden = !bottomButtonShouldBeVisible
        }
    }
    
    private var borderButtonShouldBeVisible = false {
        didSet {
            emptyListActionButton.isHidden = bottomButtonShouldBeVisible
            emptyListBottomActionBorderedButton.isHidden = !bottomButtonShouldBeVisible
        }
    }
    
    // MARK: - Variables
    var emptyListButtonAction: (()->())?
    var hideAllButtons = false {
        didSet {
            emptyListActionButton.isHidden = hideAllButtons
            emptyListBottomActionButton.isHidden = hideAllButtons
            emptyListBottomActionBorderedButton.isHidden = hideAllButtons
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
        let bundle = Bundle(for: EmptyListView.self)
        bundle.loadNibNamed("EmptyListView",
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
        setupItemErrorLabel()
        emptyListActionButton.isHidden = true
        emptyListBottomActionButton.isHidden = true
        emptyListBottomActionBorderedButton.isHidden = true
    }
    
    private func setupItemErrorLabel() {
        itemErrorLabel.font = FontManager.norwesterRegular.getFont(size: 28)
        itemErrorLabel.textColor = ColorManager.primaryBrand.getColor()
    }
    
    @IBAction private func emptyListActionButtonIsPressed(_ sender: UIButton) {
        emptyListButtonAction?()
    }
    
    // MARK: - Flow functions
    func configureView(with option: EmptyListOption) {
        itemIconImageView.image = option.getIcon()
        itemErrorLabel.text = option.getText()
        if let buttonText = option.getActiveButtonText() {
            bottomButtonShouldBeVisible = option == .familyMembers
            emptyListActionButton.configureText(buttonText)
            emptyListBottomActionButton.configureText(buttonText)
            emptyListBottomActionBorderedButton.configureText(buttonText, configuration: .thin)
        }
    }
}
