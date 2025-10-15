//
//  CNLiveQrCodeService.m
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveCollectionService.h"
#import "CNLiveServices.h"

#import "CNLiveManager.h"

#import "CNLiveCollectionController.h"

@BeeHiveService(CNLiveCollectionServiceProtocol,CNLiveCollectionService)
@interface CNLiveCollectionService ()<CNLiveCollectionServiceProtocol>

@end

@implementation CNLiveCollectionService

- (UIViewController *)getCollectionViewController {
    return [CNLiveCollectionController new];
}

- (void)pushToCollectionViewController{
    CNLiveCollectionController *vc = [[CNLiveCollectionController alloc]init];
    [CNLivePageJumpManager jumpViewController:vc];
}

@end
