//
//  TrafficWatchTests.m
//  TrafficWatchTests
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TWIncident.h"

@interface TrafficWatchTests : XCTestCase

@end

@implementation TrafficWatchTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIncidentInit
{
    NSString *title = @"incident";
    NSString *weblink = @"http://test";
    NSString *summary = @"summary";
    
    TWIncident *incident = [[TWIncident alloc] initWithTitle:title weblink:weblink summary:summary];
    
    XCTAssertTrue([incident.title isEqualToString:title], @"title is not correctly initialized");
    
    XCTAssertTrue([incident.weblink isEqualToString:weblink], @"weblink is not correctly initialized");
    
    XCTAssertTrue([incident.summary isEqualToString:summary], @"summary is not correctly initialized");

}

- (void)testIncidentDescription
{
    NSString *title = @"incident";
    NSString *weblink = @"http://test";
    NSString *summary = @"summary";
    
    NSString *theDescription = [[NSString alloc] initWithFormat:
                                @"< %@: title = %@, weblink = %@, summary = %@ >",
                                NSStringFromClass([TWIncident class]), title,
                                weblink, summary];
    
    
    TWIncident *incident = [[TWIncident alloc] initWithTitle:title weblink:weblink summary:summary];
    NSString *incidentDesc = [incident description];
    
    NSLog(@"\nExpected Description:%@\nActual Description:%@", theDescription, incidentDesc);

    
    XCTAssertTrue([incidentDesc isEqualToString:theDescription], @"description method is not correctly implemented");
    
    
    NSString *title2 = @"incidentTwo";
    NSString *weblink2 = @"http://test2";
    NSString *summary2 = @"summary2";
    
    NSString *theDescription2 = [[NSString alloc] initWithFormat:
                                @"< %@: title = %@, weblink = %@, summary = %@ >",
                                NSStringFromClass([TWIncident class]), title2,
                                weblink2, summary2];
    
    
    TWIncident *incident2 = [[TWIncident alloc] initWithTitle:title2 weblink:weblink2 summary:summary2];
    NSString *incidentDesc2 = [incident2 description];
    
    NSLog(@"\nExpected Description:%@\nActual Description:%@", theDescription2, incidentDesc2);

    
    XCTAssertTrue([incidentDesc2 isEqualToString:theDescription2], @"description method is not correctly implemented");
    

}


@end
