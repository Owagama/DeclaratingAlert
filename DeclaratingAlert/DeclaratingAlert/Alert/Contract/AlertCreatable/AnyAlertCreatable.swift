//
//  AnyAlertCreatable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

struct AnyAlertCreatable<Callback>: AlertCreatable {

    private let base: _AnyAlertCreatable<Callback>

    init<Base: AlertCreatable>(_ base: Base) where Base.Callback == Callback {
        self.base = _AlertCreatableBox(base: base)
    }

    func create(title: String, message: String) -> AnyAlertConfigurable<Callback> {
        base.create(title: title, message: message)
    }
}

extension AnyAlertCreatable {
    
    func presentSingleOK(title: String = "", message: String, onCancel: Callback? = nil) {
        create(title: title, message: message)
            .cancel(title: title, onCancel)
            .present()
    }
}

private class _AnyAlertCreatable<Callback>: AlertCreatable {

    func create(title: String, message: String) -> AnyAlertConfigurable<Callback> {
        fatalError("This is abstract method")
    }
}

private class _AlertCreatableBox<Base: AlertCreatable>: _AnyAlertCreatable<Base.Callback> {

    private let base: Base

    init(base: Base) {
        self.base = base
    }

    override func create(title: String, message: String) -> AnyAlertConfigurable<Callback> {
        return base.create(title: title, message: message)
    }
}
