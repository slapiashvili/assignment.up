//
//  NoteListViewController.swift
//  m2a7.NotesApp
//
//  Created by Salome Lapiashvili on 05.11.23.
//

import UIKit

class NoteListViewController: UIViewController {

    //MARK: properties
    var notes: [String] = []
    let tableView = UITableView()
    let addButton = UIButton()
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupAddButton()
        view.backgroundColor = UIColor.noteAppPink
    }
    
    //MARK: private methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SpacingTableViewCell.self, forCellReuseIdentifier: "SpacingCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAddButton() {
        
        let symbolImage = UIImage(systemName: "plus.circle")
        addButton.setImage(symbolImage, for: .normal)
        addButton.tintColor = .noteAppDarkBlue
        addButton.setTitle("", for: .normal)
        addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func handleNewNote(_ note: String) {
        notes.insert(note, at: 0)
        if let username = UserDefaultsManager.shared.getLastLoggedInUsername() {
            UserDefaultsManager.shared.saveNotes(notes, forUser: username)
        }
        tableView.reloadData()
    }

    private func showNoteDetailsViewController(with note: String, at indexPath: IndexPath) {
        let noteDetailsVC = NoteDetailsViewController()
        noteDetailsVC.note = note
        noteDetailsVC.onSave = { [weak self] updatedNote in
            guard let strongSelf = self else { return }
            
            strongSelf.notes[indexPath.row] = updatedNote
            strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
            
           
            if let username = UserDefaultsManager.shared.getLastLoggedInUsername() {
                UserDefaultsManager.shared.saveNotes(strongSelf.notes, forUser: username)
            }
        }

        let navigationController = UINavigationController(rootViewController: noteDetailsVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    
    private func isFirstLogin() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "isFirstLogin")
    }
    
    private func showAlertForFirstLogin(username: String) {
        let alert = UIAlertController(title: "Welcome", message: "Hello, \(username), this is your first time loggin into ExipNotes, press OK and Log In to proceed", preferredStyle: .alert)
        alert.view.tintColor = UIColor.noteAppPurple
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaults.standard.set(false, forKey: "isFirstLogin")
        })
        present(alert, animated: true)
    }
    
    @objc private func addNote() {
        let addNoteVC = AddNoteViewController()
        addNoteVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addNoteVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
}


// MARK: UITableViewDataSource

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpacingCell", for: indexPath) as? SpacingTableViewCell else {
            fatalError("Failed to dequeue a SpacingTableViewCell.")
        }
        let noteText = notes[indexPath.row]
        cell.configure(with: noteText)
        return cell
    }
}

//MARK: UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNoteDetailsViewController(with: notes[indexPath.row], at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                notes.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if let username = UserDefaultsManager.shared.getLastLoggedInUsername() {
                    UserDefaultsManager.shared.saveNotes(notes, forUser: username)
                }
            }
        }
}

//MARK: AddNoteViewControllerDelegate
extension NoteListViewController: AddNoteViewControllerDelegate {
    func didSaveNewNote(_ note: String) {
        notes.insert(note, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
}



