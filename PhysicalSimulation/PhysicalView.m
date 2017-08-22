//
//  PhysicalView.m
//  PhysicalSimulation
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "PhysicalView.h"
#import <CoreMotion/CoreMotion.h>
#import "RoundImageView.h"

@interface PhysicalView ()
@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator; // 物理仿真器
@property (nonatomic,strong) UIGravityBehavior *gravity; // 重力行为
@property (nonatomic,strong) UICollisionBehavior *collision;// 碰撞行为
@property (nonatomic,strong) CMMotionManager *motionManager; // 陀螺仪等

@end

@implementation PhysicalView
// 懒加载-- 创建物理仿真器
- (UIDynamicAnimator *)dynamicAnimator{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _dynamicAnimator;
}
// 懒加载-- 创建陀螺仪对象
- (CMMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc]init];
    }
    return _motionManager;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    if (dataArray && _dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [self creatImageViewArrayWithDataArray:_dataArray];
}
- (void)creatImageViewArrayWithDataArray:(NSArray *)dataArray{
    // 重力
    self.gravity = [[UIGravityBehavior alloc]init]; // 初始化重力行为
    // 碰撞
    self.collision = [[UICollisionBehavior alloc]init]; // 初始化碰撞行为
    self.collision.translatesReferenceBoundsIntoBoundary = YES; // 以参照视图作为碰撞行为的边界
    // 也可以自定义碰撞行为的边界
    /*
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(self.bounds.size.width, 0);
    CGPoint point3 = CGPointMake(self.bounds.size.width,self.bounds.size.height);
    CGPoint point4 = CGPointMake(0,self.bounds.size.height);
    [self.collision addBoundaryWithIdentifier:@"line1" fromPoint:point1 toPoint:point2];
    [self.collision addBoundaryWithIdentifier:@"line2" fromPoint:point2 toPoint:point3];
    [self.collision addBoundaryWithIdentifier:@"line3" fromPoint:point3 toPoint:point4];
    [self.collision addBoundaryWithIdentifier:@"line4" fromPoint:point4 toPoint:point1];
     */
    // 创建圆球，并将圆球添加到重力行为以及碰撞行为中
    for (int i = 0; i<dataArray.count; i++) {
        CGFloat x = i*15;
        CGFloat y = 0;
        RoundImageView *imageView = [[RoundImageView alloc]initWithFrame:CGRectMake(x, y, 30, 30)];
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor =  [UIColor colorWithRed:arc4random() % 256/255.0 green:arc4random() % 256/255.0 blue:arc4random() % 256/255.0 alpha:0.5];
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;
        imageView.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
        [self addSubview:imageView];
        [self.gravity addItem:imageView];
        [self.collision addItem:imageView];
    }
    [self getDataDeviceMotion];
}
#pragma mark - CMMotionManager
// 获取当前设备的运动参数，并根据获取的参数进行重力行为方向的设定
- (void)getDataDeviceMotion{
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager setDeviceMotionUpdateInterval:1/60];
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]    withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                if (!error) {
                    double X = motion.gravity.x;
                    double Y = motion.gravity.y;
                    double Z = motion.gravity.z;
                    // 在设定完重力方向之后，需要将重力行为、碰撞行为添加到物理仿真器中
                    self.gravity.gravityDirection = CGVectorMake(2*X, -2*Y);
                    [self.dynamicAnimator addBehavior:self.gravity];
                    [self.dynamicAnimator addBehavior:self.collision];
                }else{
                    [self.motionManager stopDeviceMotionUpdates];
                }
        }];
    }else{
        // 在设定完重力方向之后，需要将重力行为、碰撞行为添加到物理仿真器中
        self.gravity.gravityDirection = CGVectorMake(0, 1);
        [self.dynamicAnimator addBehavior:self.gravity];
        [self.dynamicAnimator addBehavior:self.collision];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
