//
//  AddProductVC.swift
//  A2_FA_iOS_Jaspinder_C0798164
//
//  Created by Jaspinder Singh on 22/05/21.
//

import UIKit
import CoreData

class AddProductVC: UIViewController {

    @IBOutlet weak var txtFldProductId: UITextField!
    @IBOutlet weak var txtFldProductName: UITextField!
    @IBOutlet weak var txtFldProductPrice: UITextField!
    @IBOutlet weak var txtFldProductProvider: UITextField!
    @IBOutlet weak var txtVwProductDescription: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var productDetails: ProductDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if productDetails != nil {
            txtFldProductId.text = productDetails.productId
            txtFldProductName.text = productDetails.productName
            txtFldProductPrice.text = productDetails.productPrice
            txtFldProductProvider.text = productDetails.productProvider
            txtVwProductDescription.text = productDetails.productDescription
        }
        
        self.navigationItem.title = "Add Product"

        // Do any additional setup after loading the view.
    }
    
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveData() {
        let rowObj = NSEntityDescription.insertNewObject(forEntityName: "Products", into: getContext())
        rowObj.setValue(txtFldProductId.text!, forKey: "productId")
        rowObj.setValue(txtFldProductName.text!, forKey: "productName")
        rowObj.setValue(txtFldProductPrice.text!, forKey: "productPrice")
        rowObj.setValue(txtFldProductProvider.text!, forKey: "productProvider")
        rowObj.setValue(txtVwProductDescription.text!, forKey: "productDescription")
        
        
        do{
            try getContext().save()
            print("Saved")
            AlertControl.shared.showAlert("Success", message: "Product Added", buttons: ["Ok"]) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }catch{
            print("Error")
        }
    }
    
    func updateData() {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
       // query.predicate = NSPredicate(format: "productId = %@", productDetail.productId)
        query.predicate = NSPredicate.init(format: "productId==\(productDetails.productId ?? "0")")
        query.returnsObjectsAsFaults = false
        
        do {
            let result = try getContext().fetch(query)
            for object in result {
                let dataModel = object as! NSManagedObject
                dataModel.setValue(txtFldProductId.text!, forKey: "productId")
                dataModel.setValue(txtFldProductName.text!, forKey: "productName")
                dataModel.setValue(txtFldProductPrice.text!, forKey: "productPrice")
                dataModel.setValue(txtFldProductProvider.text!, forKey: "productProvider")
                dataModel.setValue(txtVwProductDescription.text!, forKey: "productDescription")
            }
            try getContext().save()
            
            
        } catch {
            print("Some error occured when fetching the data!!")
        }
        
        
        do{
            try getContext().save()
            print("Saved")
            AlertControl.shared.showAlert("Success", message: "Product Updated", buttons: ["Ok"]) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }catch{
            print("Error")
        }
    }
    
    @IBAction func btnActnSave(_ sender: Any) {
        var boolSave = false
        var strAlert = ""
        if txtFldProductId.text == "" {
            strAlert = "Please enter Product Id"
        } else if txtFldProductName.text == "" {
            strAlert = "Please enter Product Name"
        } else if txtFldProductPrice.text == "" {
            strAlert = "Please enter Product Price"
        } else if txtFldProductProvider.text == "" {
            strAlert = "Please enter Product Provider"
        } else if txtVwProductDescription.text == "" {
            strAlert = "Please enter Product Description"
        } else {
            boolSave = true
        }
        
        if boolSave {
            if productDetails != nil {
                updateData()
            } else {
                saveData()
            }
        } else {
            AlertControl.shared.showAlert("Alert!", message: strAlert, buttons: ["OK"], completion: nil)
        }
    }

}
