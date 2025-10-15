//
//  CNLiveCollectionCell.h
//  CNLiveCollectionModule
//
//  Created by CNLive-zxw on 2019/2/26.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kCNLiveCollectionCell @"CNLiveCollectionCell"
@class CNLiveCollectionModel;
@class CNLiveCollectionCell;

@protocol CNLiveCollectionCellDelegate <NSObject>
- (void)cancelCollection:(CNLiveCollectionCell *)cell;

@end
@interface CNLiveCollectionCell : UITableViewCell
@property (nonatomic, strong) CNLiveCollectionModel *model;
@property (nonatomic, weak) id<CNLiveCollectionCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
