//
//  ViewController.m
//  电子书
//
//  Created by 任玉飞 on 15/11/4.
//  Copyright © 2015年 任玉飞. All rights reserved.
//

#import "ViewController.h"
#import "RYFSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RYFSlider *slider = [[RYFSlider alloc]initWithFrame:CGRectMake(100, 100, 100, 20) direction:SliderDirectionHorizonal];
    slider.backgroundColor = [UIColor lightGrayColor];
    slider.maxValue = 3;
    slider.minValue = 1;
    [slider sliderTouchEnd:^(CGFloat value) {
        NSLog(@"滑动了%f",value);
    }];
    [self.view addSubview:slider];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
