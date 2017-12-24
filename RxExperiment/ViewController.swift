//
//  ViewController.swift
//  RxExperiment
//
//  Created by Damodar Shenoy on 12/23/17.
//  Copyright © 2017 itsdamslife. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct BtnEventProvider {
    let buttonTapped: Observable<Void>
}

struct CountPresenter {
    let count: Observable<Int>
    init(eventProvider: BtnEventProvider) {
        self.count = eventProvider.buttonTapped.scan(0) { (oldValue, _) in
                return oldValue + 1
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    private lazy var countPresenter: CountPresenter = {
        let btnEventProvider = BtnEventProvider(buttonTapped: self.btn.rx.tap.asObservable())
        return CountPresenter(eventProvider: btnEventProvider)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configKnockBtn()
    }

    func configKnockBtn() {
        self.countPresenter.count
            .debug("After scan!!")
            .asDriver(onErrorJustReturn: 0)
            .debug("After conversion as Driver!!")
            .map { [unowned self] count in
                var n: String = "Unknown"
                if let txt = self.txtField.text, !txt.isEmpty {
                    n = self.txtField.text!
                }
                return "\(n) knocked \(count) times!!"
            }
            .debug("After map!!")
            .drive(self.label.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

