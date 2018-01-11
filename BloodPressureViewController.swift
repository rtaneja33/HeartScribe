//
//  GlucoseViewController.swift
//  ThirdPractice
//
//  Created by Rohan Taneja on 3/25/17.
//  Copyright © 2017 Rohan Taneja. All rights reserved.
//

import UIKit


class BloodPressureViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dminus: UIButton!
    @IBOutlet weak var tfdia: UITextField!
    @IBOutlet weak var dialabel: UILabel!
    @IBOutlet weak var dplus: UIButton!
    @IBOutlet weak var scrollvi: UIScrollView!
    @IBOutlet weak var tfblo: UITextField!
    @IBOutlet weak var showb: UIButton!
    private let defaults = UserDefaults.standard
    var hidden:Int = 0
    var cur:Int = 0
    let limitLength:Int = 3
    @IBOutlet weak var blabelp: UILabel!
    
    @IBOutlet weak var minusbp: UIButton!
    @IBOutlet weak var plusbp: UIButton!
    @IBOutlet weak var homebutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        plusbp.isEnabled = false
        minusbp.isEnabled = false
        dplus.isEnabled = false
        dminus.isEnabled = false
        hidden = 0
    
//        UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 130))
//        self.plusbp.frame.height = GlucoseViewController.plusbp.frame.height
////        let view = UIView(frame: self.plusbp.frame)
////
////         var frmPlay : CGRect = self.plusbp.frame
        self.tfblo.adjustsFontSizeToFitWidth = true
        tfblo.adjustsFontSizeToFitWidth = true
        self.tfblo.keyboardType = UIKeyboardType.decimalPad
        self.tfblo.adjustsFontSizeToFitWidth = true
        self.tfdia.adjustsFontSizeToFitWidth = true
        tfdia.adjustsFontSizeToFitWidth = true
        self.tfdia.keyboardType = UIKeyboardType.decimalPad
        self.tfdia.adjustsFontSizeToFitWidth = true

        if let session = defaults.string(forKey: "glulabel2") {
            blabelp.text = session
        }
        self.tfblo.minimumFontSize = 20.0
         self.tfdia.minimumFontSize = 20.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        tfblo.delegate = self
        tfblo.addTarget(self, action:"edited", for:UIControlEvents.editingChanged)
        
        tfblo.rightViewMode = UITextFieldViewMode.always
        tfdia.delegate = self
        tfdia.addTarget(self, action:"edited2", for:UIControlEvents.editingChanged)
        
        tfdia.rightViewMode = UITextFieldViewMode.always

        
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Blood Pressure"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomeR"), style: .plain, target: self, action: #selector(back))
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1.0/255.0, green: 207.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        
        
        self.navigationController?.navigationBar.frame.origin.y = 60
        scrollvi.addSubview(tfblo)
    scrollvi.addSubview(tfdia)}
    
    
    func back(){
        self.navigationController?.popViewController(animated:true)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        view.endEditing(true)
        plusbp.isEnabled = false
        minusbp.isEnabled = false
        dplus.isEnabled = false
        dminus.isEnabled = false
        
        if (tfblo.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            if (tfdia.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
            {
            let date = Date()
            let formatter = DateFormatter()
            //let calendar = Calendar.current
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            let result = formatter.string(from: date)
            
            blabelp.text = " \(result) \(tfblo.text!)/\(tfdia.text!)  mmHg \n\n\(blabelp.text!)"
            tfblo.text = ""
                tfdia.text = ""
            }
            else
            {
                let alertController = UIAlertController(title: "Warning", message:
                    "Please enter your Diastolic Blood Pressure.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                tfblo.text = ""
                tfdia.text = ""
            }

        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message:
                "Please enter your Systolic Blood Pressure.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            tfblo.text = ""
            tfdia.text = ""
        }
        
      
        defaults.set(blabelp.text, forKey: "glulabel2")
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showhis(_ sender: Any) {
        if hidden == 0
        {
            showb.setImage(UIImage(named: "history"), for: .normal)
            blabelp.isHidden = true
            hidden = 1
        }
        else
        {
            showb.setImage(UIImage(named: "hidehis"), for: .normal)
            blabelp.isHidden = false
            hidden = 0
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength // Bool
    }
       @IBAction func add(_ sender: Any) {
        if (tfblo.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfblo.text!)!;
            self.tfblo.text = String(cur + 1);
        }
    }
    @IBAction func subtract(_ sender: Any) {
        if (tfblo.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfblo.text!)!;
            self.tfblo.text = String(cur - 1);
        }
    }
    @IBAction func add2(_ sender: Any) {
        if (tfdia.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfdia.text!)!;
            self.tfdia.text = String(cur + 1);
        }
    }
    @IBAction func subtract2(_ sender: Any) {
        if (tfdia.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfdia.text!)!;
            self.tfdia.text = String(cur - 1);
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
    func edited2() {
        if (tfdia.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            dplus.isEnabled = true
            dminus.isEnabled = true
        }
        else{
            dplus.isEnabled = false
            dminus.isEnabled = false
        }
    }

    func edited() {
        if (tfblo.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            plusbp.isEnabled = true
            minusbp.isEnabled = true
        }
        else{
            plusbp.isEnabled = false
            minusbp.isEnabled = false
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
