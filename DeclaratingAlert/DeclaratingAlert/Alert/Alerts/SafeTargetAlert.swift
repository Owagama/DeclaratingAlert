//
//  SafeTargetAlert.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 1.04.21.
//

import UIKit

fileprivate final class SafeTargetAlert<Target: AnyObject>: BaseAlert<(Target) -> ()> {
    
    private weak var target: Target?
    
    convenience init(target: Target, viewController: UIViewController) {
        self.init(viewController: viewController)
        self.target = target
    }
    
    override func actionHandler(_ action: UIAlertAction, callback: ((Target) -> ())?, actionNum: Int) {
        guard let target = target else { return }
        callback?(target)
        super.actionHandler(action, callback: callback, actionNum: actionNum)
    }
    
    override func cancelHandler(_ action: UIAlertAction, callback: ((Target) -> ())?) {
        guard let target = target else { return }
        callback?(target)
        super.cancelHandler(action, callback: callback)
    }
    
    override func baseHandler(onFirstAction: ((Target) -> ())?, onSecondAction: ((Target) -> ())?, onCancel: ((Target) -> ())?) -> AlertPresentable {
        _ = onActionSubject
            .take(until: rx.deallocated)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self, weak target] num in
                defer { self?.removeReference() }
                guard let target = target else { return }
                if num == 1 { onFirstAction?(target) }
                else if num == 2 { onSecondAction?(target) }
            })
        _ = onCancelSubject
            .take(until: rx.deallocated)
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self, weak target] in
                defer { self?.removeReference() }
                guard let target = target else { return }
                onCancel?(target)
            })
        return super.baseHandler(onFirstAction: onFirstAction, onSecondAction: onSecondAction, onCancel: onCancel)
    }
}

extension UIViewController {
    
    func alert<Target: AnyObject>(_ target: Target) -> AnyAlertCreatable<(Target) -> ()> {
        let instance = SafeTargetAlert(target: target, viewController: self)
        return AnyAlertCreatable(instance)
    }
}

