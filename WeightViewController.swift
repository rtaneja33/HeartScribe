//
//  GlucoseViewController.swift
//  ThirdPractice
//
//  Created by Rohan Taneja on 3/25/17.
//  Copyright © 2017 Rohan Taneja. All rights reserved.
//

import UIKit


class WeightViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var scrollvi: UIScrollView!
    @IBOutlet weak var tfw: UITextField!
    @IBOutlet weak var showb: UIButton!
    private let defaults = UserDefaults.standard
    var hidden:Int = 0
    var cur:Int = 0
    let limitLength:Int = 3
    @IBOutlet weak var wlabel: UILabel!
    
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var homebutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        plus.isEnabled = false
        minus.isEnabled = false
        hidden = 0
        scrollvi.setContentOffset(CGPoint(x: 1, y: -20), animated: true)
        self.tfw.adjustsFontSizeToFitWidth = true
        tfw.adjustsFontSizeToFitWidth = true
        self.tfw.keyboardType = UIKeyboardType.decimalPad
        self.tfw.adjustsFontSizeToFitWidth = true
        if let session = defaults.string(forKey: "weightlabel2") {
            wlabel.text = session
        }
        self.tfw.minimumFontSize = 20.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        tfw.delegate = self
        tfw.addTarget(self, action:"edited", for:UIControlEvents.editingChanged)
        
        tfw.rightViewMode = UITextFieldViewMode.always
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Weight"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomeR"), style: .plain, target: self, action: #selector(back))
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 173.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        
        self.navigationController?.navigationBar.frame.origin.y = 60
        scrollvi.addSubview(tfw)    }
    
    
    func back(){
        self.navigationController?.popViewController(animated:true)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        view.endEditing(true)
        plus.isEnabled = false
        minus.isEnabled = false
        
        if (tfw.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
            let date = Date()
            let formatter = DateFormatter()
            //let calendar = Calendar.current
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
            let result = formatter.string(from: date)
            
            wlabel.text = " \(result) \(tfw.text!) pounds \n\n\(wlabel.text!)"
            tfw.text = ""
        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message:
                "Please enter your weight.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            tfw.text = ""
        }
        defaults.set(wlabel.text, forKey: "weightlabel2")
        
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
