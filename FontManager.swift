import UIKit

enum FontManager {
    
    // MARK: - Open Sans
    case openSansBold
    case openSansRegular
    case openSansSemiBold
    case openSansLight
    
    // MARK: - Norwester
    case norwesterRegular
    
    // MARK: - SFProText
    case sfProRegular
    case sfProSemibold
}

extension FontManager {
    // MARK: - Flow functions
    func getFont(size: CGFloat) -> UIFont? {
        switch self {
        case .openSansBold:
            return UIFont(name: "OpenSans-Bold", size: size)
        case .openSansRegular:
            return UIFont(name: "OpenSans-Regular", size: size)
        case .openSansSemiBold:
            return UIFont(name: "OpenSans-SemiBold", size: size)
        case .openSansLight:
            return UIFont(name: "OpenSans-Light", size: size)
        case .norwesterRegular:
            return UIFont(name: "Norwester-Regular", size: size)
        case .sfProRegular:
            return UIFont(name: "SFProText-Regular", size: size)
        case .sfProSemibold:
            return UIFont(name: "SFProText-Semibold", size: size)
        }
    }
}
