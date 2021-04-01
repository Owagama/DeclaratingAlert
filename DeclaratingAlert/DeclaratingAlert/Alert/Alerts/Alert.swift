//
//  Alert.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 1.04.21.
//

import UIKit

fileprivate final class Alert: BaseAlert<() -> ()> {
    
    override func actionHandler(_ action: UIAlertAction, callback: (() -> ())?, actionNum: Int) {
        callback?()
        super.actionHandler(action, callback: callback, actionNum: actionNum)
    }
    
    override func cancelHandler(_ action: UIAlertAction, callback: (() -> ())?) {
        callback?()
        super.cancelHandler(action, callback: callback)
    }
    
    override func baseHandler(onFirstAction: (() -> ())?, onSecondAction: (() -> ())?, onCancel: (() -> ())?) -> AlertPresentable {
        _ = onActionSubject
            .take(until: rx.deallocated)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] num in
                defer { self?.removeReference() }
                if num == 1 { onFirstAction?() }
                else if num == 2 { onSecondAction?() }
            })
        _ = onCancelSubject
            .take(until: rx.deallocated)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                defer { self?.removeReference() }
                onCancel?()
            })
        return super.baseHandler(onFirstAction: onFirstAction, onSecondAction: onSecondAction, onCancel: onCancel)
    }
}

extension UIViewController {
    
    var popup: AnyAlertCreatable<() -> ()> {
        let instance = Alert(viewController: self)
        return AnyAlertCreatable(instance)
    }
}

