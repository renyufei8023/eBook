//
//  RYFSlider.h
//  电子书
//
//  Created by 任玉飞 on 15/11/4.
//  Copyright © 2015年 任玉飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchStateEnd) (CGFloat);
typedef void (^TouchStateChanged) (CGFloat);

typedef enum : NSUInteger {
    SliderDirectionHorizonal = 0,
    SliderDirectionVertical,
} SliderDirection;

@interface RYFSlider : UIControl

@property(nonatomic, assign) CGFloat minValue;
@property(nonatomic, assign) CGFloat maxValue;
@property(nonatomic, assign) CGFloat value;
@property(nonatomic, assign) CGFloat ratioNum;
@property(nonatomic, assign) SliderDirection direction;
@property (nonatomic, copy) TouchStateEnd stateEnd;
@property (nonatomic, copy) TouchStateChanged stateChangerd;

- (instancetype)initWithFrame:(CGRect)frame direction:(SliderDirection)direction;

- (void)sliderChange:(TouchStateChanged)didChangeBlock;

- (void)sliderTouchEnd:(TouchStateEnd)touchEndBlock;

@end
