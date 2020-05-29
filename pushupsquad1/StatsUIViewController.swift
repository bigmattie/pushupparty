//
//  StatsUIViewController.swift
//  
//
//  Created by Matthew Manning on 5/29/20.
//

import UIKit
import Firebase
class StatsUIViewController: UIViewController {
    //Progress Bars
    @IBOutlet weak var sundayProgressBar: CustomProgessBar!
    @IBOutlet weak var mondayProgressBar: CustomProgessBar!
    @IBOutlet weak var tuesdayProgressBar: CustomProgessBar!
    @IBOutlet weak var wednesdayProgressBar: CustomProgessBar!
    @IBOutlet weak var thursdayProgressBar: CustomProgessBar!
    @IBOutlet weak var fridayProgressBar: CustomProgessBar!
    @IBOutlet weak var saturdayProgressBar: CustomProgessBar!
    
    //Total Labels
    @IBOutlet weak var sundayTotalLabel: UILabel!
    @IBOutlet weak var mondayTotalLabel: UILabel!
    @IBOutlet weak var tuesdayTotalLabel: UILabel!
    @IBOutlet weak var wednesdayTotalLabel: UILabel!
    @IBOutlet weak var thursdayTotalLabel: UILabel!
    @IBOutlet weak var fridayTotalLabel: UILabel!
    @IBOutlet weak var saturdayTotalLabel: UILabel!
    
    //Overall Outlets for bottom of stats page
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var currentMonthTotalLabel: UILabel!
    @IBOutlet weak var allTimeTotalLabel: UILabel!
    
    //This Week Countvalues
    var MondayCountValue = 0
    var TuesdayCountValue = 0
    var WednesdayCountValue = 0
    var ThursdayCountValue = 0
    var FridayCountValue = 0
    var SaturdayCountValue = 0
    var SundayCountValue = 0
    var ThisMonthPushup = 0
    var ThisMonthPushupTime = 0
    var AllTimePushup = 0
    var AllTimePushupTime = 0
    var i = 0
    
    //Initalize Firebase firestore :)
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //disable proximty sensor
        UIDevice.current.isProximityMonitoringEnabled = false //defaults proximity sensor to false
        title = "Stats" //Title of Page
        let user = Auth.auth().currentUser //Get current User
        let uid = user?.uid ?? " " //Get current users UID
        
        //set variables for each days total count
        MondayCountValue = 0
        TuesdayCountValue = 0
        WednesdayCountValue = 0
        ThursdayCountValue = 0
        FridayCountValue = 0
        SaturdayCountValue = 0
        SundayCountValue = 0
        ThisMonthPushup = 0
        ThisMonthPushupTime = 0
        AllTimePushup = 0
        AllTimePushupTime = 0
        
        //sets current Month label as the current month
        currentMonthLabel.text = String(Date.getCurrentMonth()[0])
        
