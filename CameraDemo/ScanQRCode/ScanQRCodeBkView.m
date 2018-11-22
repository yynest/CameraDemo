//
//  ScanQRCodeBkView.m
//  QianShanJY
//
//  Created by lxl on 2017/12/22.
//  Copyright © 2017年 chinasun. All rights reserved.
//

#import "ScanQRCodeBkView.h"

@implementation ScanQRCodeBkView{
    CGFloat width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        width = frame.size.width/6;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
    CGRect holeRection = CGRectMake(width, 100, width*4, width*4);
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */
    
    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];
    
    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);
    
}
@end
