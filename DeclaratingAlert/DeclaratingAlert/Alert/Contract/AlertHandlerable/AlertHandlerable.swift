//
//  AlertHandlerable.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

protocol AlertHandlerable: AlertPresentable {
    
    associatedtype Callback
    
    func handler(onFirstAction: Callback?, onSecondAction: Callback?, onCancel: Callback?) -> AlertPresentable
}
