import Foundation

public protocol ValidationError: Error {
    
    var message: String { get }
}
