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
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var myAmazonTitle: UILabel!
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var myAmazonStatus: UILabel!
    
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
        self.myTextField.endEditing(true)
    }
    
    func getAmazonListPrice(){
        let myURLstring = "http://amazon.com/dp/" + myTextField.text!
        let myURL = NSURL(string: myURLstring)
        let myTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!) {
            (myData, myResponse, myError) -> Void in
            
            if let myDataCode = myData{
                let myDataString = NSString(data: myDataCode,encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.Price.text = "Price: "
                        self.myAmazonLP.text = self.splitString(myDataString!) as? String})
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.BookTitle.text = "Title: "
                        self.myAmazonTitle.text = self.splitTitleString(myDataString!) as? String})
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.Status.text = "Status: "
                        self.myAmazonStatus.text = self.splitStatusString(myDataString!) as? String})
                
            }
        }
        
        myTask.resume()
        
    }
    
    func splitStatusString(htmlString:NSString) -> NSString?{
        let myArray1  = htmlString.componentsSeparatedByString("<span class=\"a-size-medium a-color-success\">")
        if myArray1.count > 1{
            let myArray2 = myArray1[1].componentsSeparatedByString("</span>")
            if myArray2.count > 1{
                let myBookTitle = myArray2[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                return myBookTitle
            }
        }
        return nil
    }

    
    
    func splitTitleString(htmlString:NSString) -> NSString?{
        let myArray1  = htmlString.componentsSeparatedByString("<span id=\"productTitle\" class=\"a-size-large\">")
        if myArray1.count > 1{
            let myArray2 = myArray1[1].componentsSeparatedByString("</span>")
            if myArray2.count > 1{
                let myBookTitle = myArray2[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                return myBookTitle
            }
        }
        return nil
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

