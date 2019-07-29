//
//  ProductCell.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    var product : Product? {
        didSet {
            productPrice.text = product?.currencyHolder.convertedCurrecy.displayString
            productName.text = product?.name
        }
    }
    
    public let productImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let productPrice : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let productName : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.productImage)
        self.addSubview(self.productPrice)
        self.addSubview(self.productName)        
        
        //set constraints for cell elements
        self.productImage.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 170, height: 150, enableInsets: false)
        self.productPrice.anchor(top: self.productImage.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0 , height: 0, enableInsets: false)
        self.productName.anchor(top: self.productPrice.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0 , height: 0, enableInsets: false)
    }
    
    override func prepareForReuse() {
        self.productImage.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
