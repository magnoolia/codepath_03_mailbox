//
//  MailboxViewController.swift
//  codepath_03_mailbox
//
//  Created by Magnolia Caswell-Mackey on 9/30/15.
//  Copyright © 2015 Magnolia. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController,UIScrollViewDelegate {
    //vars--------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!

    @IBOutlet weak var singleMsgView: UIView!
    @IBOutlet weak var message: UIImageView!
    @IBOutlet weak var leftBtn_check: UIImageView!
    @IBOutlet weak var leftBtn_x: UIImageView!
    @IBOutlet weak var rightBtn_list: UIImageView!
    @IBOutlet weak var rightBtn_clock: UIImageView!
    
    var initMessagePos: CGPoint!
    var messagePos: CGPoint! //using view instead (this is image view)
    var singleMsgViewCenter: CGPoint!
    var messageOriginalCenter: CGPoint!
    var initSingleMsgViewCenter: CGPoint!
    var tapDiff: CGFloat!
    var leftMargin: CGFloat!
    var rightMargin: CGFloat!
    var leftMarginSwap: CGFloat!
    var rightMarginSwap: CGFloat!
    
    var initLeftIconPos: CGPoint!
    var initRightIconPos: CGPoint!
    var leftIconPos: CGPoint!
    var rightIconPos: CGPoint!
    
    var leftCheckPos: CGPoint!
    var leftXPos: CGPoint!
    var rightListPos: CGPoint!
    var rightClockPos: CGPoint!
    
    var leftState: Int! // 1=default, 2=middle, 3=full (left icons)
    var rightState: Int! // 1=default, 2=middle, 3=full (right icons)
    
    var topViewOriginalCenter: CGPoint!
    //var topViewPos: CGPoint!
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    @IBOutlet var leftEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navListButton: UIButton!

    @IBOutlet var rescheduleTapGestureRecognizer: UITapGestureRecognizer!
   
    @IBOutlet var listTapGestureRecognizer: UITapGestureRecognizer!
    
    //vars^--------------------------------------
    
    
    @IBAction func navListButtonAction(sender: UIButton) {
        //get back to feed view after screen edge left to show menu
        topView.center = topViewOriginalCenter
    }
    
    @IBAction func rescheduleTapAction (sender: UITapGestureRecognizer) {
        //print("rescheduleTapAction")
        if sender.state == UIGestureRecognizerState.Ended  { //didn't entered began state
           print("Tap Gesture ended - reschedule/list")
            self.rescheduleImageView.alpha = 0
            self.listImageView.alpha = 0
        }
    }
    
    //created in viewDidLoad
    func onEdgePan (sender: UIScreenEdgePanGestureRecognizer){
        print("screen edge pan!")
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)

        if sender.state == UIGestureRecognizerState.Began
        {
            //print("screen edge BEGAN!")
            topViewOriginalCenter = topView.center //topViewPos = topView.center
        }
        else if sender.state == UIGestureRecognizerState.Changed
        {
            //print("screen edge CHANGED!") //topViewPos = topView.frame.origin
            topView.center = CGPoint(x:topViewOriginalCenter.x + translation.x, y:topViewOriginalCenter.y)
        }
        else if sender.state == UIGestureRecognizerState.Ended
        {
            print("screen edge ENDED! velocity: \(velocity)")
            if velocity.x > 0 { //reveal menu
                
                topView.center = CGPoint(x:topViewOriginalCenter.x + 320, y:topViewOriginalCenter.y)
            }
            else { //return to feed
                topView.center = CGPoint(x:topViewOriginalCenter.x, y:topViewOriginalCenter.y)
            }
            
        }
        
    }
    
    @IBAction func panGestureAction(sender: UIPanGestureRecognizer) {
        //print("panGestureAction") //onCustomPan
        let point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view) //print("translation: \(translation)")
        
        if sender.state == UIGestureRecognizerState.Began
        {
            print("Gesture began at: \(point)")
            //clunky but works *remove*
            messagePos = message.frame.origin
            tapDiff = point.x - message.frame.origin.x
            //print("Diff is : \(tapDiff)")
            //^^NVM! Translation does this for me!
            //singleMsgViewCenter = singleMsgView.center
            
            //new
            messageOriginalCenter = message.center
            
        } else if sender.state == UIGestureRecognizerState.Changed
        {
            //print("leftState \(leftState)")
            //print("rightState \(rightState)")
           
            //moving right
            if velocity.x > 0 {
              //  print("   velocity RIGHT !")
                //clunky but works - revisited
                //message.frame.origin.x = point.x - tapDiff
                //message.frame.origin.x = point.x + translation.x
                //using below instead of this^^
                
                messagePos = message.frame.origin
                message.center = CGPoint(x:messageOriginalCenter.x + translation.x, y:messageOriginalCenter.y)
                if  leftState == 1 && leftBtn_check.alpha < 0.26 {
                    //print("ALPHA IN LEFT ICON, leftState \(leftState)")
                    
                    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        self.leftBtn_check.hidden = false //1st time
                        self.leftBtn_check.alpha = 1.0
                        self.leftState=2
                        
                        }, completion: { (_) -> Void in
                            self.leftState=1
                    })

                }
               
                //set left icon position
                if messagePos.x > leftMargin {
                    leftState = 2
                    //print("messagePos > leftMargin! \(messagePos.x)")
                    // move left icons
                    //leftBtn_check.frame.origin.x = point.x - tapDiff - leftMargin
                    //leftBtn_x.frame.origin.x = leftBtn_check.frame.origin.x
                    //leftIconPos = leftBtn_check.frame.origin
                    
                    //updated w/translate
                    leftBtn_check.center = CGPoint(x:initLeftIconPos.x + translation.x, y: initLeftIconPos.y)
                    leftBtn_x.center = CGPoint(x:initLeftIconPos.x + translation.x, y: initLeftIconPos.y)
                }
                //reset right side state
                else if messagePos.x >= rightMargin {
                    rightState = 1
                    rightBtn_clock.alpha = 0.25
                    singleMsgView.backgroundColor = UIColor.grayColor()
                }
                
                //set bg color & proper icon
                if messagePos.x > leftMargin && messagePos.x <= leftMarginSwap {
                    leftState = 2
                    leftBtn_check.hidden = false
                    leftBtn_x.hidden = true
                    singleMsgView.backgroundColor = UIColor.greenColor()
                }
                else if messagePos.x > leftMarginSwap {
                    //print("messagePos > leftMarginSwap! \(messagePos.x)")
                    leftState = 3
                    leftBtn_check.hidden = true
                    leftBtn_x.hidden = false
                    singleMsgView.backgroundColor = UIColor.redColor()
                }
                
                //move right buttons right
                if messagePos.x < rightMargin {
                    //print("messagePos < rightMargin! \(messagePos.x)")
                    rightBtn_clock.center = CGPoint(x:initRightIconPos.x + translation.x, y: initRightIconPos.y)
                    rightBtn_list.center = CGPoint(x:initRightIconPos.x + translation.x, y: initRightIconPos.y)
                }
                
                //set bg color & proper icon
                if messagePos.x < rightMargin && messagePos.x >= rightMarginSwap {
                    rightState = 2
                    rightBtn_clock.hidden = false
                    rightBtn_list.hidden = true
                    singleMsgView.backgroundColor = UIColor.yellowColor()
                }
                else if messagePos.x < rightMarginSwap {
                    //print("messagePos < rightMarginSwap! \(messagePos.x)")
                    rightState = 3
                    rightBtn_clock.hidden = true
                    rightBtn_list.hidden = false
                    singleMsgView.backgroundColor = UIColor.brownColor()
                }
            }
            //moving left
            else {
                //print("   velocity LEFT !")
                messagePos = message.frame.origin
                message.center = CGPoint(x:messageOriginalCenter.x + translation.x, y:messageOriginalCenter.y)
                
                if  rightState == 1 && rightBtn_clock.alpha < 0.26 {
                    //print("ALPHA IN RIGHT ICON")
                    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        self.rightBtn_clock.hidden = false
                        self.rightBtn_clock.alpha = 1.0
                        self.rightState=2
                        
                        }, completion: { (_) -> Void in
                            self.rightState=1
                    })
                }
                
                //set right icon position
                if messagePos.x < rightMargin {
                    //print("messagePos < rightMargin! \(messagePos.x)")
                    //move right icons. updated w/translate
                    rightBtn_clock.center = CGPoint(x:initRightIconPos.x + translation.x, y: initRightIconPos.y)
                    rightBtn_list.center = CGPoint(x:initRightIconPos.x + translation.x, y: initRightIconPos.y)
                }
                //reset left side state
                else if messagePos.x <= leftMargin {
                    leftState = 1
                    leftBtn_check.alpha = 0.25
                    singleMsgView.backgroundColor = UIColor.grayColor()
                }
                
                //set bg color & proper icon
                if messagePos.x < rightMargin && messagePos.x >= rightMarginSwap {
                    rightState = 2
                    rightBtn_clock.hidden = false
                    rightBtn_list.hidden = true
                    singleMsgView.backgroundColor = UIColor.yellowColor()
                }
                else if messagePos.x < rightMarginSwap {
                    //print("messagePos < rightMarginSwap! \(messagePos.x)")
                    rightState = 3
                    rightBtn_clock.hidden = true
                    rightBtn_list.hidden = false
                    singleMsgView.backgroundColor = UIColor.brownColor()
                }
                
                //move left buttons left
                
                //set icon position
                if messagePos.x > leftMargin {
                    //print("messagePos > leftMargin! \(messagePos.x)")
                    leftBtn_check.center = CGPoint(x:initLeftIconPos.x + translation.x, y: initLeftIconPos.y)
                    leftBtn_x.center = CGPoint(x:initLeftIconPos.x + translation.x, y: initLeftIconPos.y)
                }
                
                //set bg color & proper icon
                if messagePos.x > leftMargin && messagePos.x <= leftMarginSwap {
                    
                    leftState = 2
                    leftBtn_check.hidden = false
                    leftBtn_x.hidden = true
                    singleMsgView.backgroundColor = UIColor.greenColor()
                }
                else if messagePos.x > leftMarginSwap {
                    //print("messagePos > leftMarginSwap! \(messagePos.x)")
                    leftState = 3
                    leftBtn_check.hidden = true
                    leftBtn_x.hidden = false
                    singleMsgView.backgroundColor = UIColor.redColor()
                }
            }
        }
        else if sender.state == UIGestureRecognizerState.Ended
        {
            print("Gesture ended at: \(point)")
            messagePos = message.frame.origin
            //reset
            message.frame.origin = initMessagePos //remove
            //singleMsgView.center = initSingleMsgViewCenter
            
            leftBtn_check.center = initLeftIconPos
            leftBtn_x.center = initLeftIconPos
            rightBtn_list.center = initRightIconPos
            rightBtn_clock.center = initRightIconPos
            
            //hide all icons!
            leftBtn_check.hidden = true
            leftBtn_x.hidden = true
            rightBtn_clock.hidden = true
            rightBtn_list.hidden = true
            
            if leftState == 2 { //animate green off to right
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                        self.message.center = CGPoint(x:self.message.center.x * 3, y:self.message.center.y)
                    }, completion: { (Bool) -> Void in
                        self.singleMsgView.hidden = true
                        self.singleMsgView.backgroundColor = UIColor.grayColor()
                        //print("Hid Message (green)! x \(self.singleMsgView.center.x * 3)")
                })
            }
            else if leftState == 3 { //animate red off to right
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.message.center = CGPoint(x:self.message.center.x * 3, y:self.message.center.y)
                    
                    }, completion: { (Bool) -> Void in
                        self.singleMsgView.hidden = true
                        self.singleMsgView.backgroundColor = UIColor.grayColor()
                        //print("Hid Message (red)! x \(self.singleMsgView.center.x * 3)")
                })
            }
            
            else if rightState == 2 { //animate yellow off to left
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.message.center = CGPoint(
                        x:self.message.center.x * -1.25,
                        y:self.message.center.y)
                    
                    }, completion: { (Bool) -> Void in
                        self.singleMsgView.hidden = true
                        self.singleMsgView.backgroundColor = UIColor.grayColor()
                        //print("Hid Message (yellow)! x \(self.singleMsgView.center.x * -1.25)")
                        
                        //show reschedule menu
                        self.rescheduleImageView.alpha = 1
                        print("showing reschedule view")
                })
                
            }
            else if rightState == 3 { //animate brown off to left
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.message.center = CGPoint(x:self.message.center.x * -1.25, y:self.message.center.y)
                    
                    }, completion: { (Bool) -> Void in
                        self.singleMsgView.hidden = true
                        self.singleMsgView.backgroundColor = UIColor.grayColor()
                        //print("Hid Message (brown)! x \(self.singleMsgView.center.x * -1.25)")
                        
                        //show list menu
                        self.listImageView.alpha = 1
                        print("showing list view")
                        // & disable feed scroll here !
                })
            }
            else {
                singleMsgView.backgroundColor = UIColor.grayColor()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 320, height: 2400)
       
        initMessagePos = message.frame.origin
        singleMsgView.backgroundColor = UIColor.grayColor()
        
        leftBtn_check.alpha = 0.25
        leftBtn_x.hidden = true
        rightBtn_list.hidden = true
        rightBtn_clock.alpha = 0.25
        
        initLeftIconPos = leftBtn_check.center
        initRightIconPos = rightBtn_clock.center
        
        leftMargin = 40
        rightMargin = -40
        leftMarginSwap = 100
        rightMarginSwap = -100
        
        leftState = 1
        rightState = 1
        
        //manually add left screen edge gesture recognizer (created function onEdgePan above)
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        topView.addGestureRecognizer(edgeGesture)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       //x print("scrolling! y: \(self.view feed.frame.y)")
        // This method is called as the user scrolls
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging!")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView,
        willDecelerate decelerate: Bool) {
            print("scrollViewDidEndDragging!")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating!")
    }

    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}
