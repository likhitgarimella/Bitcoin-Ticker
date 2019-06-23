//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Likhit Garimella on 22/06/2019.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","USD", "INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "$", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "R"]
    
    var finalURL = ""
    
    var currencySelected = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count  //Number of rows in the picker is the number of currencies in the currency array
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]   //Title for the picker everytime is the each and every element in the currency array
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        // On printing just row -> We need to print the number of row when the picker stops on one particlar currency, whose the row number is to be printed in the console
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        //We have all the currency names stored in the currencyArray already. Let’s use that and the row selected to "make up the finalURL". We’ve already made a variable to store the baseURL. When a user selects one particular currency, that 3 letter word is added up to the base URL and a final URL is produced.
        
        currencySelected = currencySymbolArray[row] //We get the selected currency symbol from currencySymbolArray
        
        getBitcoinData(url: finalURL)   //Only after calling this function, we get the price label updated with whatever currency that we put in grabbing the data from the finalURl.
        
    }
    
    override func viewDidLoad() {
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        super.viewDidLoad()
    
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
        
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResult)
        
    }
        
        else
        {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }

}

