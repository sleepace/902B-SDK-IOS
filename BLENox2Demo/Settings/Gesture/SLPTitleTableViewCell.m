//
//  SLPTitleTableViewCell.m
//  Sleepace
//
//  Created by Shawley on 9/12/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPTitleTableViewCell.h"

@implementation SLPTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = Theme.C3;
    self.titleLabel.font = Theme.T3;
//    [self setDownLineHide:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
