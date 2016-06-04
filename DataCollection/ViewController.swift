//
//  ViewController.swift
//  DataCollection
//
//  Created by Kawhi Lu on 15/8/7.
//  Copyright (c) 2015年 Kawhi Lu. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    var CMdata = NSMutableData()
    var socketClient:TCPClient?
    
    @IBOutlet weak var text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startCollection() {
        print("start touched")
        
        let ip = text.text!
        socketClient = TCPClient(addr: ip, port: 23333)
        
        //连接
        let (connect_success, connect_errmsg) = socketClient!.connect(timeout: 1)
        if connect_success {
            print("connected!")
        } else {
            print(connect_errmsg)
        }
        
        var standard_time = false
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data: CMDeviceMotion?, error: NSError?) -> Void in
                
                let date = NSDate()
                
                if(standard_time) {
                    
                    let outputFormat = NSDateFormatter()
                    outputFormat.locale = NSLocale(localeIdentifier:"en_US")
                    outputFormat.dateFormat = "HH:mm:ss.SSS"
                    
                    let data = ["time":outputFormat.stringFromDate(date), "ax":data!.userAcceleration.x, "ay":data!.userAcceleration.y, "az":data!.userAcceleration.z,
                                            "gx":data!.rotationRate.x, "gy":data!.rotationRate.y, "gz":data!.rotationRate.z,
                                            "mx":data!.attitude.roll, "my":data!.attitude.pitch, "mz":data!.attitude.yaw]
                    
                    do {
                        let msgdata = try NSJSONSerialization.dataWithJSONObject(data,
                            options: NSJSONWritingOptions.PrettyPrinted)
                        self.socketClient!.send(data:msgdata)
                        
                    } catch {
                        print(error)
                    }
                    
                    print(outputFormat.stringFromDate(date))
                    
                } else {
                    
                    standard_time = true
                }
                
            })
        }
    }
    
    @IBAction func stopCollection() {
        print("stop touched")
        
        //        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //        let documentsDirectory = paths[0]
        //        let fileName = "\(documentsDirectory)/textFile.txt"
        //        print("\(fileName)")
        //
        if manager.deviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
//                    CMdata.writeToFile(fileName, atomically: true)
        }
    }
}

