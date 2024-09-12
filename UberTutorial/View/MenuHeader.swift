//
//  MenuHeader.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 12.09.2024.
//

import UIKit

class MenuHeader: UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            fullnameLabel.text = user?.fullname
            emailLabel.text = user?.email
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Name Name"
        return label
    }()
    
    private let emailLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = . lightGray
        label.text = "test@gmail.com"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 12, width: 64, height: 64)
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
    //MARK: - Selectors
}
