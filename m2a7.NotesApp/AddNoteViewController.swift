//
//  AddNoteViewController.swift
//  m2a7.NotesApp
//
//  Created by Salome Lapiashvili on 05.11.23.
//

import UIKit

protocol AddNoteViewControllerDelegate: AnyObject {
    func didSaveNewNote(_ note: String)
}

final class AddNoteViewController: UIViewController {
    
    //MARK: Properties
    let textField = UITextField()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    var onSave: ((String) -> Void)?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .noteAppLightBlue
    }
    
    //MARK: private methods
    private func setupViews() {
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20

        textField.placeholder = "Start writing your note here"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .noteAppPink
        textField.textColor = .black

        saveButton.setTitle("Save Note", for: .normal)
        saveButton.backgroundColor = .noteAppPurple
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveNoteAction), for: .touchUpInside)

        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])

        textField.heightAnchor.constraint(equalToConstant: 250).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    
    @objc private func saveNoteAction() {
        let noteText = textField.text ?? ""
        
        if !noteText.isEmpty {
            delegate?.didSaveNewNote(noteText)
        }
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: AddNoteViewControllerDelegate?
}


