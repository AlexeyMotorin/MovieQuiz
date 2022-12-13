import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func requestShowAlertResult(alertModel: AlertModel?)
}
