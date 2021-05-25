//
//  ProductsVC.swift
//  A2_FA_iOS_Jaspinder_C0798164
//
//  Created by Jaspinder Singh on 22/05/21.
//

import UIKit
import CoreData

class ProductsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBr: UISearchBar!
    @IBOutlet weak var tblVwProducts: UITableView!
    @IBOutlet weak var btnProduct: UIButton!
    
    var arrayProduct = [ProductDetailModel]()
    var arrayAllProduct = [ProductDetailModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var boolProducts = true
    var arrayProvider = [String]()
    var arrayAllProvider = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVwProducts.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        tblVwProducts.register(UINib(nibName: "ProviderCell", bundle: nil), forCellReuseIdentifier: "ProviderCell")
        
        self.navigationItem.title = "Products"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addProduct(_:)))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayProduct = []
        arrayAllProduct = []
        arrayProvider = []
        arrayAllProvider = []
        getData()
    }
    
    
    @IBAction func btnActnShowType(_ sender: Any) {
        boolProducts = !boolProducts
        btnProduct.setTitle(boolProducts ? "Show Providers" : "Show Products", for: .normal)
        if boolProducts {
            if searchBr.text == "" {
                arrayProduct = arrayAllProduct
            } else {
                arrayProduct = arrayAllProduct.filter({ first in
                    return first.productName.lowercased().contains(searchBr.text!.lowercased()) || first.productDescription.lowercased().contains(searchBr.text!.lowercased())
                })
            }
        } else {
            if searchBr.text == "" {
                arrayProvider = arrayAllProvider
            } else {
                arrayProvider = arrayAllProvider.filter({ first in
                    return first.lowercased().contains(searchBr.text!.lowercased())
                })
            }
        }
        tblVwProducts.reloadData()
        self.navigationItem.title = boolProducts ? "Products" : "Providers"
    }
    
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func getData() {
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
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
                arrayAllProduct.append(model)
                if !arrayProvider.contains(model.productProvider) {
                    arrayProvider.append(model.productProvider)
                }
            }
            
            arrayAllProvider = arrayProvider
            
            print("arrayProvider:- ")
            print(arrayProvider)
            if boolProducts {
                if searchBr.text == "" {
                    arrayProduct = arrayAllProduct
                } else {
                    arrayProduct = arrayAllProduct.filter({ first in
                        return first.productName.lowercased().contains(searchBr.text!.lowercased()) || first.productDescription.lowercased().contains(searchBr.text!.lowercased())
                    })
                }
            } else {
                if searchBr.text == "" {
                    arrayProvider = arrayAllProvider
                } else {
                    arrayProvider = arrayAllProvider.filter({ first in
                        return first.lowercased().contains(searchBr.text!.lowercased())
                    })
                }
            }
            
            
            tblVwProducts.reloadData()
        }
        catch {
            print("Some error occured when fetching the data!!")
        }
        
    }
    
    
    @objc func addProduct(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddProductVC") as! AddProductVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boolProducts ? arrayProduct.count : arrayProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if boolProducts {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
            cell.lblProductId.text = "Product Id : " + arrayProduct[indexPath.row].productId
            cell.lblProductName.text = "Product Name : " + arrayProduct[indexPath.row].productName
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCell") as! ProviderCell
        cell.lblProvider.text = arrayProvider[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if boolProducts {
            let vc = self.storyboard?.instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.productDetail = arrayProduct[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(identifier: "ProviderProductsVC") as! ProviderProductsVC
            vc.strProvider = arrayProvider[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return boolProducts
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
            // query.predicate = NSPredicate(format: "productId = %@", productDetail.productId)
            query.predicate = NSPredicate.init(format: "productId==\(arrayProduct[indexPath.row].productId ?? "0")")
            query.returnsObjectsAsFaults = false
            
            do {
                let result = try getContext().fetch(query)
                for object in result {
                    getContext().delete(object as! NSManagedObject)
                }
                try getContext().save()
            } catch {
                print("Some error occured when fetching the data!!")
            }
            arrayProduct = []
            arrayAllProduct = []
            arrayProvider = []
            arrayAllProvider = []
            getData()
        }
        
    }
    
}

extension ProductsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if boolProducts {
            if searchBr.text == "" {
                arrayProduct = arrayAllProduct
            } else {
                arrayProduct = arrayAllProduct.filter({ first in
                    return first.productName.lowercased().contains(searchBr.text!.lowercased()) || first.productDescription.lowercased().contains(searchBr.text!.lowercased())
                })
            }
        } else {
            if searchBr.text == "" {
                arrayProvider = arrayAllProvider
            } else {
                arrayProvider = arrayAllProvider.filter({ first in
                    return first.lowercased().contains(searchBr.text!.lowercased())
                })
            }
        }
        tblVwProducts.reloadData()
    }
}
