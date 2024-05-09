import UIKit

enum ProfileOption: String, CaseIterable {
    case profile = "PROFILE"
    case reedem = "REDEEM"
    case aboutUs = "ABOUT US"
    case account = "ACCOUNT"
    
    func getItemsForOtpions() -> [String] {
        var items = [String]()
        switch self {
        case .profile:
            items = ProfileProfileTabOption.allCases.map { $0.getTitle() }
        case .reedem:
            items = ["REDEEM"]
        case .aboutUs:
            items = AboutUsProfileTabOption.allCases.map { $0.getTitle() }
        case .account:
            items = AccountProfileTabOption.allCases.map { $0.getTitle() }
        }
        return items
    }
}

enum ProfileProfileTabOption: Int, CaseIterable {
    case personalInformation
    case paymentMethods
    case familyMembers
    case subscriptions
    
    func getTitle() -> String {
        switch self {
        case .personalInformation:
            return "Personal Information"
        case .paymentMethods:
            return "Payment Methods"
        case .familyMembers:
            return "Family Members"
        case .subscriptions:
            return "Subscriptions"
        }
    }
}

enum AboutUsProfileTabOption: Int, CaseIterable {
    case privacyPolicy
    case termsAndConditions
    case supportMessage
    
    func getTitle() -> String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsAndConditions:
            return "Terms & Conditions"
        case .supportMessage:
            return "Support Message"
        }
    }
}

enum AccountProfileTabOption: Int, CaseIterable {
    case notifications
    case deleteAccount
    
    func getTitle() -> String {
        switch self {
        case .notifications:
            return "Notifications"
        case .deleteAccount:
            return "Delete Account"
        }
    }
}

final class ProfileVCViewModel: BasicViewModel {
    
    // MARK: - Private constants
    private let loginManager = LoginManager.shared
    private let userManager = UserManager.shared
    
    // MARK: - Model
    let profileOptions = ProfileOption.allCases
    
    // MARK: - Flow functions
    func deleteUser(completion: @escaping (HavWtrValidationError?) -> ()) {
        networkService.makeAuthedRequestWithoutResponse(target: .deleteAccount) { error in
            completion(error)
        }
    }
    
    func getHeaderTitle() -> String {
        "ACCOUNT"
    }
    
    func getUserName() -> String {
        (userManager.user?.firstName?.replacingOccurrences(of: "\n", with: "") ?? "") + " " + (userManager.user?.lastName?.replacingOccurrences(of: "\n", with: "") ?? "")
    }
    
    func performLogoutAction() {
        networkService.makeAuthedRequestWithoutResponse(target: .signOut) { _ in }
        KeychainService.delete(key: .accessToken)
        userManager.clearUserInfo()
        loginManager.postChangeScreenNotification(with: false)
    }
    
    // MARK: - Routing
    func moveToEditInfomationScreen(from viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "EditInfromationViewController", bundle: nil)
        guard let paymentMethodsVC = storyboard.instantiateViewController(withIdentifier: "EditInfromationViewController") as? EditInfromationViewController else {
            return
        }
        viewController.navigationController?.pushViewController(paymentMethodsVC, animated: true)
    }

    func moveToCreditCardsScreen(from viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreditCardsViewController", bundle: nil)
        guard let creaditCardsVC = storyboard.instantiateViewController(withIdentifier: "CreditCardsViewController") as? CreditCardsViewController else {
            return
        }
        viewController.navigationController?.pushViewController(creaditCardsVC, animated: true)
    }
    
    func moveToFamilyMembersScreen(from viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "FamilyMembersViewController", bundle: nil)
        guard let familyMembersVC = storyboard.instantiateViewController(withIdentifier: "FamilyMembersViewController") as? FamilyMembersViewController else {
            return
        }
        viewController.navigationController?.pushViewController(familyMembersVC, animated: true)
    }
    
    func moveToSubscriptionsScreen(from viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SubscriptionsViewController", bundle: nil)
        guard let subscriptionsVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController else {
            return
        }
        subscriptionsVC.viewModel.isRoot = false
        viewController.navigationController?.pushViewController(subscriptionsVC, animated: true)
    }
    
    func moveToChatScreen(from viewController: UIViewController) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ChatViewController", bundle: nil)
        guard let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {
            return
        }
        chatVC.modalPresentationStyle = .fullScreen
        viewController.present(chatVC, animated: true)
    }
    
    func moveToTermsAndPrivacyScreen(from viewController: UIViewController, with option: TermsAndPrivacyOption) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TermsAndPrivacyViewController", bundle: nil)
        guard let termsAndPrivacyVC = storyboard.instantiateViewController(withIdentifier: "TermsAndPrivacyViewController") as? TermsAndPrivacyViewController else {
            return
        }
        termsAndPrivacyVC.viewModel.option = option
        viewController.navigationController?.pushViewController(termsAndPrivacyVC, animated: true)
    }
    
    func sendEvent(isToogled: Bool) {
        AnalyticsManager.sendEvent(with: "notifications_toggled", parameters: [
            "isToogled": isToogled
        ])
    }
}
