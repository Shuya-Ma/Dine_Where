//
//  BingoBoard.swift
//  qr
//
//  Created by Shuya Ma on 12/5/16.
//  Copyright © 2016 Shuya Ma. All rights reserved.
//

import UIKit

class BingoBoard: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{

    @IBAction func unwindToBingo(segue: UIStoryboardSegue){}

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var animationImageView: UIImageView!
    
    //var DinerNum: Int = 0
    
    var diners = dinerCollection()
    var dinersTemp: [Diner] = []
    var dinersPick: [Diner] = []
    var frame: CGRect!
    var checkWin: Bool = false
    var winPattern: Int = 0
    
    var theData: [DinerInfo] = []
    var DinerName: [String] = ["Salt + Smoke, BBQ Bourbon and Beer", "Seoul Taco", "Público", "Mission Taco Joint", "Fork & Stix", "Mayana Mexican Kitchen", "Three Kings Public House", "Corner 17", "Winslow's Home", "Peno",  "Sauce On the Side", "Pastaria", "Sasha's", "Randolfi's", "Basso", "Tavolo V" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(red: 72, green: 72, blue: 72, alpha: 0.18)
        frame = self.view.frame
        getDiners {}
        print(diners.count)
        var s1:String
        let s2:String = "check_white"
        //let s3:String = "check_red"
        for i in 0...15 {
            s1 = DinerName[i]
           
            theData.append(DinerInfo(DinerId: i, Name:s1, checkinImage: s2))

            
        }
        self.collectionView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        print("???????")
        print(diners.count)
        
        if (checkWin == true){
            let alert = UIAlertController(title: "You win!", message: "You get a free latte Kayak's cafe \n"+"Use code: XUTXVX", preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {(_) in self.checkClean(self.winPattern)})
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            checkWin = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //added
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "bingoToDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let cell = sender as! bingoCell
            detailViewController.diner = cell.diner
        }
    }
    
    func checkClean(n: Int){
        if (n == 1){
            self.theData[0].checkinBool = false
            self.theData[0].checkinImage = "check_white"
            self.theData[4].checkinBool = false
            self.theData[4].checkinImage = "check_white"
            self.theData[8].checkinBool = false
            self.theData[8].checkinImage = "check_white"
            self.theData[12].checkinBool = false
            self.theData[12].checkinImage = "check_white"
        }
        else if (n == 2){
            self.theData[1].checkinBool = false
            self.theData[1].checkinImage = "check_white"
            self.theData[5].checkinBool = false
            self.theData[5].checkinImage = "check_white"
            self.theData[9].checkinBool = false
            self.theData[9].checkinImage = "check_white"
            self.theData[13].checkinBool = false
            self.theData[13].checkinImage = "check_white"
        }
        else if (n == 3){
            self.theData[2].checkinBool = false
            self.theData[2].checkinImage = "check_white"
            self.theData[6].checkinBool = false
            self.theData[6].checkinImage = "check_white"
            self.theData[10].checkinBool = false
            self.theData[10].checkinImage = "check_white"
            self.theData[14].checkinBool = false
            self.theData[14].checkinImage = "check_white"
        }
        else if (n == 4){
            self.theData[3].checkinBool = false
            self.theData[3].checkinImage = "check_white"
            self.theData[7].checkinBool = false
            self.theData[7].checkinImage = "check_white"
            self.theData[11].checkinBool = false
            self.theData[11].checkinImage = "check_white"
            self.theData[15].checkinBool = false
            self.theData[15].checkinImage = "check_white"
        }
        else if (n == 5){
            self.theData[0].checkinBool = false
            self.theData[0].checkinImage = "check_white"
            self.theData[1].checkinBool = false
            self.theData[1].checkinImage = "check_white"
            self.theData[2].checkinBool = false
            self.theData[2].checkinImage = "check_white"
            self.theData[3].checkinBool = false
            self.theData[3].checkinImage = "check_white"
        }
        else if (n == 6){
            self.theData[4].checkinBool = false
            self.theData[4].checkinImage = "check_white"
            self.theData[5].checkinBool = false
            self.theData[5].checkinImage = "check_white"
            self.theData[6].checkinBool = false
            self.theData[6].checkinImage = "check_white"
            self.theData[7].checkinBool = false
            self.theData[7].checkinImage = "check_white"
        }
        else if (n == 7){
            self.theData[8].checkinBool = false
            self.theData[8].checkinImage = "check_white"
            self.theData[9].checkinBool = false
            self.theData[9].checkinImage = "check_white"
            self.theData[10].checkinBool = false
            self.theData[10].checkinImage = "check_white"
            self.theData[11].checkinBool = false
            self.theData[11].checkinImage = "check_white"
        }
        else if (n == 8){
            self.theData[12].checkinBool = false
            self.theData[12].checkinImage = "check_white"
            self.theData[13].checkinBool = false
            self.theData[13].checkinImage = "check_white"
            self.theData[14].checkinBool = false
            self.theData[14].checkinImage = "check_white"
            self.theData[15].checkinBool = false
            self.theData[15].checkinImage = "check_white"
        }
        else if (n == 19){
            self.theData[0].checkinBool = false
            self.theData[0].checkinImage = "check_white"
            self.theData[5].checkinBool = false
            self.theData[5].checkinImage = "check_white"
            self.theData[10].checkinBool = false
            self.theData[10].checkinImage = "check_white"
            self.theData[15].checkinBool = false
            self.theData[15].checkinImage = "check_white"
        }
        else if (n == 10){
            self.theData[3].checkinBool = false
            self.theData[3].checkinImage = "check_white"
            self.theData[6].checkinBool = false
            self.theData[6].checkinImage = "check_white"
            self.theData[9].checkinBool = false
            self.theData[9].checkinImage = "check_white"
            self.theData[12].checkinBool = false
            self.theData[12].checkinImage = "check_white"
        }
        
        self.collectionView.reloadData()

    }
}

