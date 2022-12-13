import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alertController: UIAlertController?)
}
