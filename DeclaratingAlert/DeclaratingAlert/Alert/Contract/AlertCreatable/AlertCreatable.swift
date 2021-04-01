//
//  AlertCreatable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

protocol AlertCreatable {
    
    associatedtype Callback
    
    func create(title: String, message: String) -> AnyAlertConfigurable<Callback>
}
