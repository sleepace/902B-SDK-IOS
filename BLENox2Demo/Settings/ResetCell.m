//
//  ResetCell.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/20.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "ResetCell.h"

@interface ResetCell ()


@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation ResetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.resetBtn setTitle:LocalizedString(@"factory_reset") forState:UIControlStateNormal];
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)resetAction:(id)sender {
    if (self.resetBlock) {
        self.resetBlock();
    }
}
@end
