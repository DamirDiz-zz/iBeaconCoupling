//
//  CoupleLogic.h
//  iBeaconCoupling
//
//  Created by Damir Dizdarevic on 05.02.14.
//  Copyright (c) 2014 Damir Dizdarevic. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface CoupleLogic : NSObject

@property (nonatomic, getter = isCouplePossible) BOOL couplePossible;
@property (nonatomic, getter = isCoupled) BOOL coupled;
@property (nonatomic, strong) CLBeacon *beacon;

@end