        getThisWeekValues()
    }
    
    //Get this weeks days that have ocurred and associated dates to call db
    //
    //
    //
    func getThisWeekDates() -> [String:String] {
        let cal = Calendar.current
        let dateFormatter = DateFormatter()
        // start with today
        var date = Date()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "e" //set date format as number of week 1 = Sunday
        let todayNumber = dateFormatter.string(from: date) //get todays number
        let nDays = ((Int(todayNumber) ?? 0)-1) // set n days and Int of Todays number.
        var myDictionary:[String:String] = [:]
        myDictionary[todayNumber] = dateString
        //catches what happens if int number is 1 (on monday) because it makes Ndays 0 for the for loop
        if (nDays == 0) {
            
        } else {
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            // print(date)
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let dateString = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "e"
            let dayInteger =  dateFormatter.string(from: date)
            myDictionary[dayInteger] = dateString
        }
        }
        return myDictionary
    }
    ///
    ///
    ///
       //Get THIS WEEK values from firebase
       ///
       ///
       ///
       func getThisWeekValues() {
           //Get and Set this weeks Dates
           let thisWeekDates = getThisWeekDates()
           let MondayDate = thisWeekDates["2"] ?? "0"
           let TuesdayDate = thisWeekDates["3"] ?? "0"
           let WednesdayDate = thisWeekDates["4"] ?? "0"
           let ThursdayDate = thisWeekDates["5"] ?? "0"
           let FridayDate = thisWeekDates["6"] ?? "0"
           let SaturdayDate = thisWeekDates["7"] ?? "0"
           let SundayDate = thisWeekDates["1"] ?? "0"
           db.collection("users").document(Auth.auth().currentUser?.uid ?? " ").collection("sessions").addSnapshotListener { (querySnapshot, err) in
               if let err = err {
                   print("Error  \(err)")
               } else {
                   self.MondayCountValue = 0
                   self.TuesdayCountValue = 0
                   self.WednesdayCountValue = 0
                   self.ThursdayCountValue = 0
                   self.FridayCountValue = 0
                   self.SaturdayCountValue = 0
                   self.SundayCountValue = 0
                   self.ThisMonthPushup = 0
                   self.ThisMonthPushupTime = 0
                   self.AllTimePushup = 0
                   self.AllTimePushupTime = 0
                   print("start stats calculation")
                   //query database for weekly values
                   for document in querySnapshot!.documents {
                       
                       let sessionDateString = document["dateString"] as? String
                       let sessionMonth = sessionDateString?.components(separatedBy: "-")[1] ?? " "
                       let currentMonth = String(Date.getCurrentMonth()[1])
                       //THIS MONTH
                       /////Check if session was in this month
                       if (sessionMonth == currentMonth) {
                           print("Added session to ", currentMonth , " current Month ", sessionMonth, " session Month")
                           /////Add up THIS MONTH PUSHUPS COUNT
                            let oldThisMonthTime = self.ThisMonthPushup
                            let thisMonthPushupsFromFirebase = document["numberOfPushups"] as! Int
                            self.ThisMonthPushup = oldThisMonthTime + thisMonthPushupsFromFirebase
                            //Add up THIS MONTH PUSHUPS TIME
                            let oldThisMonthPushups = self.ThisMonthPushupTime
                            let thisMonthPushupTimeFromFirebase = (document["pushupsTime"] as? NSString ?? "0").integerValue
                            self.ThisMonthPushupTime = thisMonthPushupTimeFromFirebase + oldThisMonthPushups
                       } else {
                           print("Did not add session to Month ", currentMonth, " calculation because this session was in Month ", sessionMonth)
                       }
    
                       //ALL TIME PUSHUPS COUNT
                       let oldAllTimePushupCount = self.AllTimePushup
                       let allTimePushupsFromFirebase = document["numberOfPushups"] as! Int
                       self.AllTimePushup = oldAllTimePushupCount + allTimePushupsFromFirebase
                       //ALL TIME PUSHUPS TIME
                       let oldAllTimePushupsTime = self.AllTimePushupTime
                       let allTimePushupsTimeFromFirebase = (document["pushupsTime"] as? NSString ?? "0").integerValue
                       self.AllTimePushupTime = oldAllTimePushupsTime + allTimePushupsTimeFromFirebase
                       
                       if (sessionDateString == MondayDate) {
                           //GET MONDAY COUNT
                           let oldPushupCount = self.MondayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.MondayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Monday " + String(self.MondayCountValue), " ", sessionDateString ?? "default value"," ", MondayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                           
                           
                       } else if (sessionDateString == TuesdayDate) {
                           //GET TUESDAY COUNT
                           let oldPushupCount = self.TuesdayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.TuesdayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Tuesday " + String(self.TuesdayCountValue), " ", sessionDateString ?? "default value"," ", TuesdayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                           
                           
                       } else if (sessionDateString == WednesdayDate) {
                           //GET WEDNESDAY COUNT
                           
                           let oldPushupCount = self.WednesdayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.WednesdayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Wednesday " + String(self.WednesdayCountValue)," ", sessionDateString ?? "default value"," ", WednesdayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                           
                           
                       } else if (sessionDateString == ThursdayDate) {
                           //GET THURSDAY COUNT
                           let oldPushupCount = self.ThursdayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.ThursdayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Thursday " + String(self.ThursdayCountValue), " ", sessionDateString ?? "default value"," ", ThursdayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                           
                           
                       } else if (sessionDateString == FridayDate) {
                           //GET FRIDAY COUNT
                           let oldPushupCount = self.FridayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.FridayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Friday " + String(self.FridayCountValue), sessionDateString ?? "default value", " ", FridayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                           
                           
                       } else if (sessionDateString == SaturdayDate) {
                           //GET SATURDAY COUNT
                           let oldPushupCount = self.SaturdayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.SaturdayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Saturday  " + String(self.SaturdayCountValue)," ", sessionDateString ?? "default value"," ", SaturdayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                       } else if (sessionDateString == SundayDate) {
                           //GET Sunday COUNT
                           
                           let oldPushupCount = self.SundayCountValue
                           let pushupsFromFirebase = document["numberOfPushups"] as! Int
                           self.SundayCountValue = oldPushupCount + pushupsFromFirebase
                           print("Sunday  " + String(self.SundayCountValue)," ", sessionDateString ?? "default value"," ", SundayDate, " old Pushups ", oldPushupCount, " Pushups from Firebase ", pushupsFromFirebase)
                       } else {
                           //                        print("Unregistered Session ", document["numberOfPushups"] as Any, " ", sessionDateString ?? "default value"," ")
                       }
                   }
                   print(thisWeekDates)
                   print("finished calculation")
                   self.setThisWeekValuesAsTotalCountText()
                   print("finished setting total count text")
                   self.setThisWeekTotalBar()
                   print("finished updating this week progress bar")
                   
               }
           }
       }
       
    ///
    ///
    ///
    //Set THIS WEEK values from firebase as total count text on view controller
    ///
    ///
    ///
    
    func setThisWeekValuesAsTotalCountText() {
        
        self.sundayTotalLabel.text = String(self.SundayCountValue)
        self.mondayTotalLabel.text = String(self.MondayCountValue)
        self.tuesdayTotalLabel.text = String(self.TuesdayCountValue)
        self.wednesdayTotalLabel.text = String(self.WednesdayCountValue)
        self.thursdayTotalLabel.text = String(self.ThursdayCountValue)
        self.fridayTotalLabel.text = String(self.FridayCountValue)
        self.saturdayTotalLabel.text = String(self.SaturdayCountValue)
        
        
        //Set This Month Times
        let thisMonthPushupsString = String(self.ThisMonthPushup) + " Pushups "
        let monthMinutes = String(Int(ThisMonthPushupTime / 60))
        let pushupMonthMinutes = (monthMinutes + "min")
        self.currentMonthTotalLabel.text = thisMonthPushupsString + pushupMonthMinutes
        
        //Set All Time Values
        let allTimePushupsString = String(self.AllTimePushup) + " Pushups "
        let minutes = String(Int(AllTimePushupTime / 60))
        let pushupMinutes = (minutes + "min")
        self.allTimeTotalLabel.text = allTimePushupsString + pushupMinutes
        
        
        
    }
    
    ///
    ///
    ///
    //Set THIS WEEK total counts to prorgress bar chart
    ///
    ///
    ///
    
    func setThisWeekTotalBar() {
        //set progress bar amount
        
        
        let thisWeekValueObj = [ MondayCountValue , TuesdayCountValue, WednesdayCountValue, ThursdayCountValue, FridayCountValue, SaturdayCountValue, SundayCountValue]
        let maxValueForProgressBar = thisWeekValueObj.max()
        // let fractionalValue = WednesdayCountValue / maxValueForProgressBar!
        print(maxValueForProgressBar ?? "default value", "Max value for progress bar")
        
        print(Float(Double(WednesdayCountValue) / Double(maxValueForProgressBar ?? 0)))
        
        sundayProgressBar.setProgress(Float(Double(SundayCountValue) / Double(maxValueForProgressBar ?? 0)), animated:true)
        mondayProgressBar.setProgress(Float(Double(MondayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
        tuesdayProgressBar.setProgress(Float(Double(TuesdayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
        wednesdayProgressBar.setProgress(Float(Double(WednesdayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
        thursdayProgressBar.setProgress(Float(Double(ThursdayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
        fridayProgressBar.setProgress(Float(Double(FridayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
        saturdayProgressBar.setProgress(Float(Double(SaturdayCountValue) / Double(maxValueForProgressBar ?? 0)), animated: true)
            }

}
