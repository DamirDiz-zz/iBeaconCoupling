//
//  CoupleViewController.m
//  iBeaconCoupling
//
//  Created by Damir Dizdarevic on 05.02.14.
//  Copyright (c) 2014 Damir Dizdarevic. All rights reserved.
//

#import "CoupleViewController.h"
#import "CoupleLogic.h"
#import "BeaconDefaults.h"

@interface CoupleViewController ()

@property (strong, nonatomic) CoupleLogic *coupleLogic;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *coupleStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *decoupleButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CoupleViewController

#pragma mark LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[BeaconTracker sharedBeaconTracker] startTrackingBeacons];
    [[BeaconTracker sharedBeaconTracker] addDelegate:self];
    
    [self.decoupleButton setHidden:YES];
    [self.activityIndicator startAnimating];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[BeaconTracker sharedBeaconTracker] removeDelegate:self];
}

#pragma mark BEACONTRACKER

- (void)beaconTrackerUpdated
{
//    CLBeacon *beacon = [[BeaconTracker sharedBeaconTracker] getBeaconWhereUUID:[[BeaconDefaults sharedDefaults] defaultProximityUUID] major:[NSNumber numberWithInt:BEACON_PURPLE_MAJOR] minor:[NSNumber numberWithInt:BEACON_PURPLE_MINOR]];
    CLBeacon *beacon = [[BeaconTracker sharedBeaconTracker] getClosestBeacon];
    
    //COUPLE LOGIC
    
    if(beacon) {
        if(beacon.proximity == CLProximityImmediate) {
            [self couplingRecognizedWithBeacon:beacon];
        }        
    }
}

- (void)beaconTrackerUpdatedWithBeacons:(NSDictionary *)beacons
{
    
}


#pragma mark COUPLING
- (void)couplingRecognizedWithBeacon:(CLBeacon *)beacon
{
    if(self.coupleLogic.isCoupled == NO && self.coupleLogic.isCouplePossible == YES) {
        
        if([self couplePhoneAndServerWithBeacon:beacon]) {
            self.coupleLogic.coupled = YES;
            self.coupleLogic.couplePossible = NO;
            self.coupleLogic.beacon = beacon;
            
            
            self.coupleStatusLabel.text = [NSString stringWithFormat:@"Coupled with Beacon! \n Major: %@ Minor: %@", beacon.major, beacon.minor];
            [self.statusImageView setImage:[UIImage imageNamed:@"iconmonstr-link-4-icon-256"]];
            [self.activityIndicator stopAnimating];
            [self.decoupleButton setHidden:NO];
        }
    }
}

- (IBAction)decouplePressed:(UIButton *)sender
{
    if([self decouplePhoneAndServer]) {
        self.coupleLogic.coupled = NO;
        self.coupleLogic.beacon = NULL;
        self.coupleStatusLabel.text = @"Looking for Beacons";
        [self.activityIndicator startAnimating];
        [self.statusImageView setImage:[UIImage imageNamed:@"iconmonstr-link-5-icon-256"]];
        
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.coupleLogic.couplePossible = YES;
        });
        
        
        [sender setHidden:YES];
    }
}

- (BOOL)couplePhoneAndServerWithBeacon:(CLBeacon *)beacon
{
    NSURL *coupleUrl = [[NSURL alloc] initWithString:@"http://ibeaconcoupling.hostei.com/couplephone.php"];
    
    NSDictionary *responseJSON = [self makeRequestWithURL:coupleUrl andBeacon:beacon];

    NSString *status = responseJSON[@"status"];
    
    if(status) {
        if([status isEqualToString:@"success"]) {
            return YES;
        }
    }

    return FALSE;
}

- (BOOL)decouplePhoneAndServer
{
    NSURL *decoupleUrl = [[NSURL alloc] initWithString:@"http://ibeaconcoupling.hostei.com/decouplephone.php"];

    NSDictionary *responseJSON = [self makeRequestWithURL:decoupleUrl andBeacon:nil];
    
    NSString *status = responseJSON[@"status"];
    
    NSLog(@"%@",status);
    if(status) {
        if([status isEqualToString:@"success"]) {
            return YES;
        }
    }
    
    return FALSE;
}

- (id)makeRequestWithURL:(NSURL *)url andBeacon:(CLBeacon *)beacon
{
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:10];
    
    
    if(beacon != nil) {
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"phoneid=123456789&uuid=%@&major=%@&minor=%@",[beacon.proximityUUID UUIDString], beacon.major,beacon.minor];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    // Fetch the JSON response
    NSData *responseData;
    NSURLResponse *response;
    NSError *error;
    
    
    // Make synchronous request
    responseData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    
    NSError *jsonParsingError = nil;
    id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:0 error:&jsonParsingError];
    
    
    return responseJSON;
}

- (CoupleLogic *)coupleLogic
{
    if(!_coupleLogic) {
        _coupleLogic = [[CoupleLogic alloc] init];
    }
    
    return _coupleLogic;
}

@end
