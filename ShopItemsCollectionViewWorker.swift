import UIKit

final class ShopItemsCollectionViewWorker {
    
    // MARK: - Private constants
    private let collectionView: UICollectionView
    private let viewModel: ShopVCViewModel
    private let cellIdentifier = "ShopItemCollectionViewCell"
    private let shoppingListManager = ShoppingListManager.shared
    
    // MARK: - Initializators
    init(collectionView: UICollectionView, viewModel: ShopVCViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
    }
    
    // MARK: - Setup
    func setupCollectionView() {
        setupCollectionViewLayout()
        setupCell()
    }
    
    private func setupCollectionViewLayout() {
        let spacing: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing,
                                   leading: spacing,
                                   bottom: spacing,
                                   trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCell() {
        CellRegisterService.registerCollectionViewCell(in: collectionView,
                                                       with: cellIdentifier)
    }
    
    // MARK: - Delegate method helpers
    func getNumberOfCells() -> Int {
        viewModel.sortedListItems.count
    }
    
    func getCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ShopItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.sortedListItems[indexPath.row]
        cell.setupCell(with: model,
                       inStock: shoppingListManager.getStockAvailability(for: model.name ?? ""))
        return cell
    }
    
    func cellSelected(in viewController: ShopViewController, at indexPath: IndexPath) {
        viewModel.moveToShoppingItemScene(from: viewController, index: indexPath.item)
    }
}
