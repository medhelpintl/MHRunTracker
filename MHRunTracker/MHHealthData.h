//
//  MHHealthData.h
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHealthData : NSObject
@property (nonatomic, strong) NSString *healthDataID;
@property (nonatomic, strong) NSString *dataType;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@end
