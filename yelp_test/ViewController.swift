//
//  ViewController.swift
//  qr
//
//  Created by Shuya Ma on 12/5/16.
//  Copyright © 2016 Shuya Ma. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var lblQRCodeLabel: UILabel!
    @IBOutlet weak var lblQRCodeResult: UILabel!
    
    var capture:Bool = true
    var restuart:String = ""
    var check: Int = 16
    
    var RestaurantName: [String] =  ["Salt + Smoke, BBQ Bourbon and Beer", "Seoul Taco", "Público", "Mission Taco Joint", "Fork & Stix", "Mayana Mexican Kitchen", "Three Kings Public House", "Corner 17", "Winslow's Home", "Peno",  "Sauce On the Side", "Pastaria", "Sasha's", "Randolfi's", "Basso", "Tavolo V" ]
    
    
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
        
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
//            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
//            alertView.show()
            
            let alertController:UIAlertController = UIAlertController(title: "Device Error", message: "Device not Supported for this Application", preferredStyle: .Alert)
            
            let cancelAction:UIAlertAction = UIAlertAction(title: "Ok Done", style: .Cancel, handler: { (alertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        self.view.bringSubviewToFront(lblQRCodeResult)
        self.view.bringSubviewToFront(lblQRCodeLabel)
        objCaptureSession?.startRunning()
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.redColor().CGColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubviewToFront(vwQRCode!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if (capture){
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRectZero
            lblQRCodeResult.text = "NO QRCode text detacted"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                 check = checkCode(objMetadataMachineReadableCodeObject.stringValue)
                if (check < 16){
                    capture = false;
                lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
                restuart = objMetadataMachineReadableCodeObject.stringValue
                let alert = UIAlertController(title: restuart, message: "Checked in", preferredStyle: UIAlertControllerStyle.Alert)
                //let OKAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
                let OKAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (_) in self.performSegueWithIdentifier("unwindToBingo", sender: self)
                })
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: restuart, message: "Invalid QRCode", preferredStyle: UIAlertControllerStyle.Alert)
                    let OKAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        }
    }
    
    func checkCode(code: String) -> Int{
        var num: Int = 16
        if (code == RestaurantName[0]){
            num = 0
        }
        else if (code == RestaurantName[1]){
            num = 1
        }
        else if (code == RestaurantName[2]){
            num = 2
        }
        else if (code == RestaurantName[3]){
            num = 3
        }
        else if (code == RestaurantName[4]){
            num = 4
        }
        else if (code == RestaurantName[5]){
            num = 5
        }
        else if (code == RestaurantName[6]){
            num = 6
        }
        else if (code == RestaurantName[7]){
            num = 7
        }
        else if (code == RestaurantName[8]){
            num = 8
        }
        else if (code == RestaurantName[9]){
            num = 9
        }
        else if (code == RestaurantName[10]){
            num = 10
        }
        else if (code == RestaurantName[11]){
            num = 11
        }
        else if (code == RestaurantName[12]){
            num = 12
        }
        else if (code == RestaurantName[13]){
            num = 13
        }
        else if (code == RestaurantName[14]){
            num = 14
        }
        else if (code == RestaurantName[15]){
            num = 15
        }
    
    
        return num
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToBingo"{
            let bingoView = segue.destinationViewController as! BingoBoard
            bingoView.theData[check].checkinImage = "check_red"
            bingoView.theData[check].checkinBool = true
            if(checkBingo(bingoView)>0){
                bingoView.collectionView.reloadData()
                //checkClean(checkBingo(bingoView), bingoView)
                bingoView.checkWin = true
                bingoView.winPattern = checkBingo(bingoView)

            }
            else{
                bingoView.collectionView.reloadData()
            }
            
        }
    }
    
    func checkBingo(bingoView: BingoBoard) -> Int{
        if (bingoView.theData[0].checkinBool && bingoView.theData[4].checkinBool && bingoView.theData[8].checkinBool && bingoView.theData[12].checkinBool){
            return 1
        }
        else if (bingoView.theData[1].checkinBool && bingoView.theData[5].checkinBool && bingoView.theData[9].checkinBool && bingoView.theData[13].checkinBool){
            return 2
        }
        else if (bingoView.theData[2].checkinBool && bingoView.theData[6].checkinBool && bingoView.theData[10].checkinBool && bingoView.theData[14].checkinBool){
            return 3
        }
        else if (bingoView.theData[3].checkinBool && bingoView.theData[7].checkinBool && bingoView.theData[11].checkinBool && bingoView.theData[15].checkinBool){
            return 4
        }
        else if (bingoView.theData[0].checkinBool && bingoView.theData[1].checkinBool && bingoView.theData[2].checkinBool && bingoView.theData[3].checkinBool){
            return 5
        }
        else if (bingoView.theData[4].checkinBool && bingoView.theData[5].checkinBool && bingoView.theData[6].checkinBool && bingoView.theData[7].checkinBool){
            return 6
        }
        else if (bingoView.theData[8].checkinBool && bingoView.theData[9].checkinBool && bingoView.theData[10].checkinBool && bingoView.theData[11].checkinBool){
            return 7
        }
        else if (bingoView.theData[12].checkinBool && bingoView.theData[13].checkinBool && bingoView.theData[14].checkinBool && bingoView.theData[15].checkinBool){
            return 8
        }
        else if (bingoView.theData[0].checkinBool && bingoView.theData[5].checkinBool && bingoView.theData[10].checkinBool && bingoView.theData[15].checkinBool){
            return 9
        }
        else if (bingoView.theData[3].checkinBool && bingoView.theData[6].checkinBool && bingoView.theData[9].checkinBool && bingoView.theData[12].checkinBool){
            return 10
        }
        
        else{
            return 0
        }
       
        
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

