//
//  UserModel.h
//  ActivityList
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong,nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *dob;            //生日
@property (strong, nonatomic) NSString *idCardNo;
@property (strong, nonatomic) NSString *gender;         //性别
@property (strong, nonatomic) NSString *credit;         //积分
@property (strong, nonatomic) NSString *avatarUrl;      //头像
@property (strong, nonatomic) NSString *tokenKey;


- (id)initWithDictionary: (NSDictionary *)dict;
@end
