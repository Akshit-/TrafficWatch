//
//  TWIncidentsParserDelegate.h
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWIncident, TWIncidentsParseOperation;

@protocol TWIncidentsParserDelegate <NSObject>

@optional

- (void)incidentsParseOperation:(TWIncidentsParseOperation *)parseOperation finished:(NSArray *)parsedIncidents;

@end
