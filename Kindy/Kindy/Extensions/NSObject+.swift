import Foundation

extension NSObject {
    static var identifier: String {
        String(describing: self)
    }
}
