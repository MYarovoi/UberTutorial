//
//  RideAnctionView.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 03.09.2024.
//

import UIKit
import MapKit

protocol RideAnctionViewDelegate: AnyObject {
    func uploadTrip(_ view: RideAnctionView)
    func cancelTrip()
    func pickupPassenger()
    func dropOffPassenger()
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
            
        case .requestRide:
            return "CONFORM UBERX"
        case .cancel:
            return "CANCEL RIDE"
        case .getDirections:
            return "GET DIRECTIONS"
        case .pickup:
            return "PICKUP PASSENGER"
        case .dropOff:
            return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
}

class RideAnctionView: UIView {
    
    //MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    var buttonAction = ButtonAction()
    weak var delegate: RideAnctionViewDelegate?
    var user: User?
    
    var config = RideActionViewConfiguration() {
        didSet {
            configureUI(withConfig: config)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        view.addSubview(infoViewLabel)
        infoViewLabel.centerX(inView: view)
        infoViewLabel.centerY(inView: view)
        
        return view
    }()
    
    private let infoViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "X"
        return label
    }()
    
    private let uberInfolabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "UberX"
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16)
        infoView.setDimensions(height: 60, width: 60)
        infoView.layer.cornerRadius = 60 / 2
        
        addSubview(uberInfolabel)
        uberInfolabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        uberInfolabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: uberInfolabel.bottomAnchor, left: leftAnchor, right:  rightAnchor, paddingTop: 4, height: 0.75)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch buttonAction {
        case .requestRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirections:
            print("")
        case .pickup:
            delegate?.pickupPassenger()
        case .dropOff:
            delegate?.dropOffPassenger()
        }
    }
        
        //MARK: - Helper Functions
        
       private func configureUI(withConfig config: RideActionViewConfiguration) {
           switch config {
           case .requestRide:
               buttonAction = .requestRide
               actionButton.setTitle(buttonAction.description, for: .normal)
           case .tripAccepted:
               guard let user = user else { return }
               
               if user.accountType == .passenger {
                   titleLabel.text = "En Route To Passenger"
                   buttonAction = .getDirections
                   actionButton.setTitle(buttonAction.description, for: .normal)
               } else {
                   buttonAction = .cancel
                   actionButton.setTitle(buttonAction.description, for: .normal)
                   titleLabel.text = "Driver En Route"
               }
               
               infoViewLabel.text = String(user.fullname.first ?? "X")
               uberInfolabel.text = user.fullname
               
           case .driverArrived:
               guard let user = user else { return }
               
               if user.accountType == .driver {
                   titleLabel.text = "Driver Has Arrived"
                   addressLabel.text = "Please meet driver at pickup location"
               }
               
           case .pickupPassenger:
               titleLabel.text = "Arrived At Passenger Location"
               buttonAction = .pickup
               actionButton.setTitle(buttonAction.description, for: .normal)
           case .tripInProgress:
               guard let user = user else { return }
               
               if user.accountType == .driver {
                   actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                   actionButton.isEnabled = false
               } else {
                   buttonAction = .getDirections
                   actionButton.setTitle(buttonAction.description, for: .normal)
               }
               
               titleLabel.text = "En Route To Destination"
           case .endTrip:
               guard let user = user else { return }
               
               if user.accountType == .driver {
                   actionButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
                   actionButton.isEnabled = false
               } else {
                   buttonAction = .dropOff
                   actionButton.setTitle(buttonAction.description, for: .normal)
               }
               
               titleLabel.text = "Arrived at Destination"
           }
        }
    }
