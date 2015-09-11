//
//  ViewController2.m
//  自定义大头针气泡视图
//
//  Created by 张国兵 on 15/8/27.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "ViewController2.h"
#import <MapKit/MapKit.h>
#import "ViewController2.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "BaseAnnotation.h"
@interface ViewController2 ()<MKMapViewDelegate>{
    
    MKMapView*_mapView;//地图
    NSMutableArray *_annotationList;//信贷经理位置
    CustomAnnotation *_CustomAnnotation;//临时接收位（空瓶）
    
}

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"完全自定义弹出气泡";
    /**
     * 完全自定义弹出气泡
     * 原理：与其说是自定义气泡视图不如说是两种样式大头针的切换
     * 1、首先我们需要一个全局的大头针类型是我们自定义好的那个，这个大头针的坐标要保持和我们点击项的坐标是一致的
     * 2、一开始都是基本大头针当我们点击的时候，若果没有自定义大头针就创建一个并赋值坐标系;
         如果我们点击的存在大头针但是点击的不是自定义类型的大头针，需要把全局的大头针的坐标系换成我们点击的大头针的坐标系，造成一个假象好像使我们的弹出气泡;
         如果存在自定义大头针并且我们点击也是自定义类型的大头针这时候需要移除自定义大头针
     * 3、基本原理就是这样目前还是没有找到能够直接改变弹出视图的方案 如果有的话我再补充
     *
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
                      @{@"latitude":@"116.342178",@"longitude":@"39.947246",@"managerID":@"1",@"name":@"张经理",@"bank":@"中信银行",@"icon":@"t016a1b59d7bcd6cc2f",@"bankLogo":@"logo2"},
                      @{@"latitude":@"116.327167",@"longitude":@"39.976996",@"managerID":@"2",@"name":@"刘经理",@"bank":@"中国银行",@"icon":@"t016a1b59d7bcd6cc2f",@"bankLogo":@"logo1"},
                      @{@"latitude":@"116.332171",@"longitude":@"39.957246",@"managerID":@"3",@"name":@"孙经理",@"bank":@"农商银行",@"icon":@"t016a1b59d7bcd6cc2f",@"bankLogo":@"logo2"},
                      @{@"latitude":@"116.322148",@"longitude":@"39.967246",@"managerID":@"4",@"name":@"李经理",@"bank":@"浦发银行",@"icon":@"t016a1b59d7bcd6cc2f",@"bankLogo":@"logo1"}
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
        BaseAnnotation*annotation = [[BaseAnnotation alloc] init];
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
    static NSString* ID_one=@"custom";
    static NSString* ID_two=@"base";
 if ([annotation isKindOfClass:[CustomAnnotation class]]) {
    //方法中类似tableView定制，先查看复用
    
     CustomAnnotation*tempAnnotation=(CustomAnnotation*)annotation;
     
     CustomAnnotationView*annotationView=(CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:ID_one];
    //如果没有就创建
    if (!annotationView) {
        
        annotationView=[[CustomAnnotationView alloc]initWithAnnotation:_CustomAnnotation reuseIdentifier:ID_one];
        
    }
    [annotationView setDataWithAnnotation:tempAnnotation];
    [annotationView setDidSelectBlock:^(NSString *managerID) {
        NSLog(@"managerID---->%@",managerID);
    }];
    return annotationView;
    
 }else if ([annotation isKindOfClass:[BaseAnnotation class]]) {
     
     MKAnnotationView*annotationView=(MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:ID_two];
     //如果没有就创建
     if (!annotationView) {
         
         annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID_two];
         
     }
     annotationView.image=[UIImage imageNamed:@"anjuke_icon_itis_position.png"];
 
     return annotationView;
     
 }
     return nil;
    
}
#pragma mark-取消选中态
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //如果取消选中的是自定义大头针就移除自定义大头针
    if (_CustomAnnotation&& ![view isKindOfClass:[CustomAnnotationView class]]) {
        if (_CustomAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _CustomAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_CustomAnnotation];
            _CustomAnnotation = nil;
        }
    }

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[BaseAnnotation class]]) {//如果大头针类型是基本类型
        BaseAnnotation*tempAnnotation=(BaseAnnotation*)view.annotation;
        //点击之前初始化之前的数据清空目前的展示气泡
        if (_CustomAnnotation) {
            [mapView removeAnnotation:_CustomAnnotation];
            _CustomAnnotation = nil;
        }
        //借鉴别人的代码思路暂时搞不清楚这段代码的实际意义注掉完全没有影响，字面上意思就是我们的“空瓶”坐标是当前的坐标的话不执行下面的代码
        if (_CustomAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _CustomAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        _CustomAnnotation=[[CustomAnnotation alloc]init];
        _CustomAnnotation.coordinate = tempAnnotation.coordinate;
        _CustomAnnotation.title = tempAnnotation.title;
        _CustomAnnotation.subtitle = tempAnnotation.subtitle;
        _CustomAnnotation.managerID=tempAnnotation.managerID;
        _CustomAnnotation.bankLogo=tempAnnotation.bankLogo;
        _CustomAnnotation.icon=tempAnnotation.icon;
        [mapView addAnnotation:_CustomAnnotation];
        [mapView setCenterCoordinate:_CustomAnnotation.coordinate animated:YES];
    }else if  ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        
        CustomAnnotation*tempAnnotation=(CustomAnnotation*)view.annotation;
        NSLog(@"managerID   is  %@",tempAnnotation.managerID);
        
        
        
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
