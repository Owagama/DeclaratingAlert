//
//  AnyAlertHandlerable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

struct AnyAlertHandlerable<Callback>: AlertHandlerable {
    
    private let base: _AnyAlertHandlerable<Callback>
    
    init<Base: AlertHandlerable>(_ base: Base) where Base.Callback == Callback {
        self.base = _AlertHandlerableBox(base: base)
    }
    
    func handler(onFirstAction: Callback?, onSecondAction: Callback?, onCancel: Callback?) -> AlertPresentable {
        return base.handler(onFirstAction: onFirstAction, onSecondAction: onSecondAction, onCancel: onCancel)
    }
    
    func present() {
        base.present()
    }
}

private class _AnyAlertHandlerable<Callback>: AlertHandlerable {
    
    func handler(onFirstAction: Callback?, onSecondAction: Callback?, onCancel: Callback?) -> AlertPresentable {
        fatalError("This is abstract method")
    }
    
    func present() {
        fatalError("This is abstract method")
    }
}

private class _AlertHandlerableBox<Base: AlertHandlerable>: _AnyAlertHandlerable<Base.Callback> {
    
    private let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    override func handler(onFirstAction: Base.Callback?, onSecondAction: Base.Callback?, onCancel: Base.Callback?) -> AlertPresentable {
        return base.handler(onFirstAction: onFirstAction, onSecondAction: onSecondAction, onCancel: onCancel)
    }
    
    override func present() {
        base.present()
    }
}
