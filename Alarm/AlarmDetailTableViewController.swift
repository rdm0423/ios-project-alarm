//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Ross McIlwaine on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let alarm = alarm {
            updateWithAlarm(alarm)
        }
        
        setupView()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        guard let title = alarmTextField.text, thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {
            return
        }
        let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSinceDate(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.sharedController.updateAlarm(alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
        } else {
            let alarm = AlarmController.sharedController.addAlarm(timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func enableButtonTapped(sender: AnyObject) {
        
        guard let alarm = alarm else {return}
        AlarmController.sharedController.toggleEnabled(alarm)
        setupView()
    }
    
    func updateWithAlarm(alarm: Alarm) {
        
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {
            return
        }
        alarmDatePicker.setDate(NSDate(timeInterval: alarm.fireTimeFromMidnight, sinceDate: thisMorningAtMidnight), animated: false)
        alarmTextField.text = alarm.name
        self.title = alarm.name
    }
    
    func setupView() {
        
        if alarm == nil {
            enableButton.hidden = true
        } else {
            enableButton.hidden = false
            
            if alarm?.enabled == true {
                
                enableButton.setTitle("Disable Alarm", forState: .Normal)
                enableButton.setTitleColor(.lightGrayColor(), forState: .Normal)
                enableButton.backgroundColor = .redColor()
            } else {
                enableButton.setTitle("Enable Alarm", forState: .Normal)
                enableButton.setTitleColor(.whiteColor(), forState: .Normal)
                enableButton.backgroundColor = .greenColor()
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
