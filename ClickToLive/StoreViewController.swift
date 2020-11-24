//
//  StoreViewController.swift
//  clickToLive
//
//  Created by Brian Seaver on 3/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import AVFoundation

enum FoodGroup{
    case fruit, vegetable, grain, protein, dairy, junk, none
}

struct Item{
    var image : UIImage
    var title : String
    var category : String
    var increase : Float
    var price : Int
    var foodGroup: FoodGroup
    var available: Double

}

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate {
    
    var sound : AVAudioPlayer?
    
    var items : [Item] = []
 
    var foodGroupPercents: [FoodGroup: Float] = [:]
    var todaysFoodItems: [String : Int] = [:]
    
    @IBOutlet weak var fruitOutlet: UILabel!
    @IBOutlet weak var vegetableOutlet: UILabel!
    @IBOutlet weak var grainOutlet: UILabel!
    @IBOutlet weak var proteinOutlet: UILabel!
    @IBOutlet weak var dairyOutlet: UILabel!
    
    
    
    var level: Int = 1
    var cash: Int = 0
    var food: Float = 0
    var happiness: Float = 0
    var nationHealth: CGFloat = 0
    var familyHealth: Float = 0
    var tp: Float = 0
    var doubleClick: CGFloat = 1.0
    var nationHealthDecrease: CGFloat = 0.0
    var happinessIncrease: CGFloat = 0.0
    var rationIncrease: CGFloat = 0.0
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var moneyOutlet: UILabel!
    @IBOutlet weak var foodOutlet: UILabel!
    @IBOutlet weak var nationOutlet: UILabel!
    @IBOutlet weak var familyOutlet: UILabel!
    @IBOutlet weak var happinessOutlet: UILabel!
    @IBOutlet weak var tpOutlet: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("store View did load")
        addItems()
        tableViewOutlet.reloadData()
        
       
        self.navigationController?.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        moneyOutlet.text = "$\(cash)"
        foodOutlet.text = "Food: \(Int(food*100))%"
        nationOutlet.text = "Nation Growth: \(Int(nationHealth*100))%"
        familyOutlet.text = "Family Health: \(Int(familyHealth*100))%"
        happinessOutlet.text = "Happiness: \(Int(happiness*100))%"
        tpOutlet.text = "Toilet Paper: \(Int(tp*100))%"
        updateFoodGroupOutlets()

    }
    
    func playSound(file f: String){
    let path = Bundle.main.path(forResource: f, ofType:nil)!
    let url = URL(fileURLWithPath: path)

    do {
        sound =  try AVAudioPlayer(contentsOf: url)
        sound?.play()
    } catch {
        // couldn't load file :(
    }
    }
        
    func randAvail()-> Double{
        return Double.random(in: 0...1.0)
    }
    
    func addItems(){
       items =  [               // Upgrades
        Item(image: UIImage(named: "upArrow")!, title: "Clickerator", category:  "Upgrade", increase:  0.0, price: 100 + 20 * level,foodGroup: FoodGroup.none, available: 1.0),
        Item(image: UIImage(named: "upArrow")!, title: "Flattenator", category:  "Upgrade", increase:  0.0, price: 60 + 20 * level,foodGroup: FoodGroup.none, available: 1.0),
         Item(image: UIImage(named: "upArrow")!, title: "Rationator", category:  "Upgrade", increase:  0.00, price: 50 + 10 * level ,foodGroup: FoodGroup.none, available: 1.0),
        Item(image: UIImage(named: "upArrow")!, title: "Happinator", category:  "Upgrade", increase:  0.00, price: 30 + 10 * level ,foodGroup: FoodGroup.none, available: 1.0),
       
        
        
                                // Fruits 3...32
            
                               Item(image: UIImage(named: "shoppingCart")!, title: "Bananas", category:  "Food", increase:  0.01, price: 3,foodGroup: FoodGroup.fruit, available: randAvail()),
                                Item(image: UIImage(named: "shoppingCart")!, title: "Rasberries", category:  "Food", increase:  0.01, price: 3 ,foodGroup: FoodGroup.fruit, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Blueberries", category:  "Food", increase:  0.01, price: 3,foodGroup: FoodGroup.fruit, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Apples", category:  "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.fruit, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Oranges", category:  "Food", increase:  0.02, price: 6,foodGroup: FoodGroup.fruit, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Pears", category:  "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.fruit, available: randAvail()),
                                 
                                 // Vegetables
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Carrots", category: "Food", increase: 0.01, price: 2, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Lettuce", category: "Food", increase: 0.01, price: 2, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Broccoli", category: "Food", increase: 0.01, price: 2, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Peas", category: "Food", increase: 0.01, price: 2, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Corn", category: "Food", increase: 0.01, price: 2, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Peppers", category: "Food", increase: 0.02, price: 4, foodGroup: FoodGroup.vegetable, available: randAvail()),
                                 Item(image: UIImage(named: "shoppingCart")!, title: "Cucumbers", category: "Food", increase: 0.02, price: 4, foodGroup: FoodGroup.vegetable, available: randAvail()),

                                 // Grain

                                  Item(image: UIImage(named: "shoppingCart")!, title: "Pasta", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.grain, available: randAvail()),
                                  Item(image: UIImage(named: "shoppingCart")!, title: "Rice", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.grain, available: randAvail()),
                                  Item(image: UIImage(named: "shoppingCart")!, title: "Bagels", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.grain, available: randAvail()),
                                  Item(image: UIImage(named: "shoppingCart")!, title: "Cereal", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.grain, available: randAvail()),
                                  Item(image: UIImage(named: "shoppingCart")!, title: "Bread", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.grain, available: randAvail()),

                                 // Protein
        Item(image: UIImage(named: "shoppingCart")!, title: "Eggs", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.protein, available: randAvail()),
        Item(image: UIImage(named: "shoppingCart")!, title: "Ground Beef", category: "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.protein, available: randAvail()),
                                Item(image: UIImage(named: "shoppingCart")!, title: "Chicken", category: "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.protein, available: randAvail()),
                                Item(image: UIImage(named: "shoppingCart")!, title: "Fish", category: "Food", increase:  0.04, price: 12, foodGroup: FoodGroup.protein, available: randAvail()),
                                Item(image: UIImage(named: "shoppingCart")!, title: "Steak", category: "Food", increase:  0.04, price: 12, foodGroup: FoodGroup.protein, available: randAvail()),




                            // Dairy
                            Item(image: UIImage(named: "shoppingCart")!, title: "Milk", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.dairy, available: randAvail()),
                            Item(image: UIImage(named: "shoppingCart")!, title: "Cheese", category: "Food", increase:  0.01, price: 3, foodGroup: FoodGroup.dairy, available: randAvail()),
                            Item(image: UIImage(named: "shoppingCart")!, title: "Yogurt", category: "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.dairy, available: randAvail()),
                            Item(image: UIImage(named: "shoppingCart")!, title: "Ice Cream", category: "Food", increase:  0.02, price: 6, foodGroup: FoodGroup.dairy, available: randAvail()),

                            
                            // Junk
                              Item(image: UIImage(named: "shoppingCart")!, title: "Candy Bars", category: "Food",increase:  0.01, price: 3, foodGroup: FoodGroup.junk, available: randAvail()),
                              Item(image: UIImage(named: "shoppingCart")!, title: "Frozen Pizza", category: "Food",increase:  0.02, price: 4, foodGroup: FoodGroup.junk, available: randAvail()),
                              Item(image: UIImage(named: "shoppingCart")!, title: "Bag of Chips", category: "Food", increase: 0.02, price: 6, foodGroup: FoodGroup.junk, available: randAvail()),
                              Item(image: UIImage(named: "shoppingCart")!, title: "Box of Oreos", category:  "Food", increase: 0.02, price: 6, foodGroup: FoodGroup.junk, available: randAvail()),

                               // Happiness
                               Item(image: UIImage(named: "happinessIcon")!, title: "Rent a Movie", category: "Happiness", increase: 0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "happinessIcon")!, title: "Rubik's Cube", category: "Happiness", increase:  0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "happinessIcon")!, title: "Uno", category: "Happiness", increase:  0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "happinessIcon")!, title: "Deck of Cards", category: "Happiness", increase:  0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "happinessIcon")!, title: "Nerf Guns", category: "Happiness", increase:  0.03, price: 7, foodGroup: FoodGroup.none, available: randAvail()),
                                Item(image: UIImage(named: "happinessIcon")!, title: "Art Suppplies", category: "Happiness", increase:  0.03, price: 7, foodGroup: FoodGroup.none, available: randAvail()),
                                 Item(image: UIImage(named: "happinessIcon")!, title: "Jigsaw Puzzle", category: "Happiness", increase:  0.03, price: 7, foodGroup: FoodGroup.none, available: randAvail()),
                                 Item(image: UIImage(named: "happinessIcon")!, title: "Nerf Hoop", category: "Happiness", increase:  0.04, price: 10, foodGroup: FoodGroup.none, available: randAvail()),
                                 Item(image: UIImage(named: "happinessIcon")!, title: "Football", category: "Happiness", increase:  0.04, price: 10, foodGroup: FoodGroup.none, available: randAvail()),
                                 Item(image: UIImage(named: "happinessIcon")!, title: "Basketball", category: "Happiness", increase:  0.04, price: 10, foodGroup: FoodGroup.none, available: randAvail()),
                                 Item(image: UIImage(named: "happinessIcon")!, title: "Risk Game", category: "Happiness", increase:  0.08, price: 20, foodGroup: FoodGroup.none, available: randAvail()),

                              Item(image: UIImage(named: "happinessIcon")!, title: "Monopoly", category: "Happiness", increase:  0.08, price: 20, foodGroup: FoodGroup.none, available: randAvail()),
                              Item(image: UIImage(named: "happinessIcon")!, title: "Catan", category: "Happiness", increase:  0.08, price: 20, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "happinessIcon")!, title: "WII", category: "Happiness",increase:  0.40, price: 100, foodGroup: FoodGroup.none, available: randAvail()),
                                Item(image: UIImage(named: "happinessIcon")!, title: "XBox", category: "Happiness",increase:  0.80, price: 200, foodGroup: FoodGroup.none, available: randAvail()),
                                Item(image: UIImage(named: "happinessIcon")!, title: "PlayStation", category: "Happiness",increase:  0.80, price: 200, foodGroup: FoodGroup.none, available: randAvail()),

                                // Toilet Paper
                                Item(image: UIImage(named: "tpIcon")!, title: "1 Pack of Toilet Paper", category:  "Toilet Paper", increase: 0.01, price: 1, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "tpIcon")!, title: "8 Pack of Toilet Paper", category:  "Toilet Paper", increase: 0.08, price: 4, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "tpIcon")!, title: "12 Pack of Toilet Paper", category:  "Toilet Paper", increase: 0.16, price: 6, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "tpIcon")!, title: "24 Pack of Toilet Paper", category:  "Toilet Paper", increase: 0.24, price: 10, foodGroup: FoodGroup.none, available: randAvail()),

                                // Family Health
                               Item(image: UIImage(named: "familyIcon")!, title: "Hand Sanitizer", category: "Family Health", increase:  0.01, price: 3, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "familyIcon")!, title: "Soap", category: "Family Health", increase:  0.01, price: 3, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "familyIcon")!, title: "Lysol Wipes", category: "Family Health", increase:  0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "familyIcon")!, title: "Tylenol", category: "Family Health", increase:  0.02, price: 5, foodGroup: FoodGroup.none, available: randAvail()),
                               Item(image: UIImage(named: "familyIcon")!, title: "Vitamins", category: "Family Health", increase:  0.05, price: 11, foodGroup: FoodGroup.none, available: randAvail()),

                               //National Health
        Item(image: UIImage(named: "nationalIcon")!, title: "Soup Kitchen Donation", category: "Nation Rate", increase:  -0.05, price: 50, foodGroup: FoodGroup.none, available: 1.0),
                               Item(image: UIImage(named: "nationalIcon")!, title: "PPE Donation", category: "Nation Rate", increase:  -0.1, price: 100, foodGroup: FoodGroup.none, available: 1.0),
                               Item(image: UIImage(named: "nationalIcon")!, title: "Childcare Donation", category: "Nation Rate", increase:  -0.07, price: 70, foodGroup: FoodGroup.none, available: 1.0),
                               Item(image: UIImage(named: "nationalIcon")!, title: "Homeless Shelter Donation", category: "Nation Rate", increase:  -0.04, price: 40, foodGroup: FoodGroup.none, available: 1.0)

                              
                               
                               
                               
        ]
        
    }
    
    func updateFoodGroupOutlets(){
        fruitOutlet.text = "Fruit: \(Double(Int(foodGroupPercents[FoodGroup.fruit]!*1000))/10.0)%"
        vegetableOutlet.text = "Vegetable: \(Double(Int(foodGroupPercents[FoodGroup.vegetable]!*1000))/10.0)%"
        grainOutlet.text = "Grain: \(Double(Int(foodGroupPercents[FoodGroup.grain]!*1000))/10.0)%"
        proteinOutlet.text = "Protein: \(Double(Int(foodGroupPercents[FoodGroup.protein]!*1000))/10.0)%"
        dairyOutlet.text = "Dairy: \(Double(Int(foodGroupPercents[FoodGroup.dairy]!*1000))/10.0)%"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "myCell")!
         cell.isUserInteractionEnabled = true
         cell.backgroundColor = UIColor.white
        let selected = items[indexPath.row]
        cell.imageView?.image = selected.image
        cell.textLabel?.text = selected.title
        
        if(selected.category != "Upgrade"){
        cell.detailTextLabel?.text = "\(selected.category) \(Int(selected.increase*100))%"
        }
        else if selected.title == "Clickerator"{
            cell.detailTextLabel?.text = "Each click will be worth $\(Int(doubleClick*2.0))"
            
        }
        else if selected.title == "Flattenator"{
            cell.detailTextLabel?.text = "Daily Nation Growth Rate decrease \((nationHealthDecrease+1.0)*5.0)%"
            
        }
        else if selected.title == "Happinator" {
            cell.detailTextLabel?.text = "Daily Happiness increase \((happinessIncrease+1.0)*5.0)%"
            
        }
        else if selected.title == "Rationator" {
                  cell.detailTextLabel?.text = "Cut food and TP usage by an extra 20%"
                  
              }
        
        
        let costLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
       
     costLabel.text = "$\(selected.price)"
       
        if selected.available < 0.20 + 0.05 * Double(level){
        
         cell.isUserInteractionEnabled = false
             
         costLabel.text = "Out!"
         
         cell.backgroundColor = UIColor.yellow
         }
        
        

        
        cell.accessoryView = costLabel
        //print(cell.textLabel?.text)
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("selected")
        let selected = items[indexPath.row]
        
        if self.cash - selected.price < 0{
            let noGoodalert = UIAlertController(title: "Error", message: "You don't have enough money!", preferredStyle: .alert)
            noGoodalert.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
            self.present(noGoodalert, animated: true, completion: nil)
        }
        else{
            playSound(file: "bicycleBell.wav")
            if todaysFoodItems[selected.title] != nil{
                var temp = todaysFoodItems[selected.title]!
                temp+=1
                todaysFoodItems.updateValue(temp, forKey: selected.title)
                
            }
            else {
                todaysFoodItems.updateValue(1, forKey: selected.title)
            }
            
            if todaysFoodItems[selected.title]! >= 3 && selected.category != "Upgrades" && selected.category != "Nation Rate"{
            let alert = UIAlertController(title: "Hoarding Alert!", message: "You are hoarding \(selected.title) and have hurt the Nation's Health! Nation growth rate will increase.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (alert) in
                self.nationHealth += 0.01
                self.nationOutlet.text = "Nation Growth: \(Int(self.nationHealth*100))%"
                
            }))
            present(alert, animated: true)
                self.playSound(file: "gasp.wav")
          //  print(todaysFoodItems)
            }
            
           
            self.cash-=selected.price
            self.moneyOutlet.text = "$\(self.cash)"
            switch selected.category{
            case "Food":
                self.food += selected.increase
                self.foodOutlet.text = "Food: \(Int(self.food*100))%"
                if let current = foodGroupPercents[selected.foodGroup]{
                    foodGroupPercents.updateValue(current + selected.increase , forKey: selected.foodGroup)}
                updateFoodGroupOutlets()
            //    print(foodGroupPercents)
                case "Nation Rate":
                self.nationHealth += CGFloat(selected.increase)
                self.nationOutlet.text = "Nation Growth: \(Int(self.nationHealth*100))%"
                case "Family Health":
                self.familyHealth += selected.increase
                self.familyOutlet.text = "Family Health: \(Int(self.familyHealth*100))%"
                case "Happiness":
                self.happiness += selected.increase
                self.happinessOutlet.text = "Happiness: \(Int(self.happiness*100))%"
                case "Toilet Paper":
                self.tp += selected.increase
                self.tpOutlet.text = "Toilet Paper: \(Int(self.tp*100))%"
            case "Upgrade":
                if(selected.title == "Clickerator"){
                    doubleClick *= 2.0
                    tableView.reloadData()
                }
                else if selected.title == "Flattenator"{
                    nationHealthDecrease += 1.0
                    tableView.reloadData()
                }
                else if selected.title == "Happinator"{
                    happinessIncrease += 1.0
                    tableView.reloadData()
                }
                    else if selected.title == "Rationator"{
                        rationIncrease += 1.0
                        tableView.reloadData()
                    }
                else{
                    print("no upgrade action")
                }
            default:
                print("other")
                
            }
            }
        

        }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ViewController{
        vc.money = cash
           // print("vcmoney \(vc.money)")
            vc.updateMoney()
            vc.foodProgressOutlet.progress = food
            vc.nationHealthRate = nationHealth
            vc.healthProgressOutlet.progress = familyHealth
            vc.tpProgressOutlet.progress = tp
            vc.happinessProgressOutlet.progress = happiness
            vc.nextDay()
            vc.storeOutlet.isEnabled = true
            vc.nextDayOutlet.isEnabled = true
            vc.foodGroupPercents = foodGroupPercents
            vc.doubleClick = doubleClick
            vc.happinessIncrease = happinessIncrease
            vc.nationHealthDecrease = nationHealthDecrease
            vc.rationIncrease = rationIncrease
            vc.storeOutlet.isEnabled = false
            
           
        }
    }
        
   
     

    
   
   
}
