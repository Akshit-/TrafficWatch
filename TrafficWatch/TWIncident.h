//
//  TWIncident.h
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface TWIncident : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *weblink;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *icon;

@property (assign, nonatomic) double distance;

- (CLLocation *)currentIncidentlocation;

- (id)initWithTitle:(NSString *)title weblink:(NSString *)weblink summary:(NSString *)
summary;

@end
