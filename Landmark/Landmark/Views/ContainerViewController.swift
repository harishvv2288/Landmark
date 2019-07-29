//
//  ViewController.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var currencyConverterSegment: UISegmentedControl!
    
    var productManager: ProductManager?
    var inventory: Inventory?

    let startTime: Date = Date()
    
    //total timer duration in seconds
    let duration: TimeInterval = CONSTANTS_STRUCT.END_TIMER / 1000.0
    
    //to hold the downloaded images
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpView()
        
        self.productManager = ProductManager()
        
        //actual trigger for the service call from View
        let _  = self.productManager?.triggerServiceCall(serviceType: .fetchProductList, completion: { (result) in
            if !result.hasError {
                self.inventory = result.value as? Inventory
                
                //hold this conversion map globally
                CurrencyHandler.sharedInstance.conversionMap = self.inventory?.conversion
                
                DispatchQueue.main.async {
                    //do all UI operations in main thread after successful response is read
                }
            } else {
                print("Failed to receive response!")
            }
        })
    }
    
    private func setUpView() {
        self.startTimer()
        self.productsCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: IDENTIFIERS.PRODUCT_CELL_ID)
        
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 50.0)
        layout.itemSize = CGSize.init(width: 200.0, height: 250.0)
        self.productsCollectionView.collectionViewLayout = layout
    }
    
    
    func startTimer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
   @discardableResult @objc func updateTimer() -> String {
        var runningTime: TimeInterval = 0
        
        //current time
        let time: Date = Date()
        var timerValue = ""
        
        runningTime = time.timeIntervalSince(startTime)
        if runningTime < duration {
            //the amount of time remaining
            timerValue = self.displayableTimeString(time: duration - runningTime)
            if (self.countdownTimer != nil) {
                self.countdownTimer.text = "\(timerValue) Left"
            }
        }
        return timerValue
    }

    
    func displayableTimeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.timer?.invalidate()
//    }
}

//handle collection view delegates
extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inventory?.product.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productsCollectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIERS.PRODUCT_CELL_ID, for: indexPath) as! ProductCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        
        let currentProduct = self.inventory?.product[indexPath.row]
        cell.product = currentProduct
        
        //add a placeholder image in case an image is not available for a row
        cell.productImage.image = UIImage(named: "placeholder")
        
        if let imageString = currentProduct?.url {
            //check to see if the image is in cache
            if let cachedImage = self.imageCache.object(forKey: imageString as NSString) {
                //using cached image and hence no need to download it
                cell.productImage.image = cachedImage
            } else {
                //trigger image download
                let session =  URLSession.shared
                guard let url = URL(string: imageString) else {
                    print("Failed to create URL")
                    return cell
                }
                
                let task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async {
                            //check to ensure the current cell is visible before we assign the downloaded image
                            if let updateCell = self.productsCollectionView.cellForItem(at: indexPath) as? ProductCell {
                                if let downloadedImage = UIImage(data: data) {
                                    updateCell.productImage.image = downloadedImage
                                    //save the downloaded image in cache for reuse during scroll
                                    self.imageCache.setObject(downloadedImage, forKey: imageString as NSString)
                                }
                            }
                        }
                    }
                })
                task.resume()
            }
        }
        return cell
    }
}

//handle segment selection
extension ContainerViewController {
    
    @IBAction func currencyChanged(_ sender: UISegmentedControl) {
        if let currenctSelection = self.currencyConverterSegment.titleForSegment(at: sender.selectedSegmentIndex) {
            CurrencyHandler.sharedInstance.updateCurrency(currency: currenctSelection)
        }
        self.productsCollectionView.reloadData()
    }
    
}
