//
//  MenuController.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 12.09.2024.
//

import UIKit

private let reuseIdentifier = "MenuCell"

enum menuOptions: Int, CaseIterable, CustomStringConvertible {
    case yourTrips
    case settings
    case logout
    
    var description: String {
        switch self {
        case .yourTrips:
            return "Your Trips"
        case .settings:
            return "Settings"
        case .logout:
            return "Log Out"
        }
    }
}

protocol MenuControllerDelegate: AnyObject {
    func didSelect(option: menuOptions)
}

class MenuController: UITableViewController {
    
    //MARK: - Properties
    
    private let user: User
    weak var delegate: MenuControllerDelegate?
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140)
        let view = MenuHeader(user: user, frame: frame)
        return view
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        print(user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
    }
}

//MARK: - UITableView Delegate/Datasource

extension MenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        guard let option = menuOptions(rawValue: indexPath.row) else { return UITableViewCell()}
        cell.textLabel?.text = option.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = menuOptions(rawValue: indexPath.row) else { return }
        delegate?.didSelect(option: option)
    }
}
