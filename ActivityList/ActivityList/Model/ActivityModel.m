//
//  ActivityModel.m
//  ActivityList
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

- (id)initWithDictionary: (NSDictionary *)dict{
//    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]){
//        _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
//    } else {
//        _imgUrl = dict[@"imgURL"];
//    }
    
    self = [super init];
    if (self) {//isKindOfClass:[NSNull class][dict[@"imgURL"] ]
        _imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]]? @"" : dict[@"imgUrl"];
        _name1 = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动名称" : dict[@"name"];
        _content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"活动内容" : dict[@"content"];
        _like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"reliableNumber"] integerValue];
        _unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"unReliableNumber"] integerValue];
        _isFavo = [dict[@"isFavo"] isKindOfClass:[NSNull class]] ? NO : [dict[@"isFavo"] boolValue];
        _activityId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
    }
    return self;
}
- (id)initWithDetialDictionary: (NSDictionary *)dict{
    self = [super init];
    if (self){
        _imgUrl =[Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
        _name1 = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"活动"];
        _content = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@"活动内容"];
        _like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"reliableNumber"] integerValue];
        _unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"unReliableNumber"] integerValue];
        _activityId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""];
        _adress = [Utilities nullAndNilCheck:dict[@"adress"] replaceBy:@""];
        _applyFee = [Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@"0"];
        _limitation = [Utilities nullAndNilCheck:dict[@"attendenceAmount"] replaceBy:@"0"];
        _attendence = [Utilities nullAndNilCheck:dict[@"participantsNumber"] replaceBy:@"0"];
        _type = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@"普通活动"];
        _issuer = [Utilities nullAndNilCheck:dict[@"issuerName"] replaceBy:@"未发布者"];
        _phone = [Utilities nullAndNilCheck:dict[@"issuerPhone"] replaceBy:@"0"];
        _dueTime =[dict[@"applicationExpirationDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"applicationExpirationDate"]integerValue] ;
        _startTime = [dict[@"startDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"startDate"]integerValue];
        _endTime = [dict[@"endDate"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"endDate"]integerValue];
        _status = [dict[@"isFavo"] isKindOfClass:[NSNull class]] ? -1 : [dict[@"isFavo"] integerValue];
        
    }
    return self;

}

@end
