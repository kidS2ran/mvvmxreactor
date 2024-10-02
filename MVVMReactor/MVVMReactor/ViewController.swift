//
//  ViewController.swift
//  MVVMReactor
//
//  Created by Son Pham on 02/10/2024.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private
    var viewModel: DemoViewModel!
    
    private
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = DemoViewModel()
        viewModel.setupFlow(disposeBag: disposeBag)
        bindViewModel()
    }
    
}

extension ViewController{
    private
    func bindViewModel(){
        self.viewModel
            .state
            .map{$0.isLoading}
            .subscribe(onNext:{ [weak self] isLoading in
                ///listen loading state
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController{
    //Make action
    private
    func actionA(){
        self.viewModel.action.accept(.getData)
    }
}
