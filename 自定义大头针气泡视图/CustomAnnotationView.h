//
//  CustomAnnotationView.h
//  自定义大头针视图
//
//  Created by 张国兵 on 15/8/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomAnnotation.h"
@interface CustomAnnotationView : MKAnnotationView{
    
    
}
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UIImageView *bankLogo;
@property (nonatomic, retain) UIButton*icon;
@property (nonatomic, copy) void(^DidSelectBlock)(NSString*managerID);
@property (nonatomic, retain) CustomAnnotation*annotationInfo;
-(void)setDataWithAnnotation:(CustomAnnotation*)annotation;
@end
