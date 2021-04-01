//
//  AlertConfigurable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

protocol AlertConfigurable {
    
    associatedtype Callback
    
    func action(title: String, _ callback: Callback?) -> AnyAlertConfigurable<Callback>
    func cancel(title: String, _ callback: Callback?) -> AnyAlertHandlerable<Callback>
}
