//
//  AddLocationController.swift
//  UberTutorial
//
//  Created by Mykyta Yarovoi on 18.09.2024.
//

import UIKit
import MapKit

private let reuseIdentifier = "Cell"

protocol AddLocationControllerDelegate: AnyObject {
    func updateLocation(locationString: String, type: LocationType)
}

class AddLocationController: UITableViewController {
    
    //MARK: - Properties
    
    weak var delegate: AddLocationControllerDelegate?
    private let searchBar = UISearchBar()
    private let searchComplete = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let type: LocationType
    private let location: CLLocation
    private let searchCompleter = MKLocalSearchCompleter()
    
    //MARK: - Lyfecycle
    
    init(type: LocationType, location: CLLocation) {
        self.type = type
        self.location = location
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBaer()
        configureSearchCompleter()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        
        tableView.addShadow()
    }
    
    func configureSearchBaer() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureSearchCompleter() {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        searchCompleter.region = region
        searchCompleter.delegate = self
    }
}

//MARK: - TableView Delegate/DataSource

extension AddLocationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let title = result.title
        let subtitle = result.subtitle
        let locationString = title + " " + subtitle
        let trimmedLocation = locationString.replacingOccurrences(of: ", Ukraine", with: "")
        delegate?.updateLocation(locationString: trimmedLocation, type: type)
    }
}

//MARK: - UISearchBarDelegate

extension AddLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension AddLocationController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
