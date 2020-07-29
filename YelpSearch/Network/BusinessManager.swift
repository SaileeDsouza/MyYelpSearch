//
//  BusinessManager.swift
//  YelpSearch
//
//  Created by Sailee Pereira on 2020-07-27.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

/*
 this class is pertaining to only Business service, any business related API requests to be included here
 */
protocol BusinessService: class {
    var businesses: [BusinessElement]? { get }
    func getBusinessSearchResults(searchTerm: String, latitude: Double?, longitude: Double?, onCompletion: @escaping ((ErrorModel?, [RestaurantModel]?) -> ()))
    func getBusinessReviews(id: String, onCompletion: @escaping ((ErrorModel?, [Review]?) -> ()))
}

final class BusinessManager: BaseService, BusinessService {
    var businesses: [BusinessElement]?
    
    private static let getBusinessSearchUrl = "/businesses/search"
    private static let getReviewsUrl = "/businesses/{id}/reviews"
    
    static let shared = BusinessManager()
    
    func getBusinessSearchResults(searchTerm: String, latitude: Double?, longitude: Double?, onCompletion: @escaping ((ErrorModel?, [RestaurantModel]?) -> ())) {
        var params : [String : Any] = ["categories" :"restaurants", "term": searchTerm, "limit": 10]
        if let latitudeReceived = latitude, let longitudeReceived = longitude {
            params["latitude"] = latitudeReceived
            params["longitude"] = longitudeReceived
        } else {
            params["location"] = "Toronto"
        }
        self.makeRequest(uri: BusinessManager.getBusinessSearchUrl, method: .get, queryParams: params, completion: { responseModel in
            switch responseModel.responseCode {
            case .ok(_ ):
                if let responseData = responseModel.responseData, let result = self.toCodable(BusinessSearch.self, from: responseData) {
                    if let dataList =  result.businesses, dataList.count > 0 {
                        var resultList: [RestaurantModel] = []
                        dataList.forEach({ item in
                            let model = RestaurantModel(id: item.id, name: item.name, imageURL: item.imageURL, displayAddress: item.location?.displayAddress)
                            resultList.append(model)
                        })
                        onCompletion(nil, resultList)
                        return
                    } else {
                        onCompletion(ErrorModel(errorCode: 9999, message: "No Restaurants Found"), nil)
                        return
                    }
                }
            default:
                //try to encode the error response if any
                if let responseData = responseModel.responseData, let errorResult = self.toCodable(ErrorModel.self, from: responseData){
                    onCompletion(errorResult, nil)
                    return
                } else {
                    onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
                    return
                }
            }
            onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
        })
    }
    
    func getBusinessReviews(id: String, onCompletion: @escaping ((ErrorModel?, [Review]?) -> ())) {
        self.makeRequest(uri: BusinessManager.getReviewsUrl, method: .get, urlParams: ["id": id], completion: { responseModel in
            switch responseModel.responseCode {
            case .ok(_ ):
                if let responseData = responseModel.responseData, let result = self.toCodable(ReviewModel.self, from: responseData) {
                    if let dataList =  result.reviews, dataList.count > 0 {
                        var resultList: [Review] = []
                        dataList.forEach({ item in
                            let model = Review(id: item.id, rating: item.rating, user: item.user, text: item.text, timeCreated: item.timeCreated, url: item.url)
                            resultList.append(model)
                        })
                        onCompletion(nil, resultList)
                        return
                    } else {
                        onCompletion(ErrorModel(errorCode: 9999, message: "No Reviews Found"), nil)
                        return
                    }
                }
                
            default:
                //try to encode the error response if any
                if let responseData = responseModel.responseData, let errorResult = self.toCodable(ErrorModel.self, from: responseData){
                    onCompletion(errorResult, nil)
                    return
                } else {
                    onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
                    return
                }
            }
            onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
        })
    }
}

