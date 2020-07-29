//
//  ViewController.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortStack: UIStackView!
    @IBOutlet weak var sortSwitch: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        isAscending = !isAscending
        performSort(List: searchResultList)
    }
    
    //MARK:- Properties
    private var searchResultList = [RestaurantModel]() {
        didSet {
            sortStack.isHidden = !(searchResultList.count > 0)
            collectionView.reloadData()
        }
    }
    private var locationManager = CLLocationManager()
    private var latitude:Double?
    private var longitude:Double?
    private var isAscending: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchLocation()
    }
    
    private func fetchLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //configures the UI for the view.
    private func configureUI() {
        searchBar.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.register(.SearchCollectionViewCell, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    //method for updating the navigation bar
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Search Restaurants"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .red
    }
    
    //method responsible for triggering the search Call and updating the view based on response
    private func performSearch(with searchText: String) {
        searchResultList = []
        showActivityIndicator(onView: self.view)
        applicationServices.getBusinessService()?.getBusinessSearchResults(searchTerm: searchText, latitude: latitude, longitude: longitude, onCompletion: { [unowned self] errorResponse, response in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if let error = errorResponse { //handle error here
                    self.searchResultList = []
                    self.collectionView.setEmptyView(message: error.message)
                } else {
                    guard let restaurantResponse = response else { return }
                    self.collectionView.restore()
                    self.performSort(List: restaurantResponse)
                }
            }
        })
    }
    
    private func performSort(List: [RestaurantModel]) {
        if isAscending {
            searchResultList = List.sorted(by: { $0.name < $1.name})
        } else { //descending sort
            searchResultList = List.sorted(by: { $0.name > $1.name})
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchResultList = []
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchText.count > 0{
            performSearch(with: searchText)
        }
    }
}

//MARK:- CollectionView Datasource Methods
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(restaurantModel: searchResultList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailView = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailView.restaurantViewModel = searchResultList[indexPath.item]
            navigationController?.pushViewController(detailView, animated: true)
        }
    }
}

//MARK:- CollectionView Delegate Methods
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: (collectionViewSize/2 - 1), height: 130)
    }
}

//MARK:- Location Delegate Methods
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    // If we have been deined access , informing user that default location- Toronto will be used.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            let currentLoc = manager.location
            latitude = currentLoc?.coordinate.latitude
            longitude = currentLoc?.coordinate.longitude
        } else if(status == CLAuthorizationStatus.denied) {
            //access denied
            latitude = nil
            longitude = nil
            showAlertMessage(message: "Your Location Services are turned off.\n Default location- Toronto will be used for further Searches")
        }
    }
}
