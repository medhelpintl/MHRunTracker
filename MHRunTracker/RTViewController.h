//
//  RTViewController.h
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSLocationManager.h"

@interface RTViewController : UIViewController <PSLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UILabel *totalDistanceLbl;
@end
