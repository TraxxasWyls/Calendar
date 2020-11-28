//
//  RightViewController.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import UIKit

class RightViewController: UIViewController {

    lazy var router = RightRouter(transitionHandler: self as TransitionHandler)

    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupButton()
        configureButton()
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    private func configureButton() {
        button.setTitle("GO HOME", for: .normal)
    }

    private func setupButton() {
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }

    @objc private func tapAction() {
        router.close(animated: true)
    }




    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
