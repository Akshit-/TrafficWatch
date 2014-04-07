//
//  TWViewController.m
//  TrafficWatch
//
//  Created by Akshit Malhotra on 4/4/14.
//  Copyright (c) 2014 Akshit Malhotra. All rights reserved.
//

#import "TWViewController.h"
#import "TWIncident.h"
#import "TWIncidentsParseOperation.h"
#import "TWIncidentCell.h"
#import <CoreLocation/CoreLocation.h>

@interface TWViewController ()

@property (nonatomic, strong) NSMutableArray *incidents;

//NOTE:Reason for using another array is that while refreshing we re-initialize our
// "incidents" array and there is a possibility that a callback to function "cellForRowAtIndexPath"
// will come and then there will be exception as shown below::
/*Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM objectAtIndex:]: index 4 beyond bounds for empty array'
*/
@property (nonatomic, strong) NSMutableArray *tempIncidents;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;


@end

@implementation TWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    [self.locationManager startUpdatingLocation];
    
    [self setupRefreshControl];
    
    [self.operationQueue cancelAllOperations];

    self.operationQueue = nil;
    
    [self loadIncidentsData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefreshControl
{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
}

- (void) handleRefresh
{

    [self.operationQueue cancelAllOperations];
    
    [self loadIncidentsData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)
indexPath
{
    return 110.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.incidents count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"incidentCell";
    TWIncidentCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             identifier];
    if (cell == nil)
    {
        cell = [[TWIncidentCell alloc] initWithStyle:
                UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    TWIncident *incident = self.incidents[indexPath.row];
    cell.textLabel.text = incident.title;
    cell.detailTextLabel.text = incident.summary;

    if (incident.icon) {
        
        cell.imageView.image = incident.icon;
        
    } else {
        // set default placeholder image while image is being downloaded
        cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            //NSLog(@"%@:%@",incident.title,incident.imageURL);

            // download the image asynchronously
            [self downloadImageWithURL:incident.imageURL completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded) {
                     // change the image in the cell
                     cell.imageView.image = image;
                     
                     // cache the image for use later (when scrolling up)
                     incident.icon = image;
                 }
             }];
        }
    }
    
    
    return cell;
    
}

- (void)loadIncidentsData
{
    
    if (self.operationQueue)
    {
        // download in progress
        return;
    }
    
    
    NSString *incidentsURLString = @"http://www.freiefahrt.info/lmst.de_DE.xml";
    
    NSURL *feedURL = [NSURL URLWithString:incidentsURLString];

    self.tempIncidents = [NSMutableArray array];

    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    
    TWIncidentsParseOperation *parseOperation = [[TWIncidentsParseOperation alloc]
                                                 initWithFeedURL:feedURL delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.operationQueue addOperation:parseOperation];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = [NSURL URLWithString:[self.incidents[indexPath.row] weblink]];
    
    NSLog(@"Opening url: %@",url);
    
    [[UIApplication sharedApplication] openURL:url ];
    
    [self.tableView reloadData];
    
}


- (void)handleLoadedIncidents:(NSArray *)loadedIncidents
{
    if ([loadedIncidents count] > 0)
    {
        [self.tempIncidents addObjectsFromArray:loadedIncidents];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    self.incidents = [self.tempIncidents mutableCopy];
    
    if(TARGET_IPHONE_SIMULATOR || !self.currentLocation){
        //using Mumbai, India as default location.
        self.currentLocation = [[CLLocation alloc] initWithLatitude:19.017615 longitude:72.856164];
    }
    
    NSLog(@"Device Current Location=%f:%f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
    
    for (TWIncident *inc in self.incidents) {
        
        CLLocationDistance distance = [self.currentLocation distanceFromLocation:[inc currentIncidentlocation]];
        inc.distance = distance;

    }
    
    [self sortIncidents];
    
    
    [self.refreshControl endRefreshing];
    
    [self.tableView reloadData];
    
    
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}


- (void)incidentsParseOperation:(TWIncidentsParseOperation *)parseOperation
                       finished:(NSArray *)parsedIncidents
{
    [self performSelectorOnMainThread:@selector(handleLoadedIncidents:) withObject
                                     :parsedIncidents waitUntilDone:NO];
    
    self.operationQueue = nil;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];

}

- (void)sortIncidents
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    [self.incidents sortUsingDescriptors:@[descriptor]];
    
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void) startDownload
{
    
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        TWIncident *incident = [self.incidents objectAtIndex:indexPath.row];
        
        if (!incident.icon)
            // Avoid the app icon download if the app already has an icon
        {
            // download the image asynchronously
            [self downloadImageWithURL:incident.imageURL completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded) {
                     
                     // cache the image for use later (when scrolling up)
                     incident.icon = image;
                 }
             }];
        }
    }
    [self.tableView reloadData];
   
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self startDownload];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startDownload];
}



@end
