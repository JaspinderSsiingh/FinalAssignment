//
//  ProductDetailsVC.swift
//  A2_FA_iOS_Jaspinder_C0798164
//
//  Created by Jaspinder Singh on 22/05/21.
//

import UIKit
import CoreData

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var lblProductId: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductProvider: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    
    var productDetail: ProductDetailModel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Product Details"
        
        lblProductId.text = "Product Id: \n" + productDetail.productId
        lblProductName.text = "Product Name: \n" + productDetail.productName
        lblProductPrice.text = "Product Price: \n$" + productDetail.productPrice
        lblProductProvider.text = "Product Provider: \n" + productDetail.productProvider
        lblProductDescription.text = "Product Description: \n" + productDetail.productDescription

        // Do any additional setup after loading the view.
    }
    
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func btnActionEdit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddProductVC") as! AddProductVC
        vc.productDetails = productDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActnDelete(_ sender: Any) {
        AlertControl.shared.showAlert("Alert!", message: "Do you want to delete this product?", buttons: ["Yes", "No"]) { [self] index in
            if index == 0 {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
               // query.predicate = NSPredicate(format: "productId = %@", productDetail.productId)
                query.predicate = NSPredicate.init(format: "productId==\(productDetail.productId ?? "0")")
                query.returnsObjectsAsFaults = false
                
                do {
                    let result = try getContext().fetch(query)
                    for object in result {
                        getContext().delete(object as! NSManagedObject)
                    }
                    try getContext().save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Some error occured when fetching the data!!")
                }
            }
        }
    }
    
}
