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

@property (weak, nonatomic) IBOutlet UILabel *coupleStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *decoupleButton;

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[BeaconTracker sharedBeaconTracker] removeDelegate:self];
}

#pragma mark BEACONTRACKER

- (void)beaconTrackerUpdated
{
    CLBeacon *purpleBeacon = [[BeaconTracker sharedBeaconTracker] getBeaconWhereUUID:[[BeaconDefaults sharedDefaults] defaultProximityUUID] major:[NSNumber numberWithInt:BEACON_PURPLE_MAJOR] minor:[NSNumber numberWithInt:BEACON_PURPLE_MINOR]];
//    CLBeacon *closestBeacon = [[BeaconTracker sharedBeaconTracker] getClosestBeacon];
    
    NSLog(@"%f", purpleBeacon.accuracy);
    if(purpleBeacon.proximity == CLProximityImmediate) {
        [self couplingRecognizedWithBeacon:purpleBeacon];
    }
}

- (void)beaconTrackerUpdatedWithBeacons:(NSDictionary *)beacons
{
    
}


#pragma mark COUPLING
- (void)couplingRecognizedWithBeacon:(CLBeacon *)beacon
{
    if(self.coupleLogic.isCoupled == NO) {
        
        if([self couplePhoneAndServerWithBeacon:beacon]) {
            self.coupleLogic.coupled = YES;
            self.coupleLogic.beacon = beacon;
            
            self.coupleStatusLabel.text = @"COUPLED";
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
        
        [sender setHidden:YES];
    }
}


- (BOOL)couplePhoneAndServerWithBeacon:(CLBeacon *)beacon
{
    NSURL *coupleUrl = [[NSURL alloc] initWithString:@"http://hieristmeinphpskriptzumcouplen"];
    
    NSDictionary *responseJSON = [self makeRequestWithURL:coupleUrl];

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
    NSURL *decoupleUrl = [[NSURL alloc] initWithString:@"http://hieristmeinphpskriptzumDEcouplen"];

    NSDictionary *responseJSON = [self makeRequestWithURL:decoupleUrl];
    
    NSString *status = responseJSON[@"status"];
    
    if(status) {
        if([status isEqualToString:@"success"]) {
            return YES;
        }
    }
    
    return FALSE;
}


//- (id)makeRequestWithURL:(NSURL *)url
//{
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
//                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
//    
//    // Fetch the JSON response
//    NSData *responseData;
//    NSURLResponse *response;
//    NSError *error;
//    
//    // Make synchronous request
//    responseData = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//    
//    NSError *jsonParsingError = nil;
//    id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
//                                                                 options:0 error:&jsonParsingError];
//    
//    
//    return responseJSON;
//}

- (id)makeRequestWithURL:(NSURL *)url
{
    return  @{ @"status" : @"success" };
}


- (CoupleLogic *)coupleLogic
{
    if(!_coupleLogic) {
        _coupleLogic = [[CoupleLogic alloc] init];
    }
    
    return _coupleLogic;
}

@end