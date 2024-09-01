//
//  RegisterViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/6/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import RxSwift
import SPStorkController
import Core
import Component

final class RegisterViewController: BaseViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var registerBoxView: UIView!
    // Title
    @IBOutlet private weak var emailTitleLabel: UILabel!
    @IBOutlet private weak var passwordTitleLabel: UILabel!
    @IBOutlet private weak var confrimPasswordTitleLabel: UILabel!
    @IBOutlet private weak var usernameTitleLabel: UILabel!
    
    // Value
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confrimPasswordTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    
    // Button
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var facebookButton: UIButton!
    
    // Loading
    fileprivate var loadingScreen: LoadingScreen!
    
    //ViewModel
    fileprivate var viewModel: RegisterProtocol!
    
    fileprivate var disposeBag = DisposeBag()
    
    // MARK :- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViewModel()
    }
    
    // MARK: - Config
    func config(viewModel: RegisterProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK :- setup
    private func setUp() {
        loadingScreen = LoadingScreen(frame: self.view.bounds)
        registerBoxView.cornerRadius(cornerRadius: 10.0)
        registerButton.cornerRadius(cornerRadius: 22.0)
        facebookButton.cornerRadius(cornerRadius: 22.0)
        
        if viewModel.output.isFacebook(), let item = viewModel.output.getFacebookData() {
            emailTextField.text = item.email
            usernameTextField.text = item.firstName
        }
    }
    
    // MARK :- Action
    @IBAction func closeAction(_ sender: UIButton) {
        dismissAction(completion: nil)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        viewModel.input.signUp(email: emailTextField.text,
                               password: passwordTextField.text,
                               confrimPassword: confrimPasswordTextField.text,
                               username: usernameTextField.text)
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        debugPrint("facebookAction")
    }
}

// MARk :- Fileprivate
fileprivate extension RegisterViewController {
    func bindViewModel() {
        viewModel.output.showLoading = showLoading
        viewModel.output.hideLoading = hideLoading
        viewModel.output.didRegisterFbSuccess = didRegisterFbSuccess
        viewModel.output.didRegisterSuccess = didRegisterSuccess
        
        viewModel.output.didError = didError
        viewModel.output.didErrorCustom = didErrorCustom
        
        viewModel.output.didRxError.subscribe(onNext: { error in
            if let userError = error as? RegisterError {
                debugPrint("Subscription : \(userError.message)")
            }
        }, onDisposed: nil).disposed(by: self.disposeBag)
    }
  
    func showLoading() {
        loadingScreen.attach(hostView: self.view)
    }
    
    func hideLoading() {
        loadingScreen.hideAndStop()
    }
    
    func didRegisterFbSuccess(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AlertHelper.alert(title: "ErrorAlertTitle".localized,
                              message: message,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger) { [weak self] in
                                guard let weakSelf = self else { return }
                                weakSelf.dismissAction(completion: nil)
            }
        }
    }
    
    func didRegisterSuccess(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AlertHelper.alert(title: "ErrorAlertTitle".localized,
                              message: message,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger) { [weak self] in
                                guard let weakSelf = self else { return }
                                weakSelf.dismissAction(completion: nil)
            }
        }
    }
    
    func didErrorCustom(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AlertHelper.alert(title: "ErrorTitle".localized,
                              message: message,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger) { }
        }
    }
    
    func didError(error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let userError = error as? RegisterError {
                AlertHelper.alert(title: "ErrorTitle".localized,
                                  message: userError.message,
                                  majorTitleButton: "AlertOK".localized,
                                  majorButtonType: .danger) { }
                return
            }
            AlertHelper.alert(title: "ErrorTitle".localized,
                              message: error.localizedDescription,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger) { }
        }
    }
}

extension RegisterViewController: SPStorkControllerConfirmDelegate {
    
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

