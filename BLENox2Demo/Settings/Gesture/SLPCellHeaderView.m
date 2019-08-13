//
//  SLPCellHeaderView.m
//  Sleepace
//
//  Created by jie yang on 2017/8/4.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "SLPCellHeaderView.h"

@implementation SLPCellHeaderView

+ (instancetype)loadFormNib
{
    return [[NSBundle mainBundle] loadNibNamed:@"SLPCellHeaderView" owner:nil options:nil][0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
