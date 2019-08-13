//
//  SetTimeViewController.h
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/30.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "BaseViewController.h"

@protocol SetTimeViewControllerDelegate <NSObject>

- (void)timeChangedWithStartHour:(UInt8)startHour startMinute:(UInt8)startMinute endHour:(UInt8)endHour endMinute:(UInt8)endMinute;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SetTimeViewController : BaseViewController

@property (nonatomic, assign) UInt8 startHour;
@property (nonatomic, assign) UInt8 startMinute;

@property (nonatomic, assign) UInt8 endHour;
@property (nonatomic, assign) UInt8 endMinute;

@property (nonatomic, weak) id<SetTimeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
