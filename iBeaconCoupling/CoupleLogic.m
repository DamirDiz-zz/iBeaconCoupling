//
//  CoupleLogic.m
//  iBeaconCoupling
//
//  Created by Damir Dizdarevic on 05.02.14.
//  Copyright (c) 2014 Damir Dizdarevic. All rights reserved.
//

#import "CoupleLogic.h"

@implementation CoupleLogic

- (instancetype)init
{
    self = [super init];
    
    if(self) {
        self.coupled = NO;
        self.couplePossible = YES;
        self.beacon = NULL;
    }
    
    return self;
}

@end
