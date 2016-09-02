//
//  ViewController.swift
//  DayNightSwitch
//
//  Created by Finn Gaida on 02.09.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dayNightSwitch = DayNightSwitch(center: self.view.center)
        dayNightSwitch.changeAction = { on in
            print("The switch is now " + (on ? "on" : "off"))
        }
        self.view.addSubview(dayNightSwitch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

