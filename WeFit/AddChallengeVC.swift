//
//  AddChallengeViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/15/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

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

class AddChallengeVC: UIViewController {

    
    @IBOutlet weak var exerciseDrop: UIButton!
    @IBOutlet weak var exerciseTblView: UITableView!
    @IBOutlet weak var metricDrop: UIButton!
    @IBOutlet weak var metricTblView: UITableView!

    @IBOutlet weak var submitButton: UIButton!
    
    var exerciseList = ["Squats", "Pushups", "Deadlift"]
    var metricList = ["Miles", "Kilometers", "Pounds", "Kilograms", "Reps"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTblView.isHidden = true
        metricTblView.isHidden = true
        
        let newLayer = CAGradientLayer()
               newLayer.colors = [UIColor.customBlue.cgColor, UIColor.customGreen.cgColor]
               newLayer.frame = view.frame
               
               view.layer.insertSublayer(newLayer, at: 0)
        submitButton.layer.borderColor = UIColor.white.cgColor
    }
    
    
    
    @IBAction func onClickExercise(_ sender: Any) {
        if exerciseTblView.isHidden{
            animate(toggle: true, type: exerciseDrop)
        } else{
            animate(toggle: false, type: exerciseDrop)
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
         if type == exerciseDrop {
               
               if toggle {
                   UIView.animate(withDuration: 0.3) {
                       self.exerciseTblView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.exerciseTblView.isHidden = true
                   }
               }
               } else {
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
}

extension AddChallengeVC: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberofRows = 1
        switch tableView {
            case exerciseTblView:
                numberofRows = exerciseList.count
            case metricTblView:
                numberofRows = metricList.count
            default:
                print("something is wrong")
        }
        return numberofRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case exerciseTblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisecell", for: indexPath)
            cell.textLabel?.text = exerciseList[indexPath.row]
            return cell
        case metricTblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "metriccell", for: indexPath)
            cell.textLabel?.text = metricList[indexPath.row]
            return cell
        default:
            print("something is wrong")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch tableView{
        case exerciseTblView:
            exerciseDrop.setTitle("\(exerciseList[indexPath.row])", for: .normal)
            animate(toggle: false, type: exerciseDrop)
        case metricTblView:
            metricDrop.setTitle("\(metricList[indexPath.row])", for: .normal)
            animate(toggle: false, type: metricDrop)
        default:
            print("something wrong")
        }
       
    }
}
