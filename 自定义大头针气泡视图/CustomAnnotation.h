//
//  CustomAnnotation.h
//  自定义大头针视图
//
//  Created by 张国兵 on 15/8/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CustomAnnotation : NSObject<MKAnnotation>{
    
    
}
/**
 *  姓名（required）
 */
@property (nonatomic, copy) NSString *title;
/**
 *  银行（required）
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  大头针坐标（required）
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  用户头像（optional）
 */
@property (nonatomic, copy)   NSString*icon;
/**
 *  银行logo（optional）
 */
@property (nonatomic, copy)   NSString*bankLogo;
/**
 *  信贷经理唯一标示（optional）
 */
@property (nonatomic, copy)   NSString*managerID;

@end
