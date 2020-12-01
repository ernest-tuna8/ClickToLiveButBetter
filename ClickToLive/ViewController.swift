//
//  ViewController.swift
//  clickToLive
//
//  Created by Brian Seaver on 3/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import AVFoundation

enum Category{
    
}

struct Scenario{
    var description: String
    var goodEffect: String
    var badEffect: String
    var goodAmount: Float
    var badAmount: Float
    var probability : Float
    var yes: String
    var yesYes: String
    var no: String
    
    
    
    
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    // variable for view did load happening once
    var first = true
 
    // variables for how many upgrades they have
    var doubleClick : CGFloat = 1.0
    var nationHealthDecrease : CGFloat = 0.0
    var happinessIncrease : CGFloat = 0.0
    var rationIncrease : CGFloat = 0.0
    
    var foodAlerts: [UIAlertController] = []
    var foodGroupPercents: [FoodGroup: Float] = [:]
    
    var sound : AVAudioPlayer?
    var timer : Timer?
    
    // Graph Variables
    @IBOutlet weak var graphView: UIView!
    var path = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    var x: CGFloat = 0.0
    var y : CGFloat = 1000.0
    var percent: CGFloat = 0.0
     var height: CGFloat = 0.0
    
    //Button Outlets
    @IBOutlet weak var nextDayOutlet: UIButton!
    @IBOutlet weak var storeOutlet: UIButton!
    @IBOutlet weak var coronaButton: UIButton!
    
    var nationHealthRate : CGFloat = 1.0
    @IBOutlet weak var growthRateOutlet: UILabel!
    
    var level = 1
    var highestLevel = 1
    @IBOutlet weak var levelOutlet: UILabel!
    
    // Growth Rate Outlet
     @IBOutlet weak var nationPercentOutlet: UILabel!
    
    // Outlet for Red Hospital Threshold Line
    @IBOutlet weak var hospitalCapacityOutlet: UILabel!
    
    var day = 0
    @IBOutlet weak var dayLabel: UILabel!
    
    var money :Int =  0
    @IBOutlet weak var moneyLabel: UILabel!
    
    var hoursPassed = 0
    @IBOutlet weak var hoursPassedLabel: UILabel!
    
    @IBOutlet weak var familyHealthOutlet: UIStackView!// not needed
   
    // Variables and Outlets for Needs
    var min : Float = 0.5
    
    var dailyFood : Float =  0.0
    var foodChange : Float = 0.0
    @IBOutlet weak var foodPercentLabel: UILabel!
    @IBOutlet weak var foodChangeLabelOutlet: UILabel!
    
    var dailyFamily : Float =  0.0
    var familyChange : Float = 0.0
    @IBOutlet weak var familyPercentLabel: UILabel!
    @IBOutlet weak var familyChangeLabelOutlet: UILabel!
    
    var dailyHappiness : Float =  0.0
    var happyChange : Float = 0.0
    @IBOutlet weak var happinessPercentLabel: UILabel!
    @IBOutlet weak var happinessChangeLabelOutlet: UILabel!
    
    var dailyTp : Float =  0.0
    var tpChange : Float = 0.0
    @IBOutlet weak var tpPercentLabel: UILabel!
    @IBOutlet weak var tpChangeLabelOutlet: UILabel!
    
    // Progress Bar Outlets
       @IBOutlet weak var healthProgressOutlet: UIProgressView!
       
       @IBOutlet weak var foodProgressOutlet: UIProgressView!
       @IBOutlet weak var happinessProgressOutlet: UIProgressView!
       @IBOutlet weak var tpProgressOutlet: UIProgressView!
    
    // Add Variables
    var familyHealthAdd : Float = 0.001
    var nationHealthAdd : Float = 0.0001
    var foodAdd : Float = 0.005
    var happinessAdd: Float = 0.000
    var toiletPaperAdd: Float = 0.004
        
    var dailyNation : Float = 0.0
    var nationChange : Float = 0.0
    
    var scenarios : [Scenario] = []
    
