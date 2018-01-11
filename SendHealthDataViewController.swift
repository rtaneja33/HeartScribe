//
//  GlucoseViewController.swift
//  ThirdPractice
//
//  Created by Rohan Taneja on 3/25/17.
//  Copyright © 2017 Rohan Taneja. All rights reserved.
//

import UIKit


class SendHealthDataViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var sendlist: UILabel!
    @IBOutlet weak var scrollvi: UIScrollView!
    @IBOutlet weak var tfw: UITextField!
    @IBOutlet weak var showb: UIButton!
    var hidden:Int = 0
    var cur:Int = 0
    let limitLength:Int = 3
    @IBOutlet weak var wlabel: UILabel!
    var LabelText = String()
    var symptoms = String()
    var glucose = String()
    var bp = String()
    var weight = String()
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    private let defaults = UserDefaults.standard
    @IBOutlet weak var homebutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("THIS IS LBEL TEXT HEREL: \(LabelText) end of label text")
        sendlist.sizeToFit()
        sendlist.adjustsFontSizeToFitWidth = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SendHealthDataViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Send Health Data"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        tlabel.text = self.title
        
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomeR"), style: .plain, target: self, action: #selector(back))
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 167.0/255.0, green: 147.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        
        
       // self.navigationController?.navigationBar.frame.origin.y = 60
        
        
    }
    
    
    func back(){
        self.navigationController?.popViewController(animated:true)
        
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showhis(_ sender: Any) {
        if hidden == 0
        {
            showb.setImage(UIImage(named: "history"), for: .normal)
            wlabel.isHidden = true
            hidden = 1
        }
        else
        {
            showb.setImage(UIImage(named: "hidehis"), for: .normal)
            wlabel.isHidden = false
            hidden = 0
            
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = tfw.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength // Bool
    }
    @IBAction func add(_ sender: Any) {
        if (tfw.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfw.text!)!;
            self.tfw.text = String(cur + 1);
        }
    }
    @IBAction func subtract(_ sender: Any) {
        if (tfw.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfw.text!)!;
            self.tfw.text = String(cur - 1);
        }
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.frame.origin.y = 40
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sharedata(_ sender: Any) {
        if let session2 = defaults.string(forKey: "symplabel") {
            symptoms = session2
        }
        if let session3 = defaults.string(forKey: "glulabel3") {
            glucose = session3
        }
        if let session4 = defaults.string(forKey: "welabel") {
            weight = session4
        }
        if let session5 = defaults.string(forKey: "glulabel2") {
            bp = session5
        }
        
        let firstActivityItem = "Health Measurements \n\n Symptoms: \n\(symptoms) \n Glucose Levels: \n\(glucose) \n\n Blood Pressure: \n\(bp) \n\n Weight: \n\(weight)"
       
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func clear(_ sender: Any) {
        
        
        let refreshAlert = UIAlertController(title: "Warning", message: "Are you sure you would like to clear your past vital data? Data cannot be recovered.", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.view.tintColor = UIColor.red
        
        refreshAlert.addAction(UIAlertAction(title: "Ok, clear my data.", style: .default, handler: { (action: UIAlertAction!) in
            self.defaults.set("", forKey: "symplabel")
            self.defaults.set("", forKey: "glulabel3")
            self.defaults.set("", forKey: "welabel")
            self.defaults.set("", forKey: "glulabel2")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
      
    }
  
    func edited() {
        if (tfw.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            plus.isEnabled = true
            minus.isEnabled = true
        }
        else{
            plus.isEnabled = false
            minus.isEnabled = false
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
