//
//  CNLiveCollectionModule.m
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveCollectionModule.h"
#import "CNLiveServices.h"

@BeeHiveMod(CNLiveCollectionModule)
@interface CNLiveCollectionModule()<BHModuleProtocol>

@end

@implementation CNLiveCollectionModule
- (id)init {
    if (self = [super init]) {
        
    }
    return self;
    
}

- (NSUInteger)moduleLevel {
    return 0;
    
}

- (void)modSetUp:(BHContext *)context {
    switch (context.env) {
        case BHEnvironmentDev:
            //....初始化开发环境
            break;
        case BHEnvironmentProd:
            //....初始化生产环境
        default:
            break;
    }
    
}

- (void)modInit:(BHContext *)context {
    
}

@end
