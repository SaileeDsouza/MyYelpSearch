//
//  DetailViewController.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import UIKit
import SDWebImage

final class DetailViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewText: UILabel!
    
    var restaurantViewModel: RestaurantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = restaurantViewModel?.name
    }
    
    private func configureUI() {
        if isValidImageUrl() {
            let imageUrl = URL(string: (restaurantViewModel?.imageURL)!)
            restaurantImage.sd_setImage(with: imageUrl, completed: nil)
        } else {
            restaurantImage.isHidden = true
        }
        nameLabel.text = restaurantViewModel?.name
        addressLabel.text = restaurantViewModel?.displayAddress?.joined(separator: "\n")
    }
    
    private func fetchReviews() {
        guard let businessId = restaurantViewModel?.id else { return }
        showActivityIndicator(onView: self.view)
        applicationServices.getBusinessService()?.getBusinessReviews(id: businessId, onCompletion: { [unowned self] errorResponse, response in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if let error = errorResponse { //handle error here
                    self.showAlertMessage(message: error.message)
                } else {
                    guard let reviewResponse = response, reviewResponse.count > 0 else { return }
                    let sortedReviews = reviewResponse.sorted(by: { element1, element2 in
                        if element1.timeCreated.date()?.compare(element2.timeCreated.date()!) == ComparisonResult.orderedDescending {
                            return true
                        } else {
                            return false
                        }
                    })
                    self.updateReviewsUI(response: sortedReviews.first!)
                }
            }
        })
    }
    
    //checks if thumbnail image is valid and can open as URL
    private func isValidImageUrl() -> Bool {
        guard let thumbnailUrl = restaurantViewModel?.imageURL else { return false }
        if let imageUrl = URL(string: thumbnailUrl), UIApplication.shared.canOpenURL(imageUrl) {
            return true
        } else {
            print("Invalid Image Url")
            return false
        }
    }
    
    //updates the Review UI based on response
    private func updateReviewsUI (response: Review) {
        reviewText.text = response.text
        if let imageURL = URL(string: response.user?.image_url ?? "") {
            reviewImage.sd_setImage(with: imageURL, completed: nil)
        }
    }
}

private extension String  {
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        return date
    }
}
