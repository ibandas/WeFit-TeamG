//
//  NewChallengeViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/3/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit




class NewChallengeViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
  
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    @IBOutlet weak var metricPicker: UIPickerView!
    
    var exercisePickerData: [String] = [String]()
    var metricPickerData: [String] = [String]()
    
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberofRows = 1
        switch pickerView {
        case exercisePicker:
            numberofRows = exercisePickerData.count
        case metricPicker:
            numberofRows = metricPickerData.count
        default:
            print("something is wrong")
        }
        return numberofRows
    }
    
     // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data = ""
        switch pickerView {
            case exercisePicker:
                data = exercisePickerData[row]
            case metricPicker:
                data = metricPickerData[row]
            default:
                print("something is wrong")
        }
        return data
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        
        switch pickerView {
            case exercisePicker:
                attributedString = NSAttributedString(string: exercisePickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            case metricPicker:
                attributedString = NSAttributedString(string: metricPickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            default:
                print("something is wrong")
            }
            return attributedString
        
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exercisePicker.delegate = self
        self.exercisePicker.dataSource = self
        
        self.metricPicker.delegate = self
        self.metricPicker.dataSource = self
        
        exercisePickerData = ["Squats", "Bench Press", "Pushups", "Run", "Other"]
        
        metricPickerData = ["Reps", "Miles", "Kilometer", "Pounds", "Kilograms"]
        
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.customBlue.cgColor, UIColor.customGreen.cgColor]
        newLayer.frame = view.frame
        
        view.layer.insertSublayer(newLayer, at: 0)
    }
    
    
    

}
