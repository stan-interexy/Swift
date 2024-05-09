import UIKit
import KeychainSwift

final class KeychainService: NSObject {
    
    enum AccessKey: String {
        case accessToken = "access_token"
        case twilioToken = "twilio_token"
    }
    
    // MARK: - Private constants
    private static let accessGroup = Constants.accessGroup.rawValue
    
    // MARK: - Flow functions
    class func store(value: String, key: AccessKey) {
        let keychain = KeychainSwift()
        keychain.accessGroup = accessGroup
        keychain.set(value, forKey: key.rawValue)
    }

    class func get(key: AccessKey) -> String? {
        let keychain = KeychainSwift()
        keychain.accessGroup = accessGroup
        return keychain.get(key.rawValue)
    }

    class func delete(key: AccessKey) {
        let keychain = KeychainSwift()
        keychain.accessGroup = accessGroup
        keychain.delete(key.rawValue)
    }
}

