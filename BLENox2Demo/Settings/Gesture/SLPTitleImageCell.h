//
//  SLPTitleImageCell.h
//  Sleepace
//
//  Created by Shawley on 8/16/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SLPTitleImageCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@end
