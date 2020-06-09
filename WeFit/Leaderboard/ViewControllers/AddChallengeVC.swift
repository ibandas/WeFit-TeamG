//
//  AddChallengeViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/15/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit
import Firebase

class AddChallengeVC: UIViewController {

    
    
    @IBOutlet weak var challengeTitle: UITextField!
    @IBOutlet weak var metricDrop: UIButton!
    @IBOutlet weak var metricTblView: UITableView!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    var start_date = Date()
    var end_date = Date()
    

    @IBAction func startDatePickerChanged(_ sender: Any) {
        start_date = startDate.date
    }
    
    @IBAction func endDatePickerChanged(_ sender: Any) {
        end_date = endDate.date
    }
    
    let toolBar = UIToolbar()
    var chosenExercises: [ChallengeExercise] = []
    var metricList = ["Reps"]
    var challenge: Challenge = Challenge()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Done Toolbar
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: false)
        
        self.challengeTitle.inputAccessoryView = self.toolBar
        
        
        metricTblView.isHidden = true
        
        //STYLING
        let newLayer = CAGradientLayer()
               newLayer.colors = [UIColor.customBlue.cgColor, UIColor.customGreen.cgColor]
               newLayer.frame = view.frame
               
               view.layer.insertSublayer(newLayer, at: 0)
        
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.borderWidth = 1.5
        
        startDate.datePickerMode = UIDatePicker.Mode.date
        endDate.datePickerMode = UIDatePicker.Mode.date
        startDate.setValue(UIColor.white, forKeyPath: "textColor")
        endDate.setValue(UIColor.white, forKeyPath: "textColor")
        self.metricTblView.delegate = self
        self.metricTblView.dataSource = self
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func unwindFromChallengeExerciseVC(_ sender: UIStoryboardSegue) {
        if sender.source is ChallengeExerciseVC {
            if let senderVC = sender.source as? ChallengeExerciseVC {
                self.chosenExercises = senderVC.chosenExercises
                print(self.chosenExercises)
            }
        }
    }
    

    @IBAction func onClickMetric(_ sender: Any) {
        if metricTblView.isHidden{
            animate(toggle: true, type: metricDrop)
        } else{
            animate(toggle: false, type: metricDrop)
        }
    }
    
    
    func animate(toggle: Bool, type: UIButton){
       if toggle {
           UIView.animate(withDuration: 0.3) {
               self.metricTblView.isHidden = false
           }
       } else {
            UIView.animate(withDuration: 0.3) {
                self.metricTblView.isHidden = true
            }
       }
   }
}


extension AddChallengeVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(metricList.count)
        return metricList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metriccell", for: indexPath) as! MetricCell
        cell.setTitle(title: metricList[indexPath.row])
//        cell.textLabel?.text = metricList[indexPath.row]
//        print(metricList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        metricDrop.setTitle("\(metricList[indexPath.row])", for: .normal)
        animate(toggle: false, type: metricDrop)
    }
}

extension UIColor {

    class var customBlue: UIColor {
        let lightBlue = 0x76B3D2
        return UIColor.rgb(fromHex: lightBlue)
    }
    
    class var customGreen: UIColor {
           let lightGreen = 0x66B186
           return UIColor.rgb(fromHex: lightGreen)
       }

    class func rgb(fromHex: Int) -> UIColor {

        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
