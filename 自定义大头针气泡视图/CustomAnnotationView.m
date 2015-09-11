//
//  CustomAnnotationView.m
//  自定义大头针视图
//
//  Created by 张国兵 on 15/8/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//
#define AnnotationViewStandardWidth     130.0f
#define AnnotationViewStandardHeight    45.0f
#define AnnotationViewVerticalOffset    34.0f
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //该属性决定气泡是否弹出
        self.canShowCallout = NO;
        self.userInteractionEnabled=YES;
        self.frame = CGRectMake(0, 0, AnnotationViewStandardWidth, AnnotationViewStandardHeight);
        self.centerOffset = CGPointMake(0, -AnnotationViewVerticalOffset);
        [self createUI];
    }
    return self;
}
#pragma mark-创建UI
-(void)createUI{

    self.bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AnnotationViewStandardWidth, AnnotationViewStandardHeight)];
    self.bgImageView.userInteractionEnabled=YES;
    self.bgImageView.image=[UIImage imageNamed:@"mapcalloutview"];
    [self addSubview:self.bgImageView];
    //
    self.icon=[UIButton buttonWithType:UIButtonTypeCustom];
    self.icon.frame=CGRectMake(5, 5, 28, 28);
    self.icon.layer.cornerRadius=14;
    self.icon.clipsToBounds=YES;
    [self.icon setImage:[UIImage imageNamed:@"t016a1b59d7bcd6cc2f"] forState:UIControlStateNormal];
    self.icon.layer.borderColor=[UIColor orangeColor].CGColor;
    self.icon.layer.borderWidth=1;
    [self.bgImageView addSubview:self.icon];
    //姓名
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+5, self.icon.frame.origin.y, 40, 18)];
    self.nameLabel.font=[UIFont systemFontOfSize:15];
    self.nameLabel.adjustsFontSizeToFitWidth=YES;
    self.nameLabel.textColor=[UIColor lightGrayColor];
    self.nameLabel.text=@"张经理";
    [self.bgImageView addSubview:self.nameLabel];
    //银行
    self.bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+5, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height, 40, 15)];
    self.bankLabel.adjustsFontSizeToFitWidth=YES;
    self.bankLabel.font=[UIFont systemFontOfSize:13];
    self.bankLabel.textColor=[UIColor orangeColor];
    self.bankLabel.text=@"中信银行";
    [self.bgImageView addSubview:self.bankLabel];
    //银行logo
    self.bankLogo=[[UIImageView alloc]initWithFrame:CGRectMake(self.bankLabel.frame.origin.x+self.bankLabel.frame.size.width+5, self.bankLabel.frame.origin.y, 13, 13)];
    self.bankLogo.contentMode=UIViewContentModeScaleAspectFit;
    self.bankLogo.image=[UIImage imageNamed:@"logo1"];
    [self.bgImageView addSubview:self.bankLogo];
    //箭头
    UIButton*arrow=[UIButton buttonWithType:UIButtonTypeCustom];
    arrow.frame=CGRectMake(130-20, 12, 7, 13);
    [arrow setImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
    [arrow addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:arrow];
    
    UIButton*clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame=CGRectMake(130-50,0,50,40);
    [clearBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:clearBtn];
   
}
#pragma mark-设置
-(void)setDataWithAnnotation:(CustomAnnotation *)annotation{

    self.annotationInfo=annotation;
   [self.icon setBackgroundImage:[UIImage imageNamed:annotation.icon] forState:UIControlStateNormal];
    self.nameLabel.text=annotation.title;
    self.bankLabel.text=annotation.subtitle;
    self.bankLogo.image=[UIImage imageNamed:annotation.bankLogo];
    [self.icon setImage:[UIImage imageNamed:annotation.icon] forState:UIControlStateNormal];
    
    
}

#pragma mark-点击
-(void)buttonClick:(UIButton*)btn{
    
    self.DidSelectBlock(self.annotationInfo.managerID);
    
}
@end
