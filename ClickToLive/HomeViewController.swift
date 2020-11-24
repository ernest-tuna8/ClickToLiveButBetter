//
//  HomeViewController.swift
//  clickToLive
//
//  Created by Brian Seaver on 3/26/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
var highestLevel = 0
    var selectedLevel = 1
 
   
    @IBOutlet var levelsOutlet: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home view did load")
        let userDefault = UserDefaults.standard
              if userDefault.integer(forKey: "level") != 0{
                  highestLevel = userDefault.integer(forKey: "level")
              }
              else{
                highestLevel = 1
        }
        setUpLevels()

        // Do any additional setup after loading the view.
    }
    func setUpLevels(){
        print(highestLevel)
        for i in 0...levelsOutlet.count - 1{
            let title = levelsOutlet[i].titleLabel!
            let num = Int(String(title.text!.last!))!
            
            if num <= highestLevel{
                levelsOutlet[i].isEnabled = true
                        levelsOutlet[i].setTitleColor(UIColor.white, for: .normal)
                //levelsOutlet[i].backgroundColor = UIColor.green

            }
                    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    @IBAction func levelAction(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "Level 1":
           selectedLevel = 1
         case "Level 2":
              selectedLevel = 2
            case "Level 3":
                      selectedLevel = 3
            case "Level 4":
              selectedLevel = 4
            case "Level 5":
                 selectedLevel = 5
               case "Level 6":
                         selectedLevel = 6
            case "Level 7":
                         selectedLevel = 7
                       case "Level 8":
                            selectedLevel = 8
                          case "Level 9":
                                    selectedLevel = 9
        default:
            selectedLevel = 1
        }
        performSegue(withIdentifier: "playSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue"{
            let nvc = segue.destination as! ViewController
            nvc.level = selectedLevel
            nvc.highestLevel = highestLevel
           }
    }

}
