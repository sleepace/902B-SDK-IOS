//
//  SLPTitleImageCell.m
//  Sleepace
//
//  Created by Shawley on 8/16/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPTitleImageCell.h"

@implementation SLPTitleImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.icon setImage:[UIImage imageNamed:@"device_icon_choice.png"]];
    self.titleLabel.font = Theme.T3;
    self.titleLabel.textColor = Theme.C3;
//    [self.lineDownHeight setConstant:SLPThemeFrame.lineHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
