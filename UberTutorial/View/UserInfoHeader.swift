//
//  UserInfoHeader.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 18.09.2024.
//

import UIKit

class UserInfoHeader: UIView {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.addSubview(initialLabel)
        initialLabel.centerX(inView: view)
        initialLabel.centerY(inView: view)
        
        return view
    }()
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 42)
         label.textColor = .white
         label.text = user.firstInitial
         return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = . lightGray
        label.text = user.email
        return label
    }()
    
    //MARK: - Lifecycle
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        profileImageView.setDimensions(height: 64, width: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        let stak = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stak.distribution = .fillEqually
        stak.spacing = 4
        stak.axis = .vertical
        addSubview(stak)
        stak.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
