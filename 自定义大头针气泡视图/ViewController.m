//
//  ViewController.m
//  自定义大头针气泡视图
//
//  Created by 张国兵 on 15/8/27.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "ViewController2.h"
#import "CustomAnnotation.h"
@interface ViewController ()<MKMapViewDelegate>{
    
    MKMapView*_mapView;//地图
    NSMutableArray *_annotationList;//信贷经理位置
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItem=item;
    self.title=@"系统方法定制气泡";

    /**
     *  自定义大头针气泡视图
     *  简单的气泡视图已经完全满足不了项目的需求
     *  系统的方法使通过leftCalloutAccessoryView和rightCalloutAccessoryView来自定义；
     *  缺点很显然：1、不能设置弹出窗的背景颜色
     *            2、不能设置主标题和副标题的字体大小和颜色
     *            3、只能设置两行标题
     *  简单的还可以但是稍微复杂的话系统的就不够看了，所以我们下一步来讲自定义，移步下一页
     */
    _annotationList = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    _mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    //是否显示用户位置
    _mapView.showsUserLocation=YES;
    //设置跟随模式
    _mapView.userTrackingMode = MKUserTrackingModeNone;
    //设置一下地图的模式
    [_mapView setMapType:MKMapTypeStandard];
    [self.view addSubview:_mapView];
    
    [self getData];

}
#pragma mark-模拟网络数据
-(void)getData{
    
    NSArray*tempArr=@[
                      @{@"latitude":@"116.342178",@"longitude":@"39.947246",@"managerID":@"1",@"name":@"张经理",@"bank":@"中信银行",@"icon":@""},
                      @{@"latitude":@"116.327167",@"longitude":@"39.976996",@"managerID":@"2",@"name":@"刘经理",@"bank":@"中国银行"},
                      @{@"latitude":@"116.332171",@"longitude":@"39.957246",@"managerID":@"3",@"name":@"孙经理",@"bank":@"农商银行"},
                      @{@"latitude":@"116.322148",@"longitude":@"39.967246",@"managerID":@"4",@"name":@"李经理",@"bank":@"浦发银行"}
                      ];
    [_annotationList addObjectsFromArray:tempArr];
    
    [self setAnnotionsWithList:_annotationList];
    
    
}
-(void)setAnnotionsWithList:(NSMutableArray *)list
{
    for(NSDictionary*dic in list){
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([dic[@"longitude"]doubleValue], [dic[@"latitude"]doubleValue]);
        //设置缩放比
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        //生成定位显示
        MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
        //筛选坐标
        if (region.center.latitude>90||region.center.longitude>180) {
            
            continue;
        }
        
        //确定位置
        [_mapView setRegion:region];
        
        //大头针
        CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
        annotation.coordinate = coord;
        annotation.title = dic[@"name"];
        annotation.subtitle = dic[@"bank"];
        annotation.managerID=dic[@"managerID"];
        annotation.bankLogo=dic[@"bankLogo"];
        annotation.icon=dic[@"icon"];
        [_mapView addAnnotation:annotation];
        
        
    };
    
    
}
////原生的,记返回值
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    CustomAnnotation*point=(CustomAnnotation*)annotation;
    //方法中类似tableView定制，先查看复用
    MKAnnotationView*annotationView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    //如果没有就创建
    if (!annotationView) {
        
        annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ID"];
        
    }

        annotationView.image=[UIImage imageNamed:@"anjuke_icon_itis_position"];
        UIButton*leftView=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setBackgroundImage:[UIImage imageNamed:@"mapcalloutview"] forState:UIControlStateNormal];
        leftView.frame=CGRectMake(0, 0, 35, 35);
        leftView.clipsToBounds=YES;
        leftView.layer.borderColor=[UIColor redColor].CGColor;
        leftView.layer.borderWidth=1.0f;
        leftView.layer.cornerRadius=15;
        [leftView setImage:[UIImage imageNamed:@"t016a1b59d7bcd6cc2f"] forState:UIControlStateNormal];
    
        UIView*rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
        UIButton*rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame=CGRectMake(45, 13.5-4, 8, 13);
        [rightBtn setImage:[UIImage imageNamed:@"未标题-1_05"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag=[point.managerID integerValue];
        [rightView addSubview:rightBtn];
        //银行
        UIImageView*bankLogo=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 15, 15)];
        bankLogo.image=[UIImage imageNamed:@"logo2"];
        [rightView addSubview:bankLogo];
        //右边图像
        annotationView.leftCalloutAccessoryView =leftView;
        annotationView.rightCalloutAccessoryView=rightView;
        //定义大头针可以显示点击出来的气泡
        annotationView.canShowCallout=YES;
        annotationView.userInteractionEnabled=YES;
        return annotationView;
   

}
-(void)buttonClick:(UIButton*)btn{
    
     NSLog(@"选中%ld",(long)btn.tag);
    
}
#pragma mark-取消选中
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"取消选中");
    

}
#pragma mark-选中
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //选中的时候视图居中
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
   
    
}

#pragma mark-改变跟随模式
-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    
    
    
}
#pragma mark-下一页
-(void)next{
    
    ViewController2*vc=[[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
