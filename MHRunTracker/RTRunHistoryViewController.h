//
//  RTRunHistoryViewController.h
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSLocationManager.h"

@interface RTRunHistoryViewController : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) NSArray *healthDataArray;
@property (nonatomic, strong) UITableView *tableView;
@end
