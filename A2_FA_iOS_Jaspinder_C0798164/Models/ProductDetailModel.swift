//
//  ProductDetailModel.swift
//  A2_FA_iOS_Jaspinder_C0798164
//
//  Created by Jaspinder Singh on 22/05/21.
//

import Foundation

struct ProductDetailModel {
    var productId: String!
    var productName: String!
    var productPrice: String!
    var productProvider: String!
    var productDescription: String!
    
    init(_ dict: [String: Any]) {
        productId = dict["productId"] as? String ?? ""
        productName = dict["productName"] as? String ?? ""
        productPrice = dict["productPrice"] as? String ?? ""
        productProvider = dict["productProvider"] as? String ?? ""
        productDescription = dict["productDescription"] as? String ?? ""
    }
}