    func buildScenarios()
    {
        scenarios = [
            Scenario(description: "One of your kids is sick.  Go to the Doctor?", goodEffect: "Family Health", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.99, yes: "Your family health has improved!", yesYes: "However, you got others sick when you went to the doctor. Nation Growth Rate will increase...", no: "Your family health will suffer...  However, you didn't spread your virus so you decreased the nation growth rate and helped flatten the curve!"),
            Scenario(description: "Grandma and Grandpa invite you over to play cards. Should you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.10, probability: 0.80, yes: "You increased your happiness by playing cards!", yesYes: "However, you were carrying the virus and got Grandma and Grandpa sick. They are now going to use hospital beds and the Nation Growth Rate will increase...", no:  "Not playing cards has hurt your happiness...  However, you didn't get your Grandma and Grandpa sick so the nation growth rate has decreased!"),
            Scenario(description: "Your friends invite you to play beach volleyball.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.10, probability: 0.50, yes: "You increased your happiness by going to the park!", yesYes: "However, the corona virus spread amoung your friends so the nation growth rate will increase...", no:  "Not playing volleyball has hurt your happiness...  However, you didn't spread the virus so the nation growth rate has decreased!"),
                  Scenario(description: "It's St. Patrick's Day!  Your friends are celebrating at the Park.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.20, probability: 0.70, yes: "You increased your happiness by going to the park!", yesYes: "However, you contracted the corona virus at the park and spread it to many others.  The nation growth rate will increase...", no:  "Not going to the park has hurt your happiness...  However, you didn't contribute in spreading the virus, so the nation growth rate has decreased and you helped flatten the curve!"),
                        Scenario(description: "You won free tickets to Italy!  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.20, probability: 0.95, yes: "You increased your happiness by going to Italy!", yesYes: "However, you contracted the virus and have spread it to many people.  Nation growth rate will increase...", no:  "Not going to Italy has hurt your happiness...  However, you didn't contribute to the spread of the virius.  Nation growth rate will decrease and you helped flatten the curve!"),
                                 Scenario(description: "Your friend just called you a wimp for staying quarantined.  You have a desire to go TP their house.  Do you go?", goodEffect: "Happiness", badEffect: "Toilet Paper", goodAmount: 0.1, badAmount: 0.1, probability: 1.0, yes: "You increased your happiness by TP-ing your friends house!", yesYes: "However,  you lost a bunch of toilet paper.  Toilet Paper stock has suffered...", no:  "Not TP-ing your friends house has hurt your happiness...  However, you maintained your toilet paper stock!"),
                                          Scenario(description: "The blood bank needs blood.  Do you go give blood?", goodEffect: "Nation Health", badEffect: "Family Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.1, yes: "You improved the nation health by giving blood and the nation growth rate will decrease", yesYes: "However, you somehow contracted the virus.  Family health will suffer...", no:  "Not giving blood has hurt the nation's health and the nation growth rate will increase... However, you kept your family from the virus.  Family health has improved!"),
                                                   Scenario(description: "A local food shelter needs volunteers to help hand out food.  Do you go?", goodEffect: "Nation Health", badEffect: "Family Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.2, yes: "By volunteering at the food shelter you helped lower the nation growth rate and you helped flatten the curve!", yesYes: "However, you somehow contracted the virus.  Family health will suffer...", no:  "Not helping out at the shelter has increased the nation growth rate...  However, you kept your family from the virus.  Family health has improved!"),
                                                             Scenario(description: "You have plans to fly to Florida for spring break.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.2, badAmount: 0.15, probability: 0.7, yes: "You increased your happiness by going on Spring Break!", yesYes: "However, you contracted the virus and have spread it to many people.  Nation growth rate will increase...", no:  "Not going on spring break has hurt your happiness...  However, you helped not spread the virus.  Nation growth rate has decreased and you helped flatten the curve!"),
                                                                      Scenario(description: "You really only get a good workout at the gym.  Do you go?", goodEffect: "Family Health", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.5, yes: "You increased your family health by getting a good workout in! ", yesYes: "However, you were an asymptomatic carrier of the virus and spread it to many others.  Nation growth rate will increase", no:  "Not going to the gym has hurt your family heath.  However, you also didn't contribute to spreading the virus.  Nation growth rate will decrease and you helped flatten the curve!"),
                                                                       Scenario(description: "You haven't seen your friends in a long time and they are going to meet at the park.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.5, yes: "You increased your happiness by going to the park!", yesYes: "However, you were carrying the virus and got others sick.  Nation growth rate will increase...", no:  "Not going to the park has hurt your happiness...  However, the virus does not have a chance to spread.  Nation growth rate will decrease and you helped flatten the curve!"),
                                                                       Scenario(description: "You are sick of being in the house with your family!  A neighbor is having a backyard party.  Do you go?", goodEffect: "Happiness", badEffect: "Family Health", goodAmount: 0.15, badAmount: 0.2, probability: 0.3, yes: "You increased your happiness by going to the party!", yesYes: "However, you contracted the virus.  Family health will suffer...", no:  "Not going shopping has hurt your happiness...  However, you have no chance of getting the virus, so your family health has improved!"),
                                                                       Scenario(description: "Someone shows up to your house asking for toilet paper.  Do you give them some (5%)?", goodEffect: "Nation Health", badEffect: "Toilet Paper", goodAmount: 0.02 , badAmount: 0.05, probability: 1.0, yes: "By helping others, you decreased the nation growth rate and helped flatten the curve!", yesYes: "However, you lost 5% of your toilet paper...", no:  "Not helping out has increased the nation growth rate...  However, your toilet paper is sustained!"),
                                                                       Scenario(description: "You have had plans to go to Mardi Gras for 6 months.  Do you still go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.15 , badAmount: 0.20, probability: 0.9, yes: "You increased your happiness by going to Mardi Gras", yesYes: "However, you helped spread the virus.  Nation growth rate will increase...", no:  "Not going to Mardi Gras has hurt your happiness.  However, you didn't contribute to spreading the virus.  Nation growth rate will decrease and you helped flatten the curve!"),

            
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // print("View Did Appear")
        height = graphView.frame.height
        if first{
        randomStart()
        
            first = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ryan Atkinson made a change :)")
        // print("ViewController Did Load")
        self.navigationController?.delegate = self
       
        buildScenarios()
        
        storeOutlet.setTitleColor(UIColor.systemGray, for: .disabled)
        nextDayOutlet.setTitleColor(UIColor.systemGray, for: .disabled)
        storeOutlet.layer.cornerRadius = 10
        nextDayOutlet.layer.cornerRadius = 10
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       
        healthProgressOutlet.transform = healthProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
        foodProgressOutlet.transform = foodProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
       happinessProgressOutlet.transform = happinessProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
        tpProgressOutlet.transform = tpProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
            
        storeOutlet.isEnabled = false
       nextDayOutlet.isEnabled = true
        coronaButton.isEnabled = false
      
        resetDailyTotals()
        
        //randomStart()
        //drawCurve()
        
    }
    
    func updateLevel(){
        levelOutlet.text = "Level: \(level)"
    }
    
    func updateCapacity(){
        percent = (graphView.frame.height - y) / (graphView.frame.height - hospitalCapacityOutlet.frame.origin.y)*100.0
        nationPercentOutlet.text = "Hospital Capacity \(Int(percent))%"
    }
    
    func playSound(file f : String){
        let path = Bundle.main.path(forResource: f, ofType:nil)!
           let url = URL(fileURLWithPath: path)

           do {
               sound =  try AVAudioPlayer(contentsOf: url)
               sound?.play()
           } catch {
               print("can't play sound")
           }
        if f == "tickingClock.wav"{
            sound?.numberOfLoops = -1
        }
    }
    
    
    
    func drawCurve(){
        path.move(to: CGPoint(x: x,y: y))
        x+=1
        print("y before calculation \(y)")
        y = height - (height - y)*(1.0 + 1.0*nationHealthRate/24.0)
        print("graphview height: \(height)")
        
    
        print("difference: \(height - y)")
          print("y in draw curve \(y)")
        path.addLine(to: CGPoint(x: x ,y: y))
        
           shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
           shapeLayer.lineWidth = 3.0

        graphView.layer.addSublayer(shapeLayer)
        
        growthRateOutlet.text = "Growth Rate \(Int(nationHealthRate*100))%"
        percent = (graphView.frame.height - y) / (graphView.frame.height - hospitalCapacityOutlet.frame.origin.y)*100.0
        nationPercentOutlet.text = "Hospital Capacity \(Int(percent))%"
     
        
    }
    
    func randomStart(){
        
        var alert = UIAlertController(title: "Level \(level)", message: "", preferredStyle: .actionSheet)
        
        if alert.popoverPresentationController != nil {
            alert = UIAlertController(title: "Level \(level)", message: "", preferredStyle: .alert)
        }
         alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
       present(alert, animated: true, completion: nil)
    
        
        
        doubleClick = 1
        dailyFood = 0.005
        rationIncrease = 0.0
        happinessIncrease = 0
        nationHealthDecrease = 0
        buildScenarios()
    
        day = 0;
        money = 100 - 10 * level;
        hoursPassed = 0;
        dayLabel.text = "Day: \(day)"
        moneyLabel.text = "$\(money)"
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        
        path = UIBezierPath()
        x = 1.0
        y = height - (height * (0.01 + CGFloat(level)/100.0))
        //print("starting total height \(height)")
       // print("Starting y value \(y)")
        
        nationHealthRate = CGFloat(0.40 + 0.10 * Float(level))
        
        var minny = min - Float(level - 1) * 0.1
        if minny < 0.15 {
            minny = 0.15
        }
        let max = minny + 0.1
        tpProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        happinessProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
         foodProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        healthProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        
        timer?.invalidate()
        sound?.stop()
        
        resetDailyTotals()
        
        storeOutlet.isEnabled = false
        nextDayOutlet.isEnabled = true
        coronaButton.isEnabled = false
        
        let each = dailyFood/5.0
           foodGroupPercents = [FoodGroup.fruit: each, FoodGroup.vegetable: each, FoodGroup.grain: each, FoodGroup.protein: each, FoodGroup.dairy: each]
        
        drawCurve()
        updateAll()
    }
    

    
   func checkLose(){
   
    var loserMessage = "Something"
    if foodProgressOutlet.progress == 0{
        loserMessage = "You ran out of food"
    }
    else if healthProgressOutlet.progress == 0{
        loserMessage = "Your family health reached 0%"
    }
    else if happinessProgressOutlet.progress == 0{
        loserMessage = "Your happiness reached 0%"
    }
    else if tpProgressOutlet.progress == 0{
        loserMessage = "You ran out of toilet paper"
    }
    
        if foodProgressOutlet.progress == 0 ||  healthProgressOutlet.progress == 0 || happinessProgressOutlet.progress == 0 || tpProgressOutlet.progress == 0{
            timer?.invalidate()
            sound?.stop()
            var loseAlert = UIAlertController(title: "You Lose!", message: loserMessage, preferredStyle: .actionSheet)
            if loseAlert.popoverPresentationController != nil {
                loseAlert = UIAlertController(title: "You Lose!", message: loserMessage, preferredStyle: .alert)
            }
            
            loseAlert.view.backgroundColor = UIColor.red
            loseAlert.addAction(UIAlertAction(title: "play again", style: .default, handler: { (action) in
                self.randomStart()}))
            
          
            
            present(loseAlert, animated: true){
                self.timer?.invalidate()
                self.playSound(file: "bomb.wav")
            }
        }
    else if path.cgPath.currentPoint.y <= hospitalCapacityOutlet.frame.origin.y{
            timer?.invalidate()
            sound?.stop()
            var loseAlert = UIAlertController(title: "You Lose", message: "Nation Health has overwhelemed the hospitals!", preferredStyle: .actionSheet)
            if loseAlert.popoverPresentationController != nil {
                loseAlert = UIAlertController(title: "You Lose", message: "Nation Health has overwhelemed the hospitals!", preferredStyle: .alert)
            }
            loseAlert.view.backgroundColor = UIColor.red
            loseAlert.addAction(UIAlertAction(title: "play again", style: .default, handler: { (action) in
                self.randomStart()}))
            
            print("before popover")
            if let popoverController = loseAlert.popoverPresentationController {
                print("popover")
                popoverController.sourceView = nextDayOutlet.imageView
                popoverController.sourceRect = nextDayOutlet.bounds
                
            }
            
            present(loseAlert, animated: true){
                self.timer?.invalidate()
                self.playSound(file: "bomb.wav")
            }
        }
    }
    
    func displayScenario(){
        if scenarios.count > 0{
        var explanationAlert = UIAlertController()
        let choice = Int.random(in: 0 ... scenarios.count - 1)
        let scenario = scenarios[choice]
        var alert = UIAlertController(title: "\(scenario.goodEffect) Opportunity!" , message: scenario.description, preferredStyle: .actionSheet)
            if alert.popoverPresentationController != nil {
                alert = UIAlertController(title: "\(scenario.goodEffect) Opportunity!" , message: scenario.description, preferredStyle: .alert)
            }
      
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
            switch scenario.goodEffect{
            case "Family Health":
                self.healthProgressOutlet.progress += scenario.goodAmount
                self.familyPercentLabel.backgroundColor = UIColor.systemGreen
            case "Nation Health":
                //print("Nation Health better")
                self.nationHealthRate-=CGFloat(scenario.badAmount)

                case "Food":
                self.foodProgressOutlet.progress += scenario.goodAmount
                self.foodPercentLabel.backgroundColor = UIColor.systemGreen
                case "Happiness":
                self.happinessProgressOutlet.progress += scenario.goodAmount
            self.happinessPercentLabel.backgroundColor = UIColor.systemGreen
                case "Toilet Paper":
                   print("no gain of toilet paper")
//                self.tpProgressOutlet.progress += scenario.goodAmount
//                self.tpPercentLabel.backgroundColor = UIColor.systemGreen
            default:
                print("No good effect?")
            }
                
            if Float.random(in: 0...1.0) < scenario.probability{
                explanationAlert = UIAlertController(title: "UH-OH!", message: "\(scenario.yes)  \(scenario.yesYes)" , preferredStyle: .actionSheet)
                if explanationAlert.popoverPresentationController != nil {
                    explanationAlert = UIAlertController(title: "UH-OH!", message: "\(scenario.yes)  \(scenario.yesYes)" , preferredStyle: .alert)
                }
                explanationAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(alert) in
                    self.checkLose()
                    
                }))
        
                print("before popover")
                if let popoverController = explanationAlert.popoverPresentationController {
                    print("popover")
                    popoverController.sourceView = self.nextDayOutlet.imageView
                    popoverController.sourceRect = self.nextDayOutlet.bounds
                    
                }
                
                self.present(explanationAlert, animated: true){
                    self.updateAll()
                    
                    self.playSound(file: "gasp.wav")
                }
                
                switch scenario.badEffect{
                case "Family Health":
                    self.healthProgressOutlet.progress -= scenario.badAmount
                      self.familyPercentLabel.backgroundColor = UIColor.systemRed
                case "Nation Health":
                    self.nationHealthRate+=CGFloat(scenario.badAmount)
                    //print("nation health suffer")
//                    self.NationHealthProgressOutlet.progress -= scenario.badAmount
//                      self.nationPercentLabel.backgroundColor = UIColor.systemRed
                    case "Food":
                    self.foodProgressOutlet.progress -= scenario.badAmount
                      self.foodPercentLabel.backgroundColor = UIColor.systemRed
                    case "Happiness":
                    self.happinessProgressOutlet.progress -= scenario.badAmount
                      self.happinessPercentLabel.backgroundColor = UIColor.systemRed
                    case "Toilet Paper":
                    self.tpProgressOutlet.progress -= scenario.badAmount
                      self.tpPercentLabel.backgroundColor = UIColor.systemRed
                default:
                    print("No good effect?")
            }
            }
            else{
                explanationAlert = UIAlertController(title: "You Got Lucky!", message: "\(scenario.yes)" , preferredStyle: .actionSheet)
                if explanationAlert.popoverPresentationController != nil {
                    explanationAlert = UIAlertController(title: "You Got Lucky!", message: "\(scenario.yes)" , preferredStyle: .alert)
                }
                explanationAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                
                print("before popover")
                if let popoverController = explanationAlert.popoverPresentationController {
                    print("popover")
                    popoverController.sourceView = self.nextDayOutlet.imageView
                    popoverController.sourceRect = self.nextDayOutlet.bounds
                    
                }
                self.present(explanationAlert, animated: true){
                    self.playSound(file: "trumpet.wav")
                }
            }
            
                
            self.updateAll()
            //self.dismiss(animated: true, completion: nil)
            
            }))
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: { (aleret) in
            switch scenario.goodEffect{
            case "Family Health":
                self.healthProgressOutlet.progress -= scenario.goodAmount
                self.familyPercentLabel.backgroundColor = UIColor.systemRed
            case "Nation Health":
                self.nationHealthRate+=CGFloat(scenario.goodAmount)
                //print("nation health suffer")
//                self.NationHealthProgressOutlet.progress -= scenario.goodAmount
//                self.nationPercentLabel.backgroundColor = UIColor.systemRed
                case "Food":
                self.foodProgressOutlet.progress -= scenario.goodAmount
                self.foodPercentLabel.backgroundColor = UIColor.systemRed
                case "Happiness":
                self.happinessProgressOutlet.progress -= scenario.goodAmount
                self.happinessPercentLabel.backgroundColor = UIColor.systemRed
                case "Toilet Paper":
                self.tpProgressOutlet.progress -= scenario.goodAmount
            self.tpPercentLabel.backgroundColor = UIColor.systemRed
                
            default:
                print("No good effect?")
            }
            switch scenario.badEffect{
                        case "Family Health":
                            self.healthProgressOutlet.progress += scenario.badAmount
                            self.familyPercentLabel.backgroundColor = UIColor.systemGreen
                        case "Nation Health":
                            self.nationHealthRate-=CGFloat(scenario.badAmount)
                            //print("nation health suffer")
            //                self.NationHealthProgressOutlet.progress -= scenario.goodAmount
            //                self.nationPercentLabel.backgroundColor = UIColor.systemRed
                            case "Food":
                            self.foodProgressOutlet.progress += scenario.badAmount
                            self.foodPercentLabel.backgroundColor = UIColor.systemGreen
                            case "Happiness":
                            self.happinessProgressOutlet.progress += scenario.badAmount
                            self.happinessPercentLabel.backgroundColor = UIColor.systemGreen
                            case "Toilet Paper":
                             print("no toilet paper increase or decrease")
                            //self.tpProgressOutlet.progress += scenario.badAmount
                        //self.tpPercentLabel.backgroundColor = UIColor.systemRed
                        default:
                            print("No good effect?")
                        }
            explanationAlert = UIAlertController(title: "Good and Bad", message: "\(scenario.no)" , preferredStyle: .actionSheet)
            if explanationAlert.popoverPresentationController != nil {
                explanationAlert = UIAlertController(title: "Good and Bad", message: "\(scenario.no)" , preferredStyle: .alert)
            }
            
            explanationAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (alert) in
                self.checkLose()
            }))
            
            print("before popover")
            if let popoverController = explanationAlert.popoverPresentationController {
                print("popover")
                popoverController.sourceView = self.nextDayOutlet.imageView
                popoverController.sourceRect = self.nextDayOutlet.bounds
                
            }
            self.present(explanationAlert, animated: true){
                self.playSound(file: "trumpet.wav")
            }
            self.updateAll()
        }))
           
            print("before popover")
            if let popoverController = alert.popoverPresentationController {
                print("popover")
                popoverController.sourceView = nextDayOutlet.imageView
                popoverController.sourceRect = nextDayOutlet.bounds
                
            }
       
            present(alert, animated: true) {
                self.playSound(file: "doorbell.wav")
            }
           
        
        scenarios.remove(at: choice)
        }
        }
   
    
    func resetDailyTotals(){
        dailyHappiness = happinessProgressOutlet.progress
        dailyFood = foodProgressOutlet.progress
        dailyFamily = healthProgressOutlet.progress
        //dailyNation = NationHealthProgressOutlet.progress
        dailyTp = tpProgressOutlet.progress
        familyPercentLabel.backgroundColor = UIColor.black
        //nationPercentLabel.backgroundColor = UIColor.black
        foodPercentLabel.backgroundColor = UIColor.black
        tpPercentLabel.backgroundColor = UIColor.black
        happinessPercentLabel.backgroundColor = UIColor.black
    }
    
    func updateAll(){
        updateLevel()
        foodUpdate()
        updateFamilyHealth()
        happinessUpdate()
        tpUpdate()
        updateMoney()
        growthRateOutlet.text = "Growth Rate: \(Int(nationHealthRate*100))%"
        checkLose()
    }

    @IBAction func clickAction(_ sender: UIButton) {
        money+=Int(1.0*doubleClick)
        updateMoney()
      
    }
    
    func createFoodGroupAlert(message m: String)->UIAlertController{
        var foodAlert = UIAlertController(title: "You ran out of \(m)", message: "Family Health will suffer 3%", preferredStyle: .actionSheet)
        if foodAlert.popoverPresentationController != nil {
          foodAlert = UIAlertController(title: "You ran out of \(m)", message: "Family Health will suffer 3%", preferredStyle: .alert)
        }
        
       
        
        return foodAlert
    }
    
    func showErrors(){
        if let error = foodAlerts.first{
            error.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                       self.healthProgressOutlet.progress -= 0.03
                       self.updateAll()
                self.foodAlerts.remove(at: 0)
                self.showErrors()
                
                        
                   }))
            print("before popover")
            if let popoverController = error.popoverPresentationController {
                print("popover")
                popoverController.sourceView = nextDayOutlet.imageView
                popoverController.sourceRect = nextDayOutlet.bounds
                
            }
            
            present(error, animated: true, completion: nil)
        }
        else{
            displayScenario()
            //print("no more errors")
        }
        
    }
    
    func updateFoodGroups(){
        
        
        foodGroupPercents.forEach({ (key, value) -> Void in
                   
                   foodGroupPercents[key]! -= foodAdd*24/5
               })
        var numOut = 1
        while numOut != 0 {
        numOut = 0
        var totalNegative :Float = 0.0
        foodGroupPercents.forEach({ (key, value) -> Void in
            print("checking the values")
            if value < 0{
                print(value)
                numOut+=1
                totalNegative += -1.0*value
                foodGroupPercents[key]! = 0
                foodAlerts.append(self.createFoodGroupAlert(message: "\(key)"))
                
            }
        })
        let divisor = 5 - numOut
        foodGroupPercents.forEach({ (key, value) -> Void in
            let d = Float(divisor)
            if value > 0{
            foodGroupPercents[key]! -= totalNegative/d
            }
        })
        }

        showErrors()
          print(foodGroupPercents)
        }

    
    @objc func updateTimer(){
        //print("timer fired")
        //playSound(file: "tick.mp3")
        hoursPassed+=1
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        
        healthProgressOutlet.progress+=Float.random(in: -0.015...0.01)
        updateFamilyHealth()
        
          happinessProgressOutlet.progress+=Float.random(in: -0.015...0.01)
        
        
        happinessUpdate()
        
        foodProgressOutlet.progress-=foodAdd
        foodUpdate()
        
        tpProgressOutlet.progress-=toiletPaperAdd
        tpUpdate()
        
        drawCurve()
        checkLose()
        
        if hoursPassed == 23{
            if nationHealthRate <= 0.0 {
                sound?.stop()
                var winAlert = UIAlertController(title: "You Win Level \(level)", message: "You helped flatten the curve!", preferredStyle: .actionSheet)
                if winAlert.popoverPresentationController != nil {
                    winAlert = UIAlertController(title: "You Win Level \(level)", message: "You helped flatten the curve!", preferredStyle: .alert)
                }
                winAlert.view.backgroundColor = UIColor.yellow
                winAlert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: {(alert) in
                    
                    self.randomStart()
                }))
                
                print("before popover")
                if let popoverController = winAlert.popoverPresentationController {
                    print("popover")
                    popoverController.sourceView = nextDayOutlet.imageView
                    popoverController.sourceRect = nextDayOutlet.bounds
                    
                }
                
                present(winAlert, animated: true){
                    self.timer?.invalidate()
                    self.playSound(file: "applause.wav")
                    self.level+=1
                    if self.level > self.highestLevel{
                    self.highestLevel = self.level
                    }
                    let user = UserDefaults.standard
                    user.set(self.highestLevel, forKey: "level")
                }
            }
        }
        
        if(hoursPassed == 24){
            sound?.stop()
            timer?.invalidate()
            coronaButton.isEnabled = false
           
            nextDayOutlet.isEnabled = true
            storeOutlet.isEnabled = true
            //displayScenario()
            updateFoodGroups()
            
        }
      
    }
    
    func updateFamilyHealth(){
        
        var current = healthProgressOutlet.progress
     healthProgressOutlet.setProgress(healthProgressOutlet.progress, animated: true)
        
        familyChange = current - dailyFamily
                      if familyChange < 0.0{
                          familyChangeLabelOutlet.backgroundColor = UIColor.red
                      }
                      else{
                        familyChangeLabelOutlet.backgroundColor = UIColor.systemGreen
                      }
        
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
                      familyPercentLabel.text = "\(Int(current*100))%"
                      
                      familyChangeLabelOutlet.text = "\(Int(familyChange*100))%"
    
    }
    
    func foodUpdate(){
    foodProgressOutlet.setProgress(foodProgressOutlet.progress, animated: true)
        
        var current = foodProgressOutlet.progress
        foodChange = current - dailyFood
        if foodChange < 0.0{
            foodChangeLabelOutlet.backgroundColor = UIColor.red
        }
        else {

            foodChangeLabelOutlet.backgroundColor = UIColor.systemGreen
        }

        foodChangeLabelOutlet.text = "\(Int(foodChange*100))%"
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
        foodPercentLabel.text = "\(Int(current*100))%"
  
     }
    
    func happinessUpdate(){
        var current = happinessProgressOutlet.progress
        happinessProgressOutlet.setProgress(current, animated: true)
    
       happyChange = current - dailyHappiness
        if happyChange < 0.0{
            happinessChangeLabelOutlet.backgroundColor = UIColor.red
        }
        else{
            happinessChangeLabelOutlet.backgroundColor = UIColor.systemGreen
        }

        if current > 0 && current < 0.01{
            current = 0.01
            
        }
        happinessPercentLabel.text = "\(Int(current*100))%"
        
        happinessChangeLabelOutlet.text = "\(Int(happyChange*100))%"
      
    }
    
    func tpUpdate(){
        var current = tpProgressOutlet.progress
          tpProgressOutlet.setProgress(current, animated: true)
        
        tpChange = current - dailyTp
               if tpChange < 0.0{
                   tpChangeLabelOutlet.backgroundColor = UIColor.red
               }
               else{
                tpChangeLabelOutlet.backgroundColor = UIColor.systemGreen
               }

        if current > 0 && current < 0.01{
            current = 0.01
            
        }
               tpPercentLabel.text = "\(Int(current*100))%"
               
               tpChangeLabelOutlet.text = "\(Int(tpChange*100))%"
         
      }
    
    func updateMoney(){
             moneyLabel.text = "$\(money)"
    }
    
    func nextDay(){
        let user = UserDefaults.standard
        user.set(self.level, forKey: "level")
        
        storeOutlet.isEnabled = false
               nextDayOutlet.isEnabled = false
               resetDailyTotals()
               updateAll()
        print(foodGroupPercents)
    }
    
    @IBAction func nextDayAction(_ sender: UIButton) {
        foodAdd = foodAdd * pow(0.80, Float(rationIncrease))
        toiletPaperAdd = toiletPaperAdd * pow(0.80,Float(rationIncrease))
       
            nationHealthRate -= (0.05 * nationHealthDecrease)
        healthProgressOutlet.progress += Float(0.05 * (happinessIncrease + 1.0))
        
            growthRateOutlet.text = "Growth Rate \(Int(nationHealthRate*100))%"
       
            happinessProgressOutlet.progress += Float(0.05 * happinessIncrease)
        
        
        nextDay()
        hoursPassed = 0
        day+=1
        dayLabel.text = "Day: \(day)"
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        coronaButton.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        playSound(file: "timer.wav")
        
    }
   
    
    @IBAction func storeAction(_ sender: UIButton) {
        performSegue(withIdentifier: "storeSegue", sender: nil)
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let store = segue.destination as! StoreViewController
        store.cash = money
        store.food = self.foodProgressOutlet.progress
        store.tp = self.tpProgressOutlet.progress
        store.happiness = self.happinessProgressOutlet.progress
        store.nationHealth = self.nationHealthRate
        store.familyHealth = self.healthProgressOutlet.progress
        store.foodGroupPercents = foodGroupPercents
       store.doubleClick = doubleClick
        store.nationHealthDecrease = nationHealthDecrease
        store.happinessIncrease = happinessIncrease
        store.rationIncrease = rationIncrease
        
        store.level = level
      
        
    }
 
    
   func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let vc = viewController as? HomeViewController{
        vc.highestLevel = highestLevel
        print("level being sent over \(vc.highestLevel)")
        vc.setUpLevels()
    }
    }
    
    
  
    
}

