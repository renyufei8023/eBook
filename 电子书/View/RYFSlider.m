//
//  RYFSlider.m
//  电子书
//
//  Created by 任玉飞 on 15/11/4.
//  Copyright © 2015年 任玉飞. All rights reserved.
//

#import "RYFSlider.h"

@interface RYFSlider ()

@property (nonatomic, strong) UIColor *lineColor;//整条线的颜色
@property (nonatomic, strong) UIColor *slidedLineColor;//滑动过的线的颜色
@property (nonatomic, strong) UIColor *circleColor;//圆的颜色

@property (nonatomic, assign) CGFloat lineWidth;//线的宽度
@property (nonatomic, assign) CGFloat circleRadius;//圆的半径
@property (nonatomic, assign) BOOL    isSliding;//是否正在滑动

@end

@implementation RYFSlider

- (instancetype)initWithFrame:(CGRect)frame direction:(SliderDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _maxValue = 0;
        _minValue = 1;
        
        _direction = direction;
        
        _lineColor = [UIColor whiteColor];
        _slidedLineColor = [UIColor redColor];
        _circleColor = [UIColor whiteColor];
        
        _ratioNum = 0.0;
        _lineWidth = 1;
        _circleRadius = 10;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //画总体的线
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    
    CGFloat startLineX = (_direction == SliderDirectionHorizonal ? _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat startLineY = (_direction == SliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : _circleRadius);//起点
    
    CGFloat endLineX = (_direction == SliderDirectionHorizonal ? self.frame.size.width - _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat endLineY = (_direction == SliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : self.frame.size.height- _circleRadius);//终点
    
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, endLineX, endLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    
    //画已滑动进度的线
    CGContextSetStrokeColorWithColor(context, _slidedLineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    
    CGFloat slidedLineX = (_direction == SliderDirectionHorizonal ? MAX(_circleRadius, (_ratioNum * self.frame.size.width - _circleRadius)) : startLineX);
    
    CGFloat slidedLineY = (_direction == SliderDirectionHorizonal ? startLineY : MAX(_circleRadius, (_ratioNum * self.frame.size.height - _circleRadius)));
    
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, slidedLineX, slidedLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //外层圆
    CGFloat penWidth = 1.f;
    CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, penWidth);//线的宽度
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
    
    CGContextSetShadow(context, CGSizeMake(1, 1), 1.f);//阴影
    
    CGFloat circleX = (_direction == SliderDirectionHorizonal ? MAX(_circleRadius + penWidth, slidedLineX - penWidth ) : startLineX);
    CGFloat circleY = (_direction == SliderDirectionHorizonal ? startLineY : MAX(_circleRadius + penWidth, slidedLineY - penWidth));
    CGContextAddArc(context, circleX, circleY, _circleRadius, 0, 2 * M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    
    //内层圆
    CGContextSetStrokeColorWithColor(context, nil);
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, _circleColor.CGColor);
    CGContextAddArc(context, circleX, circleY, _circleRadius / 2, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
    [self callBlockTouchEnd:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
    [self callBlockTouchEnd:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
    [self callBlockTouchEnd:YES];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateTouchPoint:touches];
    [self callBlockTouchEnd:YES];
}

- (void)setRatioNum:(CGFloat)ratioNum
{
    
    if (_ratioNum != ratioNum) {
        _ratioNum = ratioNum;
        self.value = _minValue + ratioNum * (_maxValue - _minValue);
    }
}

- (void)setValue:(CGFloat)value
{
    if (value != _value) {
        if (value < _minValue) {
            _value = _minValue;
            return;
        } else if (value > _maxValue) {
            _value = _maxValue;
            return;
        }
        _value = value;
        
        [self setNeedsDisplay];
        
        if (_stateChangerd) {
            _stateChangerd(value);
        }
    }
}

- (void)sliderChange:(TouchStateChanged)didChangeBlock
{
    _stateChangerd = didChangeBlock;
}

- (void)sliderTouchEnd:(TouchStateEnd)touchEndBlock
{
    _stateEnd = touchEndBlock;
}

- (void)updateTouchPoint:(NSSet *)touches
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.ratioNum = (_direction == SliderDirectionHorizonal ? touchPoint.x : touchPoint.y) / (_direction == SliderDirectionHorizonal ? self.frame.size.width : self.frame.size.height);

}

- (void)callBlockTouchEnd:(BOOL)isTouchEnd
{
    _isSliding = !isTouchEnd;
    
    if (isTouchEnd == YES) {
        _stateEnd(_value);
    }
}
@end
