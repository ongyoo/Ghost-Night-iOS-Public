//
//  LoginViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/6/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController
import Core
import Component

protocol LoginDelegate {
    func loginSuccess()
    func userDetailSuccess()
}

final class LoginViewController: BaseViewController {
    @IBOutlet private weak var loginBoxView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var facebookLoginButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // LoginDelegate
    var delegate: LoginDelegate?
    // Loading
    fileprivate var loadingScreen: LoadingScreen!
    
    //ViewModel
    fileprivate var viewModel: LoginProtocol!
    
    deinit {
        debugPrint("Deinit LoginViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Config
    func config(viewModel: LoginProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK :- setUp
    private func setUp() {
        loadingScreen = LoadingScreen(frame: self.view.bounds)
        loginBoxView.cornerRadius(cornerRadius: 10.0)
        loginButton.cornerRadius(cornerRadius: 22.0)
        registerButton.cornerRadius(cornerRadius: 22.0)
        facebookLoginButton.cornerRadius(cornerRadius: 22.0)
    }
    
    // MARK :- Action
    @IBAction func closeAction(_ sender: UIButton) {
        dismissAction(completion: nil)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        viewModel.input.signIn(username: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        NavigationManager.presentViewController(to: .register(self, nil))
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        viewModel.input.signInFacebookSDK(target: self)
    }
}

extension LoginViewController: SPStorkControllerConfirmDelegate {
    
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

// MARk :- Fileprivate
fileprivate extension LoginViewController {
    func bindViewModel() {
        viewModel.output.showLoading = showLoading
        viewModel.output.hideLoading = hideLoading
        
        viewModel.output.didLoginSuccess = didLoginSuccess
        viewModel.output.didUserDetailSuccess = didUserDetailSuccess
        viewModel.output.didUserFacebookToRegister = didUserFacebookToRegister
        viewModel.output.didError = didError
    }
    
    func showLoading() {
        loadingScreen.attach(hostView: self.view)
    }
    
    func hideLoading() {
        loadingScreen.hideAndStop()
    }
    
    func didLoginSuccess() {
        delegate?.loginSuccess()
        Notification.Name.UserDidChange.post()
        dismissAction(completion: nil)
    }
    
    func didUserDetailSuccess() {
        delegate?.userDetailSuccess()
        Notification.Name.UserDetailSuccess.post()
        dismissAction(completion: nil)
    }
    
    func didUserFacebookToRegister(fbItem: FacebookResponse) {
        NavigationManager.presentViewController(to: .register(self, fbItem))
    }
    
    func didError(error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let userError = error as? SigninError {
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

