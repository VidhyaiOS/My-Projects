//
//  ViewController.swift
//  Time_App
//
//  Created by Apple on 15/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class ViewController: UIViewController{
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entityDescription = NSEntityDescription()
    var managedObj = NSManagedObject()
    
    var breakArray:NSMutableArray = NSMutableArray()
    var totalTimeArray:NSMutableArray = NSMutableArray()
    
    var startBtn:UIButton! = UIButton()
    var breakBtn:UIButton! = UIButton()
    var timerLabel:UILabel! = UILabel()
    var breakLabel = UILabel()
    var timer:Timer? = Timer()
    var breakTimer:Timer? = Timer()
    var count = Int()
    var breakCount = 0
    var breakTakenNo = 1
    var layoutDic = [String:AnyObject]()
    var progressCircle = CAShapeLayer()
    var circle = UIView()
    var data = Data()
    var BreakTimeData = Data()
    
    //MARK: ViewDidLoad
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.black
        layoutDic["startBtn"] = startBtn
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(startBtn)
        startBtn.backgroundColor = UIColor.blue
        startBtn .setTitle("Start", for: UIControlState())
        startBtn.layer.cornerRadius = 5
        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startBtn.addTarget(self, action: #selector(ViewController.StartBtnTapped), for: UIControlEvents.touchUpInside)
        startBtn.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addConstraint(NSLayoutConstraint.init(item: startBtn, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        startBtn.addConstraint(NSLayoutConstraint.init(item: startBtn, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-35-[startBtn]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: layoutDic))
        startBtn.addConstraint(NSLayoutConstraint.init(item: startBtn, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))
        
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timerLabel)
        timerLabel.font = UIFont.systemFont(ofSize: 25)
        timerLabel.textColor = UIColor.white
        timerLabel.textAlignment = NSTextAlignment.center
        layoutDic["timerLabel"] = timerLabel
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(150)-[timerLabel]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: layoutDic))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(175)-[timerLabel(40)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: layoutDic))
        
        layoutDic["breakBtn"] = breakBtn
        breakBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(breakBtn)
        breakBtn.backgroundColor = UIColor.blue
        breakBtn .setTitle("Break", for: UIControlState())
        breakBtn.layer.cornerRadius = 5
        breakBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        breakBtn.addTarget(self, action: #selector(ViewController.breakBtnTapped), for: UIControlEvents.touchUpInside)
        breakBtn.setTitleColor(UIColor.white, for: UIControlState())
       
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(310)-[breakBtn]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: layoutDic))
        self.view.addConstraint(NSLayoutConstraint.init(item: breakBtn, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        breakBtn.addConstraint(NSLayoutConstraint.init(item: breakBtn, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
      
        breakBtn.addConstraint(NSLayoutConstraint.init(item: breakBtn, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80))
        breakBtn.isHidden = true
    
        
        breakLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(breakLabel)
        breakLabel.font = UIFont.systemFont(ofSize: 15)
        breakLabel.textColor = UIColor.white
        breakLabel.textAlignment = NSTextAlignment.center
        layoutDic["breakLabel"] = breakLabel
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(365)-[breakLabel(40)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: layoutDic))
        self.view.addConstraint(NSLayoutConstraint.init(item: breakLabel, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        breakLabel.addConstraint(NSLayoutConstraint.init(item: breakLabel, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80))
        if UserDefaults.standard.object(forKey: "Time_Value") != nil {
             let countString = UserDefaults.standard.object(forKey: "Time_Value")!
            count = countString as! Int
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            self.startBtn.setTitle("Stop", for: UIControlState())
            breakBtn.isHidden = false
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            }
    
    
    //MARK: Start Btn Function
    func StartBtnTapped() {
        breakBtn.isHidden = false
        if startBtn.titleLabel?.text == "Start" {
          
            self.startBtn.setTitle("Stop", for: UIControlState())
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            progressFunction()
            currrentDateTime()
    }
       else {
            
           let alertController = UIAlertController(title: "Timer App", message: "Are you sure you want to stop", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                 case .default:
                    
                    self.startBtn.setTitle("Start", for: UIControlState())
                    self.stopCountdown()
                    self.pauseAnimation()
                    self.breakBtn.isHidden =  true
                    self.timerLabel.isHidden = true
                    self.circle.isHidden = true
                    UserDefaults.standard.string(forKey: "Time_Value")
                    self.currrentDateTime()
                    
                 case .cancel:
                   print("Nocancel")
             
                 case .destructive:
                   print("destructive")

                }
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                
                switch action.style{
                case .default:
                    print("Nodefault")
                    
                case .cancel:
                    print("Nocancel")
                    
                case .destructive:
                    print("destructive")
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
    
        }
    }
    
    func updateCountDown() {
        
            let hours = count / 3600
            let minsec = count % 3600
            let minutes = minsec / 60
            let seconds = minsec % 60
            timerLabel.isHidden = false
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            count += 1
         UserDefaults.standard.set(count, forKey: "Time_Value")
        UserDefaults.standard.synchronize()

    }
    
    func stopCountdown() {
        
        if startBtn.titleLabel?.text == "Start" {
          
            self.timer?.invalidate()
            self.timer = nil
            updateData(text: timerLabel.text!,key: "totalTiming")
            count = 0
            
        }else{
           
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
   // MARK: Break Btn Function
    func breakBtnTapped() {
        if breakBtn.titleLabel?.text == "Break" {
             stopCountdown()
             pauseAnimation()
             breakTakenNo += 1
             startBtn.isUserInteractionEnabled = false
             self.breakBtn.setTitle("Stop Break", for: UIControlState())
            if breakTimer != nil {
                self.breakTimer?.invalidate()
            }else {
             breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(breakCountDown), userInfo: nil, repeats: true)
            }
            
        }
        else {
            UserDefaults.standard.string(forKey: "Break".appending(String(format: "%d", breakTakenNo)))
            breakArray.add(breakLabel.text!)
            archiving(array: breakArray)
            startBtn.isUserInteractionEnabled = true
            self.breakBtn.setTitle("Break", for: UIControlState())
            breakStopCountdown()
            resumeAnimation()
            if startBtn.titleLabel?.text == "Start" {
              self.startBtn.setTitle("Stop", for: UIControlState())
              timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            }else{
              timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            }
        }
 
    }
    
    func breakCountDown() {
        let hours = breakCount / 3600
        let minsec = breakCount % 3600
        let minutes = minsec / 60
        let seconds = minsec % 60
        breakLabel.isHidden = false
        breakLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        breakCount += 1
       
        UserDefaults.standard.set(breakLabel.text, forKey: "Break".appending(String(format: "%d",breakTakenNo)))
        UserDefaults.standard.synchronize()
      }
  
    func breakStopCountdown() {
       
        self.breakTimer?.invalidate()
        self.breakTimer = nil
        breakLabel.text = "00:00:00"
        breakLabel.isHidden = true
        breakCount = 0
       }
    
    //MARK: Circular Progress Function
    
    func progressFunction() {
        
     circle = UIView(frame: CGRect(x:130 , y:120 , width:150, height:150))
     self.view.addSubview(circle)
        
    let circlePath = UIBezierPath(ovalIn: circle.bounds)
    progressCircle = CAShapeLayer ()
    progressCircle.path = circlePath.cgPath
    progressCircle.strokeColor = UIColor.orange.cgColor
    progressCircle.fillColor = UIColor.clear.cgColor
    progressCircle.lineWidth = 15.0
    
    circle.layer.addSublayer(progressCircle)
   
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 120
    animation.byValue = (2.0*M_PI)
    animation.timeOffset = 0
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    progressCircle.add(animation, forKey: "ani")
//    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:progressCircle)
    }
    
    func pauseAnimation(){
      let pausedTime = progressCircle.convertTime(CACurrentMediaTime(), from: nil)
        progressCircle.speed = 0.0
       progressCircle.timeOffset = pausedTime
         print(progressCircle)
    }
    
    func resumeAnimation(){
//        let decoded  = UserDefaults.standard.object(forKey: "ProgressBar") as! Data
//        let circle = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! CAShapeLayer
        print(UserDefaults.standard.object(forKey: "ProgressBar"))
        let pausedTime = progressCircle.timeOffset
        progressCircle.speed = 1.0
        progressCircle.timeOffset = 0.0
        progressCircle.beginTime = 0.0
        let timeSincePause = progressCircle.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressCircle.beginTime = timeSincePause
    }
//    func progress() {
//        
//        circle = UIView(frame: CGRect(x:130 , y:120 , width:150, height:150))
//        self.view.addSubview(circle)
//        
//        let circlePath = UIBezierPath(ovalIn: circle.bounds)
//        progressCircle = CAShapeLayer ()
//        progressCircle.path = circlePath.cgPath
//        progressCircle.strokeColor = UIColor.orange.cgColor
//        progressCircle.fillColor = UIColor.clear.cgColor
//        progressCircle.lineWidth = 15.0
//        
//        circle.layer.addSublayer(progressCircle)
//        
//        let animation = CABasicAnimation(keyPath: "tranzform.rotation.z")
//        animation.fromValue = 0
//        animation.toValue = 1
//        animation.duration = 28800
//        animation.byValue = (2.0*M_PI)
//        animation.timeOffset = 0
//        animation.fillMode = kCAFillModeForwards
//        animation.isRemovedOnCompletion = false
//        progressCircle.add(animation, forKey: "ani")
//        
//    }

//    func resume() {
//        let pausedTime = progressCircle.timeOffset
//        progressCircle.speed = 1.0
//        progressCircle.timeOffset = 0.0
//        progressCircle.beginTime = 0.0
//        let countString = UserDefaults.standard.object(forKey: "Time_Value")!
//        count = countString as! Int
//        let timeSincePause = progressCircle.convertTime(CFTimeInterval(count), from: nil) - pausedTime
//        progressCircle.beginTime = timeSincePause
//    }
    
    
    //MARK: Core Data
    func storeTiming(text:Any,key:String) {
        
            entityDescription =
                NSEntityDescription.entity(forEntityName: "Timings",
                                           in: context)!
            
            let timing = NSManagedObject(entity: entityDescription,
                                         insertInto: context)
            
            timing.setValue(text, forKey: key)
            
            do {
                try context.save()
                breakLabel.text = ""
                timerLabel.text = ""
                print("Context\(timing)")
                
            } catch let error {
                print("Error \(error.localizedDescription)")
            }

    }
   
    func getTiming(text:Any,key:String) {
    
        let request: NSFetchRequest<Timings> = Timings.fetchRequest()
       
        do {
            let results = try context.fetch(request)
          
            if results.count > 0 {
                let match = results[0] as NSManagedObject
               
                match.setValue(text, forKey: key)
                
                try context.save()
                print(match.value(forKey: "totalTiming") as? String)
         
                print("Matches found: \(results.count)")
            } else {
                
                print("NO Match Found")
            
            }
            
        } catch let error {
              print("Error \(error.localizedDescription)")
        }
    }
    
    //MARK: Update to CoreData
    
    func updateData(text:Any,key:String) {
       
        let request: NSFetchRequest<Timings> = Timings.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sno", ascending: false)]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
         //   print("result found: \(result)")
            if result.count > 0 {
                let match = result[0] as NSManagedObject
                match.setValue(text, forKey: key)
                print("matches found: \(match)")
            } else {
                print("NO Match Found")
            }
        } catch let error {
            print("Error \(error.localizedDescription)")
        }
    }
    
   //MARK: Date And time 
    
    func currrentDateTime() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour , .minute], from: date as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let formatteddate = formatter.string(from: date as Date)
      
        let hour = components.hour
        let minute = components.minute
        
        if startBtn.titleLabel?.text == "Start" {
            
            updateData(text: String(format: "%02d:%02d", hour!, minute!), key: "stopTiming")
            
        }
        else{
            
            let request: NSFetchRequest<Timings> = Timings.fetchRequest()
            do {
                let result = try context.fetch(request)
                if result.count > 0 {
                     storeTiming(text:"\(result.count+1)", key: "sno")
                } else {
                    storeTiming(text:"1", key: "sno")
                }
            } catch let error {
                print("Error \(error.localizedDescription)")
            }
                updateData(text: formatteddate, key: "date")
                updateData(text: String(format: "%02d:%02d", hour!, minute!), key: "startTiming")
        }
      
    }
    
    func archiving(array:NSArray) {
        
        BreakTimeData = NSKeyedArchiver.archivedData(withRootObject: array)
        updateData(text: BreakTimeData, key: "breakTiming")
        
    }
    
    func unarchiving(data:Data) {
        if let data1 = NSKeyedUnarchiver.unarchiveObject(with:data as Data){
            print("Data\(data1)")
        }
    }
    
}



