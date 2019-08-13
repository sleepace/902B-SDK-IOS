//
//  ResetCell.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/20.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^ResetActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ResetCell : BaseTableViewCell

@property (nonatomic, copy) ResetActionBlock resetBlock;

@end

NS_ASSUME_NONNULL_END
