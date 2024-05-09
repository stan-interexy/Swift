import UIKit
import BarcodeScanner

final class MainPageViewController: BasicViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var navigationBar: HavWtrNavigationBar!
    @IBOutlet private weak var mainPageTableView: UITableView!
    
    // MARK: - Constants
    let viewModel = MainPageVCViewModel()
    
    // MARK: - Private variables
    private lazy var tableViewWorker = MainPageTableViewWorker(tableView: mainPageTableView,
                                                               viewModel: viewModel)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBar.layoutSubviews()
        self.barcodeScannerAction = openBarcodeScanner
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupNavigationBar()
        tableViewWorker.setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationBar.delegate = self
        navigationBar.backButtonIsHidden = true
        navigationBar.barcodeScannerButtonContainerViewIsHidden = false
    }
    
    private func openBarcodeScanner() {
        viewModel.openBarcodeScanner(in: self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewWorker.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewWorker.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewWorker.getCell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewWorker.cellSelected(at: indexPath, in: self)
    }
}

// MARK: - BarcodeScannerCodeDelegate
extension MainPageViewController: BarcodeScannerCodeDelegate {
    
    func scanner(_ controller: BarcodeScanner.BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        viewModel.scanAndAddProduct(for: code) { [weak self] error in
            guard error == nil else {
                controller.showToastMessage(text: "Drink does not exist")
                controller.resetWithError(message: "Drink does not exist")
                return
            }
            controller.dismiss(animated: true)
            self?.tabBarController?.selectedIndex = TabBarOption.addWater.rawValue
            shouldOpenAnalytics = true
            isMainUser = true
            self?.showToastMessage(text: "Your WTR has been added!", isSuccessful: true)
        }
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension MainPageViewController: BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScanner.BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
}
