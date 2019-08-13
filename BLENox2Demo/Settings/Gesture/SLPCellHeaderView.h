//
//  SLPCellHeaderView.h
//  Sleepace
//
//  Created by jie yang on 2017/8/4.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPCellHeaderView : UIView

+ (instancetype)loadFormNib;

@property (weak, nonatomic) IBOutlet UIImageView *img_product;


@property (weak, nonatomic) IBOutlet UIImageView *img_icon;


@end
