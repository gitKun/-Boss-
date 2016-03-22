# Boss直聘下拉刷新效果的实现

仿写的Boss直聘下拉刷新

>已经集成到MJRefresh中，使用MJRefresh的同学可直接拿到项目中

效果如下图所示

![仿Boss直聘的下拉刷新效果.gif](https://ooo.0o0.ooo/2016/03/21/56f0b0eb429ff.gif)


具体可参考代码，内有详细注释

##大概思路

具体思路如下

1.  先计算出四个点的位置，然后根据下拉的偏移量计算出下移的百分比_0.0~1.0_(最新版的`MJRefresh`中已给出相应方法，自己写刷新的同学请自行计算)
2.  根据下拉的比例来显示相应的点
3.  在两点之间根据比例来计算下一个要绘制点的位置见*代码1*然后用 CGContex 相关的函数进行绘制直线 见*代码2*
4.  动画分为三个部分 第一部分为旋转，第二部分为缩放点的位置，第三部分为还原点的位置 见*代码3*

##部分具体实现的代码

**代码1计算当前偏移百分比对应的将要绘制的点**

```
CGPoint currentProportionPoint(CGPoint starPoint, CGPoint endPoint, CGFloat scale) {
    CGFloat lengthOfX = endPoint.x - starPoint.x;
    CGFloat pointX = starPoint.x + lengthOfX * scale;
    CGFloat lengthOfY = endPoint.y - starPoint.y;
    CGFloat pointY = starPoint.y + lengthOfY * scale;
    return CGPointMake(pointX, pointY);
}

```

**代码2绘制当前偏移量对应的线条**

```
void drawLineInContextFromStartPointAndEndPointWithScale (CGContextRef ctx, CGPoint starPoint, CGPoint endPoint, CGFloat scale, UIColor *storkeColor) {
    CGContextSetStrokeColorWithColor(ctx, storkeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, starPoint.x, starPoint.y);
    CGPoint currentPoint = currentProportionPoint(starPoint, endPoint, scale);
    CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, pointWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}
```

**代码3**

*代码3.1动画部分绘制代码*

```
- (void)drawInContext:(CGContextRef)ctx {
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGPoint firstPoint = CGPointMake(center.x,center.y-viewHeighte+pointWidth/2);
    CGPoint secondPoint = CGPointMake(center.x-viewHeighte+pointWidth/2, center.y);
    CGPoint thirdPoint = CGPointMake(center.x, center.y+viewHeighte-pointWidth/2);
    CGPoint fourthPoint = CGPointMake(center.x+viewHeighte-pointWidth/2, center.y);
    if (isAnimationing) {
    	//开始动画后的绘制部分
        CGFloat scale = [(DRFrashLayer *)self.presentationLayer animationScale];
        CGPoint ScaleFirstPoint = currentProportionPoint(center, firstPoint, scale);
        CGPoint ScaleSecondPoint = currentProportionPoint(center, secondPoint, scale);
        CGPoint ScaleThiredPoint = currentProportionPoint(center, thirdPoint, scale);
        CGPoint ScaleFourthPoint = currentProportionPoint(center, fourthPoint, scale);
        drawPointAtRect(ScaleFirstPoint,ctx,(UIColorFromRGB_DR(0xF5C604, 1)).CGColor);
        drawPointAtRect(ScaleSecondPoint,ctx,UIColorFromRGB_DR(0x888889, 1.0).CGColor);
        drawPointAtRect(ScaleThiredPoint,ctx,UIColorFromRGB_DR(0x339999, 1).CGColor);
        drawPointAtRect(ScaleFourthPoint,ctx,UIColorFromRGB_DR(0xED7700, 1).CGColor);
    }else {
        //没有开始动画的绘制部分(具体见源代码)
}
```
*代码3.2动画代理代码*

```
#pragma mark === AnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kName] isEqualToString:@"ScaleSamll"]) {
        if (isAnimationing) {
        	//缩放位置动画结束后开始恢复动画
            [self addScaleBigAnimation];
        }
    }else if ([[anim valueForKey:kName] isEqualToString:@"ScaleBig"]) {
        if (isAnimationing) {
        	//恢复后开始缩放位置的动画
            [self addScaleSmallAnimation];
        }
    }
}
```

##BUG和探究

在继承与`MJRefreshHeader`自定制的 `BossHeaderView`中的

```
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    //这里 pullingPercent == 1.0 时 会出错 
    //NSLog(@"pullingprecent = %.2f",pullingPercent);
    self.mj_y = -self.mj_h * MIN(1.0, MAX(0.0, pullingPercent));
    CGFloat complete = MIN(1.0, MAX(0.0, pullingPercent-0.125));
    //NSLog(@"%.4f",complete);
    self.frashLayer.complete = complete;
}
```

会出现 BUG，具体表现如下图

![刷新时出现的BUG.gif](https://ooo.0o0.ooo/2016/03/22/56f1490fe9207.gif)

*bug展示*

虽然我已经给出了解决方案(丑陋的解决)但是还没能找出 BUG 发生的根本原因，在源码中已经做了详尽的注释，希望有兴趣的大神们能帮助修改。


希望和各位一起进步。 git地址[Boss直聘下拉刷新效果的实现](https://github.com/gitKun/-Boss-);
