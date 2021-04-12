//
//  UIViewController+Extensions.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 19/02/2021.
//

import UIKit

extension UIViewController {
    /// Show an alertcontroller with an action
    /// - Parameters:
    ///   - alertMessage: Alert message
    ///   - alertTitle: Alert title
    ///   - alertActionTitle: Action title
    func showAlert(_ alertMessage: String,
                               _ alertTitle: String = NSLocalizedString("Error", comment: ""),
                               _ alertActionTitle: String = NSLocalizedString("OK", comment: "")) {

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertActionTitle, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
