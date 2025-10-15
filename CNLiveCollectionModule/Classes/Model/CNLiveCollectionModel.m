//
//  CNLiveCollectionModel.m
//  CNLiveCollectionModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveCollectionModel.h"
#import "CNLiveBaseKit.h"
#import "CNLiveCommonCategory.h"

@implementation CNLiveCollectionModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"icon" : @"CNLiveIcon"
             };
}

- (CGFloat)height{
    if ([self.type isEqualToString:@"1"]||[self.type isEqualToString:@"2"]||[self.type isEqualToString:@"3"]||[self.type isEqualToString:@"4"]) {
        return 180;
    }
    return 80;
}

- (NSMutableAttributedString *)title{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{ NSFontAttributeName:UIFontCNMake(17), NSParagraphStyleAttributeName:style};
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:[CNTools replaceQQemojiWithCustomText:self.text ? self.text : @""]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text?self.text:@"" attributes:attributes];
    return str;
}

- (NSString *)nameTime{
    NSString *str = [NSString stringWithFormat:@"%ld",self.time];
    NSTimeInterval time = ceil([str doubleValue] / 1000);
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeString = [detaildate shortTimeTextOfDate];
    
    return self.icon == nil ? timeString:[NSString stringWithFormat:@"%@  %@",self.icon.nickName,timeString];
}

- (NSURL *)imageUrl{
    return [NSURL URLWithString:(self.imagePath&&![self.imagePath isEqualToString:@""])?self.imagePath:self.videoImg];
}

@end


@implementation CNLiveIcon

@end
