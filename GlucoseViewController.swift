//
//  GlucoseViewController.swift
//  ThirdPractice
//
//  Created by Rohan Taneja on 3/25/17.
//  Copyright © 2017 Rohan Taneja. All rights reserved.
//

import UIKit

class GlucoseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollvi: UIScrollView!
    @IBOutlet weak var tfgluc: UITextField!
    @IBOutlet weak var showb: UIButton!
    private let defaults = UserDefaults.standard
    var hidden:Int = 0
    var cur:Int = 0
    let limitLength:Int = 3
        @IBOutlet weak var glabel: UILabel!
    
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var homebutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        plus.isEnabled = false
        minus.isEnabled = false
        hidden = 0
        self.tfgluc.adjustsFontSizeToFitWidth = true
        tfgluc.adjustsFontSizeToFitWidth = true
        self.tfgluc.keyboardType = UIKeyboardType.decimalPad
        self.tfgluc.adjustsFontSizeToFitWidth = true
        if let session = defaults.string(forKey: "glulabel3") {
            glabel.text = session
        }
        self.tfgluc.minimumFontSize = 20.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        tfgluc.delegate = self
        tfgluc.addTarget(self, action:"edited", for:UIControlEvents.editingChanged)
        
        tfgluc.rightViewMode = UITextFieldViewMode.always
        
                     self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Glucose"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomeR"), style: .plain, target: self, action: #selector(back))
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 122.0/255.0, green: 215.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        
        
        self.navigationController?.navigationBar.frame.origin.y = 60
        scrollvi.addSubview(tfgluc)    }
    
  
        func back(){
        self.navigationController?.popViewController(animated:true)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        view.endEditing(true)
        plus.isEnabled = false
        minus.isEnabled = false
        
        if (tfgluc.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            let date = Date()
            let formatter = DateFormatter()
            //let calendar = Calendar.current
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            let result = formatter.string(from: date)
            
            glabel.text = " \(result) \(tfgluc.text!) mg/dL \n\n\(glabel.text!)"
            tfgluc.text = ""
        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message:
                "Please enter your glucose level.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            tfgluc.text = ""
        }
        defaults.set(glabel.text, forKey: "glulabel3")
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showhis(_ sender: Any) {
        if hidden == 0
        {
            showb.setImage(UIImage(named: "history"), for: .normal)
            glabel.isHidden = true
            hidden = 1
        }
        else
        {
            showb.setImage(UIImage(named: "hidehis"), for: .normal)
            glabel.isHidden = false
            hidden = 0
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = tfgluc.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength // Bool
    }
    @IBAction func add(_ sender: Any) {
        if (tfgluc.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
        cur = Int(tfgluc.text!)!;
        self.tfgluc.text = String(cur + 1);
        }
    }
    @IBAction func subtract(_ sender: Any) {
        if (tfgluc.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            cur = Int(tfgluc.text!)!;
            self.tfgluc.text = String(cur - 1);
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
    func edited() {
        if (tfgluc.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
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
