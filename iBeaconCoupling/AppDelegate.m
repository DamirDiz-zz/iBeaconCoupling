//
//  AppDelegate.m
//  iBeaconCoupling
//
//  Created by Damir Dizdarevic on 05.02.14.
//  Copyright (c) 2014 Damir Dizdarevic. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()

@property (strong, readwrite) NSString *phoneID;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"phoneid.txt"];

    NSLog(@"%@", filePath);
    
    NSString *phoneID = nil;
    
    if([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"Loading PhoneID");

        phoneID = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
    } else {
        NSLog(@"Creating PhoneID");

        phoneID = [self genRandStringLength:20];
    
        [fileManager createFileAtPath:filePath contents:[phoneID dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    if(phoneID) {
        self.phoneID = phoneID;
        NSLog(@"PhoneID is %@", phoneID);
    }
    
    // Override point for customization after application launch.
    return YES;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
