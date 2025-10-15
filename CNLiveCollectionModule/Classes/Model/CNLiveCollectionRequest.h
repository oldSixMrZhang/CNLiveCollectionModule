//
//  CNLiveCollectionRequest.h
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CollectionListBlock)(BOOL isSuccess, NSArray *array, NSError *error);
typedef void(^CancelCollectionBlock)(BOOL isSuccess, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveCollectionRequest : NSObject

+ (void)getCollectionList:(NSString *)pageNo pageSize:(NSString *)pageSize block:(CollectionListBlock)block;

+ (void)cancelCollection:(NSString *)ID block:(CancelCollectionBlock)block;

@end

NS_ASSUME_NONNULL_END
