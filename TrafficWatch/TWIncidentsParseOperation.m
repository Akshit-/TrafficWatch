//
//  TWIncidentsParser.m
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import "TWIncidentsParseOperation.h"
#import "TWIncident.h"

//these are private variables
@interface TWIncidentsParseOperation ()

@property (nonatomic, strong) TWIncident *currentIncidentObject;
@property (nonatomic, strong) NSMutableString *contentOfCurrentIncidentProperty;

@end

@implementation TWIncidentsParseOperation


- (id)initWithFeedURL:(NSURL *)url delegate:(id <TWIncidentsParserDelegate>)delegate
{
    self = [super init];
    
    if(self)
    {
        self.feedurl = url;
        self.delegate = delegate;
        self.parsedIncidentObjects = [NSMutableArray array];
    }
    
    return self;
    
}


- (void)main
{
    
    self.parsedIncidentObjects = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL: self.feedurl];
    
    if (parser)
    {
        parser.delegate = self;
        parser.shouldProcessNamespaces = NO;
        parser.shouldReportNamespacePrefixes = NO;
        parser.shouldResolveExternalEntities = NO;
        
        [parser parse];
        
    }
    
    if (![self isCancelled])
    {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(incidentsParseOperation:finished:)])
        {
            [self.delegate incidentsParseOperation:self finished:self.parsedIncidentObjects];
            
        }
        
    }
    
    
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(
    NSDictionary *)attributeDict
{
    
    if (qName)
    {
        elementName = qName;
        
    }
    
    if ([elementName isEqualToString:@"entry"])
    {
        // An entry in the RSS feed represents an incident, so create an instance of it.
        self.currentIncidentObject = [[TWIncident alloc] init];
        return;
    }
    
    if ([elementName isEqualToString:@"link"])
    {
        NSString *relAtt = attributeDict[@"rel"];
        
        if ([relAtt isEqualToString:@"alternate"])
        {
            NSString *link = attributeDict[@"href"];
            self.currentIncidentObject.weblink = link;
            
        }
    }
    else if ([elementName isEqualToString:@"title"])
    {
        // Create a mutable string to hold the contents of the ’title’ element
        
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentIncidentProperty = [NSMutableString string];
        
        
    }
    else if ([elementName isEqualToString:@"summary"])
    {
        // Create a mutable string to hold the contents of the ’summary’ element
        
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentIncidentProperty = [NSMutableString string];
        
        
    }
    else if ([elementName isEqualToString:@"content"])
    {
        // Create a mutable string to hold the contents of the ’summary’ element
        
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentIncidentProperty = [NSMutableString string];
        return;
        
    }
    else if([elementName isEqualToString:@"img"]) {
        //[attributeDict objectForKey:@"src"]
        self.currentIncidentObject.imageURL = [NSURL URLWithString:[attributeDict objectForKey:@"src"]];
        
    }
    else
    {
        // The element isn’t one that we care about, so set the property that holds the
        // character content of the current element to nil. That way, in the parser:foundCharacters:
        // callback, the string that the parser reports will be ignored.
        self.contentOfCurrentIncidentProperty = nil;
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if (self.contentOfCurrentIncidentProperty)
    {
        //If the current element is one whose content we care about, append ’string'
        // to the property that holds the content of the current element.
        
        [self.contentOfCurrentIncidentProperty appendString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if (qName)
    {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"entry"])
    {
        [self.parsedIncidentObjects addObject:self.currentIncidentObject];
        self.currentIncidentObject = nil;
    }
    if ([elementName isEqualToString:@"title"])
    {
        self.currentIncidentObject.title = self.contentOfCurrentIncidentProperty;
        
    }
    if ([elementName isEqualToString:@"summary"])
    {
        self.currentIncidentObject.summary = self.contentOfCurrentIncidentProperty;
        
    }
    
}

@end
