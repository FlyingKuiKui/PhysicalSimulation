//
//  PhysicalView.m
//  PhysicalSimulation
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "PhysicalView.h"
#import <CoreMotion/CoreMotion.h>

@interface PhysicalView ()
@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator; // 物理仿真器
@property (nonatomic,strong) UIGravityBehavior *gravity; // 重力行为
@property (nonatomic,strong) UICollisionBehavior *collision;// 碰撞行为
@property (nonatomic,strong) CMMotionManager *mManager;

@end

@implementation PhysicalView
- (UIDynamicAnimator *)dynamicAnimator{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _dynamicAnimator;
}
- (CMMotionManager *)mManager{
    if (!_mManager) {
        _mManager = [[CMMotionManager alloc]init];
    }
    return _mManager;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self.mManager startMagnetometerUpdates];
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
    self.gravity = [[UIGravityBehavior alloc]init];
    // 碰撞
    self.collision = [[UICollisionBehavior alloc]init];
    self.collision.translatesReferenceBoundsIntoBoundary = YES; // 以参照视图作为边界
    // 自定义边界
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
    for (int i = 0; i<dataArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 30, 30)];
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor =  [UIColor colorWithRed:arc4random() % 256/255.0 green:arc4random() % 256/255.0 blue:arc4random() % 256/255.0 alpha:0.5];
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;
        [self addSubview:imageView];
        [self.gravity addItem:imageView];
        [self.collision addItem:imageView];
    }
    [self addSomeBehavior];
}
- (void)addSomeBehavior{
    self.gravity.gravityDirection = CGVectorMake(-1, -1);
    [self.dynamicAnimator addBehavior:self.gravity];
    [self.dynamicAnimator addBehavior:self.collision];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end