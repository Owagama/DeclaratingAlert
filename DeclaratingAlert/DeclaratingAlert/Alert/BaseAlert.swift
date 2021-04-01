//
//  BaseAlert.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

import RxSwift
import RxCocoa
import UIKit

fileprivate class BaseAlertSR {
    
    static let shared: BaseAlertSR = .init()
        
    var baseAlert: AnyObject?
    
    private init() {}
}

class BaseAlert<Callback>: ReactiveCompatible {
    
    let onCancelSubject = PublishSubject<Void>()
    let onActionSubject = PublishSubject<Int>()

    private var alertController: UIAlertController?
    private var actionCounter = 0
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func addReference() {
        BaseAlertSR.shared.baseAlert = self
        guard let viewController = viewController, let alertController = alertController else { return }
        _ = Observable
            .merge(viewController.rx.deallocated, alertController.rx.deallocated)
            .take(until: rx.deallocated)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.removeReference()
            })
    }
    
    func removeReference() {
        BaseAlertSR.shared.baseAlert = nil
    }
    
    func actionHandler(_ action: UIAlertAction, callback: Callback?, actionNum: Int) {
        onActionSubject.onNext(actionNum)
    }
    
    func cancelHandler(_ action: UIAlertAction, callback: Callback?) {
        onCancelSubject.onNext(())
    }
    
    func baseHandler(onFirstAction: Callback?, onSecondAction: Callback?, onCancel: Callback?) -> AlertPresentable {
        addReference()
        return self
    }
    
    deinit {
        debugPrint("BaseAlert deinit")
    }
}

// MARK: - PopupCreatable
extension BaseAlert: AlertCreatable {
    
    func create(title: String, message: String) -> AnyAlertConfigurable<Callback> {
        alertController = .init(title: title, message: message, preferredStyle: .alert)
        return AnyAlertConfigurable(self)
    }
}

// MARK: - PopupConfigurable
extension BaseAlert: AlertConfigurable {
    
    func action(title: String, _ callback: Callback?) -> AnyAlertConfigurable<Callback> {
        actionCounter += 1
        let actionNum = actionCounter
        alertController?.addAction(.init(title: title, style: .default, handler: { [weak self] action in
            self?.actionHandler(action, callback: callback, actionNum: actionNum)
        }))
        return AnyAlertConfigurable(self)
    }
    
    func cancel(title: String, _ callback: Callback?) -> AnyAlertHandlerable<Callback> {
        alertController?.addAction(.init(title: title, style: .cancel, handler: { [weak self] action in
            self?.cancelHandler(action, callback: callback)
        }))
        return AnyAlertHandlerable(self)
    }
}

// MARK: - PopupHandlerable
extension BaseAlert: AlertHandlerable {
    
    func handler(onFirstAction: Callback?, onSecondAction: Callback?, onCancel: Callback?) -> AlertPresentable {
        baseHandler(onFirstAction: onFirstAction, onSecondAction: onSecondAction, onCancel: onCancel)
    }
}

// MARK: - PopupPresentable
extension BaseAlert: AlertPresentable {
    
    func present() {
        guard let alertController = alertController else { return }
        viewController?.present(alertController, animated: true)
        // This solution handles the case when the alert controller is dismissed programmatically.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.alertController = nil
        }
    }
}
