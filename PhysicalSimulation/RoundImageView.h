//
//  RoundImageView.h
//  PhysicalSimulation
//
//  Created by 王盛魁 on 2017/7/3.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundImageView : UIImageView
// 重写UIDynamicItem 中的属性，处理图形的圆形问题
@property (nonatomic,assign) UIDynamicItemCollisionBoundsType collisionBoundsType;

@end
