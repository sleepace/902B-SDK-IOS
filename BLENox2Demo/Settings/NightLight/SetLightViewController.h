//
//  SetLightViewController.h
//  BLENox2Demo
//
//  Created by jie yang on 2019/7/30.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "BaseViewController.h"

@protocol SetLightViewControllerDelegate <NSObject>

- (void)colorChangedWithR:(int)r g:(int)g b:(int)b w:(int)w brightness:(int)brightness;

- (void)brightnessChanged:(int)brightness;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SetLightViewController : BaseViewController

@property (nonatomic, weak) id<SetLightViewControllerDelegate> delegate;

@property (nonatomic, assign) int r;
@property (nonatomic, assign) int g;
@property (nonatomic, assign) int b;
@property (nonatomic, assign) int w;
@property (nonatomic, assign) int brightness;

@end

NS_ASSUME_NONNULL_END
