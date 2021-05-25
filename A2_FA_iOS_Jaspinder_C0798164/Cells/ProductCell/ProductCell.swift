//
//  ProductCell.swift
//  A2_FA_iOS_Jaspinder_C0798164

//  Created by Jaspinder Singh on 22/05/21.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var lblProductId: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
