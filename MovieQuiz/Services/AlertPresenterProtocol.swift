import UIKit

protocol AlertPresenterProtocol: AnyObject {
    var delegate: AlertPresenterDelegate? { get set }
    func requestShowAlertResult(alertModel: AlertModel?)
}
