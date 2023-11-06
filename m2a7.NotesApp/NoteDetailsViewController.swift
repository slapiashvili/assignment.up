import UIKit

final class NoteDetailsViewController: UIViewController {
    
    //MARK: Properties

    let textField = UITextField()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    var onSave: ((String) -> Void)?
    var note: String?
    
    
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
        textField.text = note

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
            textField.heightAnchor.constraint(equalToConstant: 250),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: Empty handling
    @objc func saveNoteAction() {
        if let updatedNote = textField.text, !updatedNote.isEmpty {
            onSave?(updatedNote)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Empty Note", message: "Please write something in the note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
