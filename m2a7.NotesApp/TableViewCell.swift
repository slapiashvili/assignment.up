//
//  TableViewCell.swift
//  m2a7.NotesApp
//
//  Created by Salome Lapiashvili on 05.11.23.
//


import UIKit

import UIKit

final class SpacingTableViewCell: UITableViewCell {
    
    //MARK: Properties
    let containerView = UIView()
    let noteLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupNoteLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupContainerView()
        setupNoteLabel()
    }
    
    //MARK: Private methods
    private func setupContainerView() {
        contentView.backgroundColor = UIColor.noteAppLightBlue
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.noteAppLightBlue
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupNoteLabel() {
        noteLabel.textColor = .black
        noteLabel.numberOfLines = 0
        containerView.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            noteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            noteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
    }

    func configure(with note: String) {
        noteLabel.text = note
    }
}
