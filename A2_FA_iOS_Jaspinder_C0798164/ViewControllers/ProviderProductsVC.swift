//
//  ProviderProductsVC.swift
//  A2_FA_iOS_Jaspinder_C0798164
//
//  Created by Jaspinder Singh on 22/05/21.
//

import UIKit
import CoreData

class ProviderProductsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblVwProducts: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrayProduct = [ProductDetailModel]()
    var strProvider = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVwProducts.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
        self.navigationItem.title = "Products"
        
        getData()

        // Do any additional setup after loading the view.
    }
    
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // Fetch Data
    func getData() {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")

        query.predicate = NSPredicate(format: "productProvider CONTAINS[cd] %@", strProvider)

        query.returnsObjectsAsFaults = false;
        
        do {
            let results = try getContext().fetch(query)
            
            print("Rows found in db: " , results.count)
            
            for i in 0..<results.count {
                let dataVal = results[i] as! NSManagedObject
                var model = ProductDetailModel([:])
                model.productId = dataVal.value(forKey: "productId") as? String ?? ""
                model.productName = dataVal.value(forKey: "productName") as? String ?? ""
                model.productPrice = dataVal.value(forKey: "productPrice")  as? String ?? ""
                model.productProvider = dataVal.value(forKey: "productProvider") as? String ?? ""
                model.productDescription = dataVal.value(forKey: "productDescription") as? String ?? ""
                arrayProduct.append(model)
            }
            
            
            tblVwProducts.reloadData()
        }
        catch {
            print("Some error occured when fetching the data!!")
        }
        
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.lblProductId.text = "Product Id : " + arrayProduct[indexPath.row].productId
        cell.lblProductName.text = "Product Name : " + arrayProduct[indexPath.row].productName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.productDetail = arrayProduct[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
