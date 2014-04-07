//
//  TWViewController.h
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWIncidentsParserDelegate.h" //It is fine to import a protocol in a header file.
#import <CoreLocation/CoreLocation.h>

@interface TWViewController : UIViewController <TWIncidentsParserDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
