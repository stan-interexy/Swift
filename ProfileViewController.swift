import UIKit

enum ProfileViewControllerNotoficationOption: String {
    case updateTableView
}

final class ProfileViewController: BasicViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var navigationBar: HavWtrNavigationBar!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var profileOptionTableView: UITableView!
    
    // MARK: - Private constants
    private let viewModel = ProfileVCViewModel()
    
    // MARK: - Private variables
    private lazy var tableViewWorker = ProfileOptionTableViewWorker(tableView: profileOptionTableView,
                                                                    viewModel: viewModel)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserNameLabel()
        profileOptionTableView.reloadData()
        navigationBar.layoutSubviews()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupNavigationBar()
        separatorView.backgroundColor = ColorManager.separatorGray.getColor()
        tableViewWorker.setupTableView(with: self)
    }
    
    private func setupNavigationBar() {
        navigationBar.delegate = self
        navigationBar.backButtonIsHidden = true
        navigationBar.title = viewModel.getHeaderTitle()
    }
    
    private func setupUserNameLabel() {
        userNameLabel.font = FontManager.openSansBold.getFont(size: 14)
        userNameLabel.text = viewModel.getUserName().uppercased()
        userNameLabel.textColor = ColorManager.primaryBrand.getColor()
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: Notification.Name(ProfileViewControllerNotoficationOption.updateTableView.rawValue),
                                               object: nil)
    }
    
    // MARK: - IBActions
    @objc func reloadData() {
        profileOptionTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableViewWorker.getHeightForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewWorker.getHeader(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewWorker.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewWorker.getHeightForCell(in: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewWorker.getNumberOfCells(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewWorker.getCell(for: indexPath, in: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewWorker.cellSelected(at: indexPath, in: self)
    }
}
