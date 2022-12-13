
import UIKit

final class AlertPresenter {
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func requestShowAlertResult(alertModel: AlertModel?) {
        let alertController = UIAlertController(title: alertModel?.title, message: alertModel?.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel?.buttonText, style: .cancel, handler: alertModel?.completion)
        alertController.addAction(action)
        delegate?.showAlert(alertController: alertController)
    }
}
