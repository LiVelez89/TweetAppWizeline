//
//  TweetCell.swift
//  TweetAppWizeline
//
//  Created by Lina on 24/05/23.
//

import UIKit

final class TweetCell: UITableViewCell {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    static let identifier = "TweetCell"
    
    private(set) lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var usernameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        
        return label
    }()
    
    private(set) lazy var contentLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - Layout
    private func setup() {
        backgroundColor = .systemBackground
        setupUserImageView()
        setupNameLabel()
        setupUsernameLabel()
        setupContentLabel()
    }
    
    private func setupUserImageView() {
        addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0),
            usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupContentLabel() {
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor, constant: 0),
            contentLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 0),
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    var viewModel: TweetCellViewModel? {
        didSet {
            configureInformation()
        }
    }
    
    private func configureInformation() {
        contentLabel.text = viewModel?.content
        nameLabel.text = viewModel?.profileName
        usernameLabel.text = viewModel?.userName
        userImageView.image = viewModel?.profilePicture
    }
}

struct TweetCellViewModel {
    let userName: String
    let profileName: String
    let profilePictureName: String
    let content: String
    
    var profilePicture: UIImage? {
        return UIImage(named: profilePictureName)
    }
}

