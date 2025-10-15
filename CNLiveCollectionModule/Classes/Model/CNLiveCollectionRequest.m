//
//  CNLiveCollectionRequest.m
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveCollectionRequest.h"
#import "CNLiveCategory.h"
#import "CNLiveNetworking.h"
#import "CNLiveEnvironment.h"
#import "CNUserInfoManager.h"

#import "CNLiveCollectionModel.h"
#import "MJExtension.h"

@implementation CNLiveCollectionRequest

+ (void)getCollectionList:(NSString *)pageNo pageSize:(NSString *)pageSize block:(CollectionListBlock)block{
    NSDictionary *params = @{
                             @"pageSize":pageSize,
                             @"pageNo":pageNo,
                             @"appId":AppId,
                             @"plat":@"i",
                             @"sid":CNUserShareModel.uid};
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:CNDarenCollectListDataSourceUrl Param:params CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
            NSArray *arr = [CNLiveCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            block?block([errorCode isEqualToString:@"0"], arr, error):@"";
        }else{
            block?block(NO, nil, error):@"";
        }

    }];
    
}

+ (void)cancelCollection:(NSString *)ID block:(CancelCollectionBlock)block{
    NSDictionary *params = @{@"appId":AppId,
                             @"plat":@"i",
                             @"sid":CNUserShareModel.uid,
                             @"collectionId":ID
                             };
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:CNDarenSubsDeleteCollectionUrl Param:params CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
            if ([errorCode isEqualToString:@"0"]) {
                NSArray *array = [ID componentsSeparatedByString:@":h5:"];//将字符串整体作为分割条件 返回值为NSArray不可变数组
                if(array.count == 2){
                    NSDictionary *dic = @{
                                          @"contentId":array[1]?array[1]:@"",
                                          @"selected":@"false",
                                          @"model":@"3_witness"
                                          };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WjjWitnessCollectStatusNotification" object:nil userInfo:dic];
                }
            }
            block([errorCode isEqualToString:@"0"], error);
        }

    }];
}


@end

