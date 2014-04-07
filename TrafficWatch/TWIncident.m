//
//  TWIncident.m
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import "TWIncident.h"
#import <CoreLocation/CoreLocation.h>


@implementation TWIncident
    


- (id)initWithTitle:(NSString *)title weblink:(NSString *)weblink summary:(NSString *) summary
{
    self = [super init];
    
    if(self)
    {
        self.title = title;
        self.weblink = weblink;
        self.summary = summary;
        self.distance = 0.0;
    }
    
    return self;
    
}

- (id)init
{
    return [self initWithTitle:@"Unknown Incident" weblink:@"Not available." summary:@
                  "Not available."];
}

- (NSString *)description
{
    NSString *theDescription = [[NSString alloc] initWithFormat:
                                @"< %@: title = %@, weblink = %@, summary = %@ >",
                                NSStringFromClass([self class]), self.title,
                                self.weblink, self.summary];
    return theDescription;
}

- (CLLocation *)currentIncidentlocation
{
    NSArray *items = [self.weblink componentsSeparatedByString:@"&"];
    
    //NSLog(@"weblink=%@",self.weblink);
    
    NSString *lon, *lat;
    
    for (NSString *str in items) {
        
        if ([str hasPrefix:@"lon="]) {
            lon = [str componentsSeparatedByString:@"="][1];
            //NSLog(@"lon=%@",lon);
            
        }
        if ([str hasPrefix:@"lat="]) {
            lat = [str componentsSeparatedByString:@"="][1];
            //NSLog(@"lat=%@",lat);
        }
        
    }
    
    return [[CLLocation alloc] initWithLatitude:[lon doubleValue] longitude:[lat doubleValue]];
    
}


@end
