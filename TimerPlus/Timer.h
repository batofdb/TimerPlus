//
//  Timer.h
//  TimerPlus
//
//  Created by Francis Bato on 11/28/15.
//  Copyright © 2015 FrancisBato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger sets;
@property (nonatomic) NSMutableArray *exercises;
@property (nonatomic) NSInteger interval_between_reps;
@property (nonatomic) NSInteger interval_between_sets;
@property (nonatomic) NSInteger warmup;
@property (nonatomic) NSInteger cooldown;

@end
