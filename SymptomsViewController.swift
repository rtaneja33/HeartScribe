//
//  SymptomsViewController.swift
//  ThirdPractice
//
//  Created by Rohan Taneja on 2/26/17.
//  Copyright © 2017 Rohan Taneja. All rights reserved.
//

import UIKit
import Speech

class SymptomsViewController: UIViewController, SFSpeechRecognizerDelegate, UITextFieldDelegate {
    @IBOutlet weak var blankl: UILabel!
    @IBOutlet weak var scrollvi: UIScrollView!
    @IBOutlet weak var tfsymp: UITextField!
    @IBOutlet weak var showb: UIButton!
     private let defaults = UserDefaults.standard
    var hidden:Int = 0
    var st:String = "HIIIIII"
            private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
   
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    let detailsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 130))
     //let showh = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
    @IBOutlet weak var slabel: UILabel!

    @IBOutlet weak var homebutton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.frame.origin.y = 40
        
        hidden = 0
        self.tfsymp.adjustsFontSizeToFitWidth = true
        if let session = defaults.string(forKey: "symplabel") {
            slabel.text = session
        }
        self.tfsymp.minimumFontSize = 20.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
               detailsButton.setImage(UIImage(named: "Microphone"), for: .normal)
         
        
        
         detailsButton.addTarget(self, action: #selector(mictap), for: .touchUpInside)
       
        tfsymp.rightViewMode = UITextFieldViewMode.always
        
        tfsymp.rightView = detailsButton
        
       

        detailsButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.detailsButton.isEnabled = isButtonEnabled
            }
        }
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Symptoms"
        let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"HomeR"), style: .plain, target: self, action: #selector(back))

        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 153.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
       
                scrollvi.addSubview(tfsymp)    }
   
   
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.tfsymp.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.detailsButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    func mictap(){
        if audioEngine.isRunning {
            audioEngine.stop()
            
            recognitionRequest?.endAudio()
            detailsButton.isEnabled = false
            detailsButton.setImage(UIImage(named: "Microphone"), for: .normal)
            tfsymp.clearButtonMode = UITextFieldViewMode.whileEditing
            tfsymp.rightViewMode = UITextFieldViewMode.unlessEditing

            
        } else {
            startRecording()
            
          
           detailsButton.setImage(UIImage(named: "rec1"), for: .normal)
          
        tfsymp.rightViewMode = UITextFieldViewMode.always
            
           
            
            
        }
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            detailsButton.isEnabled = true
        } else {
            detailsButton.isEnabled = false
        }
    }
    func back(){
        self.navigationController?.popViewController(animated:true)
        
    }
   
    @IBAction func save(_ sender: Any) {
        
            view.endEditing(true)
        
      
        if (tfsymp.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count)!>0
        {
        let date = Date()
        let formatter = DateFormatter()
        //let calendar = Calendar.current
        formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let result = formatter.string(from: date)
        
        slabel.text = " \(result) \(tfsymp.text!) \n\n\(slabel.text!)"
        tfsymp.text = ""
        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message:
                "Please enter a symptom.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            tfsymp.text = ""
        }
         defaults.set(slabel.text, forKey: "symplabel")
       
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func showhis(_ sender: Any) {
        if hidden == 0
        {
        showb.setImage(UIImage(named: "history"), for: .normal)
        blankl.isHidden = true
        hidden = 1
        }
        else
        {
         showb.setImage(UIImage(named: "hidehis"), for: .normal)
        blankl.isHidden = false
         hidden = 0
            
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.frame.origin.y = 40
    
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var DestViewController = segue.destination as! SendHealthDataViewController
//        DestViewController.LabelText = slabel.text!
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
