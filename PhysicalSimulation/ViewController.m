//
//  ViewController.m
//  PhysicalSimulation
//
//  Created by 王盛魁 on 2017/6/29.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "ViewController.h"
#import "PhysicalView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PhysicalView *view = [[PhysicalView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
    view.dataArray = @[@"1",@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5"];
    [self.view addSubview:view];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
