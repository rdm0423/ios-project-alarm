//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Ross McIlwaine on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {

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
        
        // Custom Coloring
        let backgroundImage = UIImage(named: "back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        alarmDatePicker.backgroundColor = UIColor(red:0.04, green:0.15, blue:0.29, alpha:00.5)
        alarmTextField.backgroundColor = UIColor(red:0.04, green:0.15, blue:0.29, alpha:00.7)
        
        // center and scale background image
        imageView.contentMode = .ScaleAspectFill
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        guard let title = alarmTextField.text, thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {
            return
        }
        let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSinceDate(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.sharedController.updateAlarm(alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            
            // Local Notification
            cancelLocalNotification(alarm)
            scheduleLocalNotification(alarm)
        } else {
            let alarm = AlarmController.sharedController.addAlarm(timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            
            // Local Notification
            scheduleLocalNotification(alarm)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func enableButtonTapped(sender: AnyObject) {
        
        guard let alarm = alarm else {return}
        AlarmController.sharedController.toggleEnabled(alarm)
        
        // Local Notification
        if alarm.enabled {
            scheduleLocalNotification(alarm)
        } else {
            cancelLocalNotification(alarm)
        }
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
    
    // MARK: Custom BackGround with Clear cells
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }

}
