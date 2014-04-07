//
//  TWIncidentsParser.h
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWIncidentsParserDelegate.h"

@interface TWIncidentsParseOperation : NSOperation <NSXMLParserDelegate>

@property (nonatomic, weak) id<TWIncidentsParserDelegate> delegate;

@property (strong, nonatomic)NSURL *feedurl;
@property (strong, nonatomic)NSMutableArray *parsedIncidentObjects;

- (id)initWithFeedURL:(NSURL *)url delegate:(id <TWIncidentsParserDelegate>)delegate;

@end
