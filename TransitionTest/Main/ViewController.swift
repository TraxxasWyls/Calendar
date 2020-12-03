//
//  ViewController.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import UIKit

class ViewController: UIViewController {

    lazy var router = MainRouter(transitionHandler: self as TransitionHandler)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func left(_ sender: Any) {
//        router.openLeft(with: "self.description")
        let navigationController = UINavigationController(rootViewController: CalendarViewController())
//        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        

    }

    @IBAction func center(_ sender: Any) {
        router.openCentral()
    }

    @IBAction func right(_ sender: Any) {
        router.openRight()
    }
}


