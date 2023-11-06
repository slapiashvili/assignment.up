//
//  ViewController.swift
//  m2a7.NotesApp
//
//  Created by Salome Lapiashvili on 05.11.23.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: Properties
    let loginImage = UIImageView()
    let welcomeLabel = UILabel()
    let upperStackView = UIStackView()
    let lowerStackView = UIStackView()
    let backgroundImageView = UIImageView()
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        autoFillCredentials()
    }
    
    //MARK: private methods
    private func setupViews() {
        view.backgroundColor = .white
        setupBackground()
        setupLoginImage()
        setupWelcomeLabel()
        setupUpperStackView()
        setupLowerStackView()
        setupConstraints()
    }
    
    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "background.design")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLoginImage() {
        loginImage.image = UIImage(named: "login.Image")
        loginImage.contentMode = .scaleAspectFill
        view.addSubview(loginImage)
        loginImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel.text = "Welcome to ExipNotes"
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .noteAppTeal
        welcomeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUpperStackView() {
        upperStackView.axis = .vertical
        upperStackView.alignment = .center
        upperStackView.spacing = 10
        upperStackView.addArrangedSubview(loginImage)
        upperStackView.addArrangedSubview(welcomeLabel)
        view.addSubview(upperStackView)
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLowerStackView() {
        let signInLabel = createLabel(text: "Sign In here")
        usernameTextField = createTextField(placeholder: "username")
        passwordTextField = createTextField(placeholder: "password", isSecure: true)
        let loginButton = createLoginButton()
        
        lowerStackView.axis = .vertical
        lowerStackView.spacing = 8
        lowerStackView.alignment = .fill
        lowerStackView.distribution = .fillEqually
        
        [signInLabel, usernameTextField, passwordTextField, loginButton].forEach {
            lowerStackView.addArrangedSubview($0)
        }
        view.addSubview(lowerStackView)
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .noteAppLightBlue
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        textField.backgroundColor = UIColor.noteAppPink
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 15, weight: .bold)
        textField.textColor = .white
        return textField
    }
    
    private func createLoginButton() -> UIButton {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .noteAppTeal
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return loginButton
    }
    
    //MARK: constraints
    private func setupConstraints() {
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        loginImage.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            upperStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upperStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            upperStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: -10),
            loginImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            loginImage.widthAnchor.constraint(equalTo: loginImage.heightAnchor),
            
            lowerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lowerStackView.topAnchor.constraint(equalTo: upperStackView.bottomAnchor, constant: 20),
            lowerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            lowerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func saveLogin(username: String, password: String) {
        let service = "slap.ExipNotes"
        do {
            try KeychainHelper.standard.save(password.data(using: .utf8)!, service: service, account: username)
            UserDefaultsManager.shared.saveLastLoggedInUsername(username)
        } catch {
            print("Error saving to keychain: \(error)")
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        saveLogin(username: username, password: password)
        
        if UserDefaultsManager.shared.isFirstLogin(forUser: username) {
            UserDefaultsManager.shared.setFirstLoginFlag(forUser: username, isFirstLogin: false)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "Welcome!", message: "Hello, \(username), this is your first time signing into ExipNotes!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.moveToNoteList()
                })
                self.present(alert, animated: true)
            }
        } else {
            moveToNoteList()
        }
    }
}

//MARK: Navigation
extension LoginViewController {
    
    func moveToNoteList() {
        let noteListVC = NoteListViewController()
        navigationController?.pushViewController(noteListVC, animated: true)
    }
}

//MARK: Autofill
extension LoginViewController {
    private func autoFillCredentials() {
        let service = "slap.ExipNotes"
        
        if let retrievedUsername = UserDefaultsManager.shared.getLastLoggedInUsername(),
           let retrievedPasswordData = try? KeychainHelper.standard.read(service: service, account: retrievedUsername),
           let retrievedPassword = String(data: retrievedPasswordData, encoding: .utf8) {
            usernameTextField.text = retrievedUsername
            passwordTextField.text = retrievedPassword
        }
    }
}






