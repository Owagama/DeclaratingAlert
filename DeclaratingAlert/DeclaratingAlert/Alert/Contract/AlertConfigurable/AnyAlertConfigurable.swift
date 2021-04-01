//
//  AnyAlertConfigurable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

struct AnyAlertConfigurable<Callback>: AlertConfigurable {

    private let base: _AnyAlertConfigurable<Callback>
    
    init<Base: AlertConfigurable>(_ base: Base) where Base.Callback == Callback {
        self.base = _AlertConfigurableBox(base: base)
    }
    
    func action(title: String, _ callback: Callback?) -> AnyAlertConfigurable<Callback> {
        return base.action(title: title, callback)
    }
    
    func cancel(title: String, _ callback: Callback?) -> AnyAlertHandlerable<Callback> {
        return base.cancel(title: title, callback)
    }
}

extension AnyAlertConfigurable {
    
    func action(title: String) -> AnyAlertConfigurable<Callback> {
        return action(title: title, nil)
    }
    
    func cancel(title: String) -> AnyAlertHandlerable<Callback> {
        return cancel(title: title, nil)
    }
}

class _AnyAlertConfigurable<Callback>: AlertConfigurable {

    func action(title: String, _ callback: Callback?) -> AnyAlertConfigurable<Callback> {
        fatalError("This is abstract method")
    }
    
    func cancel(title: String, _ callback: Callback?) -> AnyAlertHandlerable<Callback> {
        fatalError("This is abstract method")
    }
}

class _AlertConfigurableBox<Base: AlertConfigurable>: _AnyAlertConfigurable<Base.Callback> {
    
    private let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    override func action(title: String, _ callback: Base.Callback?) -> AnyAlertConfigurable<Callback> {
        return base.action(title: title, callback)
    }
    
    override func cancel(title: String, _ callback: Callback?) -> AnyAlertHandlerable<Callback> {
        return base.cancel(title: title, callback)
    }
}
