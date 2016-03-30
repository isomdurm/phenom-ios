//
//  TimelineViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
//import AFNetworking


class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var navBarView = UIView()
    private var lastOffsetY : CGFloat = 0
    private var distancePulledDownwards: CGFloat = 0
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    
    var timelineArray = NSMutableArray()
    
    var isPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        self.theTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-20-49)
        //self.theTableView.contentOffset = CGPoint(x: 0, y: 44)
        self.theTableView.backgroundColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:0.5)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: 64+30)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    
        //
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 20))
        statusBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(statusBarView)
        
        //
        
        self.queryForTimeline()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isPushed = false
    }
    
    func queryForTimeline() {
        
        
        
        // end with animation
        
        UIView.animateWithDuration(0.40, delay:2.0, options: .CurveEaseInOut, animations: {
            
            //var tableFrame = self.theTableView.frame
            //tableFrame.origin.y = 64
            //self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                if (finished) {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
        })
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
//        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
//        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        
//        aView.addSubview(aLbl)

        
        
        let headerView = TimelineHeaderView(frame: CGRectMake(0, 0, view.frame.size.width, 64))
        
        headerView.userLbl?.text = "FIRST LAST"
        headerView.timeLbl?.text = "TIME LBL HERE"
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        self.isPushed = false
        
        //
        
        let vc  = DetailViewController()
        vc.isGear = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userBtnAction(sender: UIButton!){
        
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var currentScrollViewRect = scrollView.frame //CGRect
        
        var currentScrollViewOffset = scrollView.contentOffset //CGPoint
        
        let offsetShiftY = self.lastOffsetY - scrollView.contentOffset.y //CGFloat
        
        if (offsetShiftY > 0)
        {
            self.distancePulledDownwards += offsetShiftY;
            
            var wantedOriginY = currentScrollViewRect.origin.y //CGFloat
            if ((scrollView.contentOffset.y<0)  || (currentScrollViewRect.origin.y>20) || (self.distancePulledDownwards > 100)) //|| (self.distancePulledDownwards > SIGNIFICANT_SCROLLING_DISTANCE)
            {
                // shift scroll views frame by offset shift
                wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY
                // compensate that shift by moving content offset back
                currentScrollViewOffset.y += (wantedOriginY <= 64) ? offsetShiftY : 0
                
                
            }
            currentScrollViewRect.origin.y = (wantedOriginY <= 64) ? wantedOriginY : 64
            //currentScrollViewRect.size.height = self.view.frame.size.height-20-49
            
        }
        else
        {
            self.distancePulledDownwards = 0
            
            if (scrollView.contentOffset.y > 0)
            {
                let wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY //CGFloat
                currentScrollViewRect.origin.y = (wantedOriginY >= 20) ? wantedOriginY : 20
                //currentScrollViewRect.size.height = self.view.frame.size.height-20-49
                currentScrollViewOffset.y += (wantedOriginY >= 20) ? offsetShiftY : 0
            }
        }
        
        scrollView.frame = currentScrollViewRect
        scrollView.delegate = nil
        scrollView.contentOffset = currentScrollViewOffset
        scrollView.delegate = self
        
        self.lastOffsetY = scrollView.contentOffset.y
        
        //
        
        var navBarViewFrame = self.navBarView.frame
        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
        self.navBarView.frame = navBarViewFrame
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        print("scrollViewShouldScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = self.navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        self.navBarView.frame = navBarViewFrame
        return true
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = self.navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        self.navBarView.frame = navBarViewFrame
        
    }
    

}
