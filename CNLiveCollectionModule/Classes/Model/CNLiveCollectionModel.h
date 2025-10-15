//
//  CNLiveCollectionModel.h
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CNLiveCollectionCellType) {
    CNLiveCollectionCellTextOnly          = 0,
    CNLiveCollectionCellImageOnly         = 1,
    CNLiveCollectionCellImageText         = 2,
    CNLiveCollectionCellVideo             = 3,
};

@interface CNLiveIcon : NSObject 

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *extInfo;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *fansCount;
@property (nonatomic, copy) NSString *orderCount;

@end

@interface CNLiveCollectionModel : NSObject

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *thumbnailPath;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *videoPlayUrl;
@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *collectionType;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, copy) NSMutableAttributedString *title;
@property (nonatomic, copy) NSString *nameTime;

@property (nonatomic, strong) CNLiveIcon *icon;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
