//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Ross McIlwaine on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "back.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        // center and scale background image
        imageView.contentMode = .ScaleAspectFill
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        let alarm = AlarmController.sharedController.alarms[indexPath.row]
        AlarmController.sharedController.toggleEnabled(alarm)
        
        // Local Notification
        if alarm.enabled {
            scheduleLocalNotification(alarm)
        } else {
            cancelLocalNotification(alarm)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedController.alarms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as? SwitchTableViewCell

        let alarm = AlarmController.sharedController.alarms[indexPath.row]
        cell?.updateWithAlarm(alarm)
        
        // delegate
        cell?.delegate = self

        return cell ?? UITableViewCell()
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            let alarm = AlarmController.sharedController.alarms[indexPath.row]
            AlarmController.sharedController.deleteAlarm(alarm)
            
            // cancel notification
            cancelLocalNotification(alarm)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: Custom BackGround with Clear cells
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailTVC = segue.destinationViewController as? AlarmDetailTableViewController
        
        if segue.identifier == "alarmDetailSegue" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let alarm = AlarmController.sharedController.alarms[indexPath.row]
            detailTVC?.alarm = alarm
        }
    }
}
