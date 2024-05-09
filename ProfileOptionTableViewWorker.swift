import UIKit

enum ProfileOptionSection: Int {
    case profile
    case inviteFriend
    case aboutUs
    case account
    case logOut
    
}

final class ProfileOptionTableViewWorker {
    
    // MARK: - Private constants
    private let tableView: UITableView
    private let viewModel: ProfileVCViewModel
    private let cellIdentifier = "ProfileTableViewCell"
    private let inviteFriendCellIdentifier = "InviteFriendTableViewCell"
    private let logOutCellIdentifier = "LogOutTableViewCell"
    private let headerIdentifier = "ProfileHeaderView"
    
    // MARK: - Private variables
    private var contactPickerManager: ContactPickerManager?
    
    // MARK: - Initializators
    init(tableView: UITableView, viewModel: ProfileVCViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    func setupTableView(with viewController: ProfileViewController) {
        setupCells()
        contactPickerManager = ContactPickerManager(viewController: viewController)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func setupCells() {
        CellRegisterService.registerTableViewCell(in: tableView,
                                                  with: cellIdentifier)
        CellRegisterService.registerTableViewCell(in: tableView,
                                                  with: headerIdentifier)
        CellRegisterService.registerTableViewCell(in: tableView,
                                                  with: inviteFriendCellIdentifier)
        CellRegisterService.registerTableViewCell(in: tableView,
                                                  with: logOutCellIdentifier)
    }
    
    // MARK: - Delegate method helpers
    func getHeightForHeader(in section: Int) -> CGFloat {
        switch ProfileOptionSection.init(rawValue: section) {
        case .logOut, .inviteFriend:
            return 0
        default:
            return 66
        }
    }
    
    func getHeader(at section: Int) -> UIView? {
        switch ProfileOptionSection.init(rawValue: section) {
        case .logOut:
            return nil
        default:
            guard let header = tableView.dequeueReusableCell(withIdentifier: headerIdentifier) as? ProfileHeaderView else {
                return nil
            }
            let title = viewModel.profileOptions[section].rawValue
            header.setupHeader(with: title)
            return header
        }
    }
    
    func getNumberOfSections() -> Int {
        viewModel.profileOptions.count + 1
    }
    
    func getHeightForCell(in section: Int) -> CGFloat {
        switch ProfileOptionSection.init(rawValue: section) {
        case .logOut:
            return 90
        case .inviteFriend:
            return 73
        default:
            return 56
        }
    }
    
    func getNumberOfCells(for section: Int) -> Int {
        switch ProfileOptionSection.init(rawValue: section) {
        case .logOut, .inviteFriend:
            return 1
        default:
            return viewModel.profileOptions[section].getItemsForOtpions().count
        }
    }
    
    func getCell(for indexPath: IndexPath, in viewController: BasicViewController) -> UITableViewCell {
        switch ProfileOptionSection.init(rawValue: indexPath.section) {
        case .logOut:
            return getLogOutCell(at: indexPath)
        case .inviteFriend:
            return getInviteFriendCell(at: indexPath, in: viewController)
        default:
            return getProfileOptionCell(at: indexPath)
        }
    }
    
    private func getLogOutCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: logOutCellIdentifier, for: indexPath) as? LogOutTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell()
        return cell
    }
    
    private func getInviteFriendCell(at indexPath: IndexPath, in viewController: BasicViewController) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: inviteFriendCellIdentifier, for: indexPath) as? InviteFriendTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell { [weak self] in
            viewController.showInviteFriendView { [weak self] in
                self?.contactPickerManager?.openPhonebook()
            }
        }
        return cell
    }
    
    private func getProfileOptionCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let option = viewModel.profileOptions[indexPath.section]
        let model = option.getItemsForOtpions()[indexPath.row]
        if option == .account, model == "Notifications" {
            cell.setupCell(with: model, mustHaveToogle: true)
            cell.switcherAction = { [weak self] isOn in
                if isOn {
                    UIApplication.shared.registerForRemoteNotifications()
                    UserDefaultsManager.shared.saveStringValue("Y", for: .notificationStatus)
                } else {
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UserDefaultsManager.shared.saveStringValue("N", for: .notificationStatus)
                }
                self?.viewModel.sendEvent(isToogled: isOn)
            }
            cell.setupSwitcher(with: UIApplication.shared.isRegisteredForRemoteNotifications)
        } else {
            cell.setupCell(with: model)
        }
        return cell
    }
    
    func cellSelected(at indexPath: IndexPath, in viewController: BasicViewController) {
        switch ProfileOptionSection.init(rawValue: indexPath.section) {
        case .profile:
            performActionForProfile(in: viewController, at: indexPath)
        case .aboutUs:
            performActionForAboutUs(in: viewController, at: indexPath)
        case .account:
            performActionForAccount(in: viewController, at: indexPath)
        case .logOut:
            performActionForLogout(in: viewController)
        default:
            break
        }
    }
    
    private func performActionForProfile(in viewController: BasicViewController, at indexPath: IndexPath) {
        switch ProfileProfileTabOption.init(rawValue: indexPath.row) {
        case .personalInformation:
            viewModel.moveToEditInfomationScreen(from: viewController)
        case .paymentMethods:
            viewModel.moveToCreditCardsScreen(from: viewController)
        case .familyMembers:
            viewModel.moveToFamilyMembersScreen(from: viewController)
        case .subscriptions:
            viewModel.moveToSubscriptionsScreen(from: viewController)
        default:
            break
        }
    }
    
    private func performActionForAboutUs(in viewController: BasicViewController, at indexPath: IndexPath) {
        switch AboutUsProfileTabOption.init(rawValue: indexPath.row) {
        case .privacyPolicy:
            viewModel.moveToTermsAndPrivacyScreen(from: viewController, with: .privacy)
        case .termsAndConditions:
            viewModel.moveToTermsAndPrivacyScreen(from: viewController, with: .terms)
        case .supportMessage:
            viewModel.moveToChatScreen(from: viewController)
        default:
            break
        }
    }
    
    private func performActionForAccount(in viewController: BasicViewController, at indexPath: IndexPath) {
        switch AccountProfileTabOption.init(rawValue: indexPath.row) {
        case .deleteAccount:
            viewController.showAlert(with: .deleteAccount, firstButtonAction: nil) { [weak self] in
                viewController.showSpinner()
                self?.viewModel.deleteUser { [weak self] error in
                    viewController.hideSpinner()
                    guard let error = error else {
                        self?.viewModel.performLogoutAction()
                        return
                    }
                    viewController.showToastMessage(text: error.getDescription())
                }
            }
        default:
            break
        }
    }
    
    private func performActionForLogout(in viewController: BasicViewController) {
        viewController.showAlert(with: .logOut, firstButtonAction: nil) { [weak self] in
            self?.viewModel.performLogoutAction()
        }
    }
}
