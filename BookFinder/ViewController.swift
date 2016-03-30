//
//  ViewController.swift
//  BookFinder
//
//  Created by Ricky Chen on 3/29/16.
//  Copyright © 2016 Ricky Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myAmazonLP: UILabel!
    
    func validateISPN() -> Bool{
        if let myISBNText = myTextField.text{
            if(myISBNText.characters.count == 10){
                return true
            }
        }
        myTextField.text = "Invalid ISBN number..."
        return false
    }
    
    
    
    @IBAction func getPrices(sender: AnyObject) {
        if(validateISPN()){
            getAmazonListPrice()
        }
    }
    
    func getAmazonListPrice(){
        let myURLstring = "http://amazon.com/dp/" + myTextField.text!
        let myURL = NSURL(string: myURLstring)
        let myTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!) {
            (myData, myResponse, myError) -> Void in
            
            if let myDataCode = myData{
                let myDataString = NSString(data: myDataCode,encoding: NSUTF8StringEncoding)
                
                dispatch_async(dispatch_get_main_queue(),
                    {self.myAmazonLP.text = self.splitString(myDataString!) as? String})
            
            }
        }
        
        myTask.resume()
        
    }
    
    func splitString(htmlString:NSString) -> NSString?{
        let myArray1 = htmlString.componentsSeparatedByString("<span class=\"a-color-price\">")
        if myArray1.count > 1{
            let myArray2 = myArray1[1].componentsSeparatedByString("</span>")
            if myArray2.count > 1 {
                let myListPrice = myArray2[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                return myListPrice
            }
        }
        return nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

