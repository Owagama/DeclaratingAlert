//
//  ViewController.swift
//  DeclaratingAlert
//
//  Created by Vlad Dashkevich on 30.03.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController {
    
    func presentSingleOK() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        present(alertController, animated: true)
        /// OR
        alert.presentSingleOK(title: "Title", message: "Message")
        // or
        alert
            .create(title: "Title", message: "Message")
            .cancel(title: "OK")
            .present()
    }
    
    func handlActionsAlertController() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alertController.addAction(.init(title: "First Button", style: .default, handler: { _ in
            print("First Button Tapped")
        }))
        alertController.addAction(.init(title: "Second Button", style: .default, handler: { _ in
            print("Second Button Tapped")
        }))
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel Tapped")
        }))
        present(alertController, animated: true)
        /// OR
        alert
            .create(title: "Title", message: "Message")
            .action(title: "First Button", { print("First Button Tapped") })
            .action(title: "Second Button Tapped", { print("Second Button Tapped") })
            .cancel(title: "Cancel", { print("Cancel Tapped") })
            .present()
        // or
        alert
            .create(title: "Title", message: "Message")
            .action(title: "First Button")
            .action(title: "Second Button Tapped")
            .cancel(title: "Cancel")
            .handler(onFirstAction: {
                print("First Button Tapped")
            }, onSecondAction: {
                print("Second Button Tapped")
            }, onCancel: {
                print("Cancel Tapped")
            })
            .present()
    }
    
    func captureListUseAlertController() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            print(type(of: self))
        }))
        /// OR
        alert(self)
            .create(title: "Title", message: "Message")
            .cancel(title: "Cancel", { (self) in print(type(of: self)) })
            .present()
        
    }
}

