//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Ross McIlwaine on 5/16/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    func updateWithAlarm(alarm: Alarm) {
        
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.on = alarm.enabled
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        
        // implement via protocol
        delegate?.switchCellSwitchValueChanged(self)
    }
}

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}