extension BingoBoard{
    
    @IBAction func StartButton(sender: AnyObject) {
//        self.collectionView.hidden = false
        startBtn.hidden = true
        print("there are \(diners.count) diners!!!!")
        diners.items.forEach { diner in
            dinersTemp += [diner]
        }
        for din in dinersTemp {
            if dinersPick.count == 16 {
                break
            }
            print(din.name)
            dinersPick += [din]
        }
        self.collectionView.reloadData()
        let images = [UIImage(named: "0.png")!,
                      UIImage(named: "1.png")!,
                      UIImage(named: "2.png")!,
                      UIImage(named: "3.png")!,
                      UIImage(named: "4.png")!,
                      UIImage(named: "5.png")!,
                      UIImage(named: "6.png")!,
                      UIImage(named: "7.png")!,
                      UIImage(named: "8.png")!,
                      UIImage(named: "9.png")!,
                      UIImage(named: "10.png")!,
                      UIImage(named: "11.png")!,
                      UIImage(named: "12.png")!,
                      UIImage(named: "13.png")!,
                      UIImage(named: "14.png")!,
                      UIImage(named: "15.png")!,
                      UIImage(named: "16.png")!,
                      UIImage(named: "17.png")!,
                      UIImage(named: "18.png")!,
                      UIImage(named: "19.png")!,
                      UIImage(named: "20.png")!,
                      UIImage(named: "21.png")!,
                      UIImage(named: "22.png")!,
                      UIImage(named: "23.png")!,
                      UIImage(named: "24.png")!,
                      UIImage(named: "25.png")!,
                      UIImage(named: "26.png")!,
                      UIImage(named: "27.png")!,
                      UIImage(named: "28.png")!,
                      UIImage(named: "29.png")!,
                      UIImage(named: "30.png")!,
                      UIImage(named: "31.png")!,
                      UIImage(named: "32.png")!,
                      UIImage(named: "33.png")!,
                      UIImage(named: "34.png")!,
                      UIImage(named: "35.png")!,
                      UIImage(named: "36.png")!,
                      UIImage(named: "37.png")!,
                      UIImage(named: "38.png")!,
                      UIImage(named: "39.png")!,
                      UIImage(named: "40.png")!,
                      UIImage(named: "41.png")!,
                      UIImage(named: "42.png")!,
                      UIImage(named: "43.png")!,
                      UIImage(named: "44.png")!,
                      UIImage(named: "45.png")!,
                      UIImage(named: "46.png")!,
                      UIImage(named: "47.png")!,
                      UIImage(named: "48.png")!,
                      UIImage(named: "49.png")!,
                      UIImage(named: "50.png")!,
                      UIImage(named: "51.png")!,
                      UIImage(named: "52.png")!,
                      UIImage(named: "53.png")!,
                      UIImage(named: "54.png")!,
                      UIImage(named: "55.png")!,
                      UIImage(named: "56.png")!,
                      UIImage(named: "57.png")!,
                      UIImage(named: "58.png")!,
                      UIImage(named: "59.png")!,
                      UIImage(named: "60.png")!,
                      UIImage(named: "61.png")!
        ]
        // Normal Animation
        let w = frame.size.width / 5
        let h = frame.size.height / 3.5
        
        let animationImageView = UIImageView(frame: CGRectMake(w, h, 200, 200))
        animationImageView.animationImages = images
        animationImageView.animationDuration = 1.25
        animationImageView.animationRepeatCount = 4
        self.view.addSubview(animationImageView)
        animationImageView.startAnimating()
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 5)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.collectionView.hidden = false
            self.view.backgroundColor = UIColor.whiteColor()
            
        })
    }
    
}

extension BingoBoard {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.theData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bingoCell", forIndexPath: indexPath) as! bingoCell
        if diners.count != 0 {
            cell.diner = dinersPick[indexPath.row]
            print(cell.diner!.name)
            cell.renewData()
        }
        
        cell.restaurantCheck?.image = UIImage(named: self.theData[indexPath.row].checkinImage)
       // cell.restaurantCheck?.image = UIImage(named: "check_white")
//        cell.restaurantLabel.text = self.dinersPick[indexPath.row-1].name
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        DinerDetails.text = self.dinersPick[indexPath.row-1].name
    }

}


// Obtain Diner data
extension BingoBoard {
    func getDiners(done: () -> Void) {
        diners.fetch(
            done: { _ in
                done()
            },
            fail: {_ in}
        )
    }
    
    func refresh(sender: AnyObject) {
        getDiners {
            dispatch_async(dispatch_get_main_queue()) {
            }
        }
    }
}


