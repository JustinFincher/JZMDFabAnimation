//
//  JZMDFabVIew.m
//  JZMDFabAnimation
//
//  Created by Fincher Justin on 15/11/16.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//

#define DefaultButtonRect CGRectMake(ButtonDistanceFromZero - ButtonRadius, - ButtonRadius, ButtonRadius * 2, ButtonRadius * 2)
#define DefaultFullRect CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define DefaultCenterPoint CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
#define DefaultButtonPoint CGPointMake(self.ButtonPlaceHolderView.layer.position.x, self.ButtonPlaceHolderView.layer.position.y)
#define WorldBottomViewRect CGRectMake(BottomView.frame.origin.x, BottomView.frame.origin.y, BottomView.frame.size.width, BottomView.frame.size.height)

#define ButtonShadowOpacity 0.3
#define FramesInterval 0.4f

#define COLOR [[UIColor colorWithRed:79.0f/255.0f green:181.0f/255.0f blue:171.0f/255.0f alpha:1.0f] CGColor]
#import "JZMDFabView.h"

@interface UIView()

@property (nonatomic) CGRect SelfRectinSuperView;
@property (nonatomic) CGFloat ButtonRadius;
@property (nonatomic) CGFloat ButtonDistanceFromZero;
@property (nonatomic) CAShapeLayer* ButtonLayerCopy;

@property (nonatomic) int CurrentFrame;
@property (nonatomic) NSTimer *Timer;
@property (nonatomic) NSMutableArray *AnimateArray;
@property (nonatomic) BOOL isAnimated;

@property (nonatomic) UIView* ButtonPlaceHolderView;

@end

@implementation JZMDFabView

@synthesize BottomView,ContainerView;
@synthesize RoundButton,ButtonLayer,ButtonLayerCopy;

@synthesize ButtonDistanceFromZero,ButtonRadius,SelfRectinSuperView;

@synthesize CurrentFrame,Timer,AnimateArray,ButtonPlaceHolderView;
@synthesize isAnimated;




- (instancetype)initWithRect:(CGRect)Rect
                ButtonRadius:(CGFloat)Radius
              ButtonPosition:(CGFloat)DistanceFromZero
{
    self = [super initWithFrame:Rect];
    
    self.SelfRectinSuperView = Rect;
    self.ButtonRadius = Radius;
    self.ButtonDistanceFromZero = DistanceFromZero;
    
    BottomView = [[UIView alloc] initWithFrame:DefaultFullRect];
    BottomView.layer.masksToBounds = YES;

    ContainerView = [[UIView alloc]initWithFrame:DefaultFullRect];
    //ContainerView.backgroundColor = [UIColor blackColor];
    
    RoundButton = [[UIButton alloc] initWithFrame:DefaultButtonRect];
    [RoundButton addTarget:self action:@selector(isAnimatedAction) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    RoundButton.layer.cornerRadius = ButtonRadius;
    RoundButton.backgroundColor = [UIColor clearColor];
    [RoundButton setImage:[UIImage imageNamed:@"play-arrow"] forState:UIControlStateNormal];
    //RoundButton.layer.masksToBounds = YES;
    //RoundButton.clipsToBounds = NO;
    
    ButtonPlaceHolderView = [[UIView alloc] initWithFrame:RoundButton.frame];
    
    ButtonLayer = [CAShapeLayer layer];
    [ButtonLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:DefaultButtonRect] CGPath]];
    [ButtonLayer setFillColor:COLOR];
    ButtonLayer.shadowColor = [[UIColor blackColor] CGColor];
    ButtonLayer.shadowOffset = CGSizeMake(0.0, 6.0);
    ButtonLayer.shadowOpacity = ButtonShadowOpacity;
    ButtonLayer.shadowRadius = 4.0;
    ButtonLayerCopy.masksToBounds = NO;
    
    ButtonLayerCopy = [CAShapeLayer layer];
    [ButtonLayerCopy setPath:[[UIBezierPath bezierPathWithOvalInRect:DefaultButtonRect] CGPath]];
    [ButtonLayerCopy setFillColor:COLOR];
    ButtonLayerCopy.shadowColor = [[UIColor blackColor] CGColor];
    ButtonLayerCopy.shadowOffset = CGSizeMake(0.0, 6.0);
    ButtonLayerCopy.shadowOpacity = 0.0;
    ButtonLayerCopy.shadowRadius = 4.0;

    [self addSubview:BottomView];
    [BottomView.layer addSublayer:ButtonLayerCopy];
    [self addSubview:ContainerView];
    [self.layer addSublayer:ButtonLayer];
    [self addSubview:RoundButton];
    
    self.layer.masksToBounds = NO;
    isAnimated = NO;

    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint translatedPoint = [RoundButton convertPoint:point fromView:self];
    
    if (CGRectContainsPoint(RoundButton.bounds, translatedPoint)) {
        return [RoundButton hitTest:translatedPoint withEvent:event];
    }
    return [super hitTest:point withEvent:event];
    
}
- (void)isAnimatedAction
{
    if (isAnimated)
    {
        [self reverseAnimation];
    }
    else
    {
        [self beginAnimation];
    }
}
#pragma mark - beginAnimation

- (void)beginAnimation
{
    CGPoint ViewCenterPoint = DefaultCenterPoint;
    NSLog(@"ViewCenterPoint.x %f ViewCenterPoint.y %f",ViewCenterPoint.x,ViewCenterPoint.y);
    CGPoint ButtonCenterPoint = DefaultButtonPoint;
    NSLog(@"ButtonCenterPoint.x %f ButtonCenterPoint.y %f",ButtonCenterPoint.x,ButtonCenterPoint.y);
    
    //[RoundButton setHidden:YES];
    [RoundButton setUserInteractionEnabled:NO];
    AnimateArray = [self CalRouteFrom:ButtonCenterPoint To:ViewCenterPoint WithSteps:FramesInterval*60];
    CurrentFrame = 0;
    Timer =  [NSTimer scheduledTimerWithTimeInterval:(float)(0.016666) target:self selector:@selector(SingleFrameBeginAnimation) userInfo:nil repeats:YES];
}

- (void)SingleFrameBeginAnimation
{
    [self ButtonLayerBeginAnimation];
    [self ButtonLayerCopyBeginAnimation];
    [self RoundButtonBeginAnimation];
    
    if (CurrentFrame == FramesInterval*60)
    {
        [Timer invalidate];
        CurrentFrame = 0;
        [RoundButton setUserInteractionEnabled:YES];
        isAnimated = YES;
        [RoundButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else CurrentFrame++;
    
    NSLog(@"CurrentFrame:%d",CurrentFrame);
}

- (void)RoundButtonBeginAnimation
{
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    NSLog(@" RoundButtonBeginAnimation X : %f    Y : %f",X,Y);
    CGRect OvalInRect = CGRectMake(X-ButtonRadius,Y- ButtonRadius, ButtonRadius * 2, ButtonRadius * 2);
    [RoundButton setFrame:OvalInRect];
}

- (void)ButtonLayerBeginAnimation
{
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    CGRect OvalInRect = CGRectMake(X-ButtonRadius,Y- ButtonRadius, ButtonRadius * 2, ButtonRadius * 2);
    [ButtonLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:OvalInRect] CGPath]];
    NSLog(@" ButtonLayerBeginAnimation X : %f    Y : %f",X,Y);
    self.ButtonLayer.opacity = [[[AnimateArray objectAtIndex:1] objectAtIndex:CurrentFrame] floatValue];
}
- (void)ButtonLayerCopyBeginAnimation
{
    CGFloat Scale = [[[AnimateArray objectAtIndex:2] objectAtIndex:CurrentFrame] floatValue];
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    CGRect OvalInRect = CGRectMake(X-Scale,Y- Scale, Scale * 2, Scale * 2);
    [ButtonLayerCopy setPath:[[UIBezierPath bezierPathWithOvalInRect:OvalInRect] CGPath]];
}

#pragma mark - reverseAnimation

- (void)reverseAnimation
{
    CGPoint ViewCenterPoint = DefaultCenterPoint;
    NSLog(@"ViewCenterPoint.x %f ViewCenterPoint.y %f",ViewCenterPoint.x,ViewCenterPoint.y);
    CGPoint ButtonCenterPoint = DefaultButtonPoint;
    NSLog(@"ButtonCenterPoint.x %f ButtonCenterPoint.y %f",ButtonCenterPoint.x,ButtonCenterPoint.y);
    
    //[RoundButton setHidden:YES];
    [RoundButton setUserInteractionEnabled:NO];
    AnimateArray = [self CalRouteFrom:ButtonCenterPoint To:ViewCenterPoint WithSteps:FramesInterval*60];
    CurrentFrame = FramesInterval*60;
    Timer =  [NSTimer scheduledTimerWithTimeInterval:(float)(0.016666) target:self selector:@selector(SingleFrameEndAnimation) userInfo:nil repeats:YES];
}

- (void)SingleFrameEndAnimation
{
    [self ButtonLayerEndAnimation];
    [self ButtonLayerCopyEndAnimation];
    [self RoundButtonEndAnimation];
    
    if (CurrentFrame == 0)
    {
        NSLog(@"CurrentFrame == 0");
        [Timer invalidate];
        //[RoundButton setHidden:NO];
        [RoundButton setUserInteractionEnabled:YES];
        [self bringSubviewToFront:RoundButton];
        self.ButtonLayer.opacity = 1.0f;
        NSLog(@"self.ButtonLayer.opacity = %f",self.ButtonLayer.opacity);
        [RoundButton setImage:[UIImage imageNamed:@"play-arrow"] forState:UIControlStateNormal];
        isAnimated = NO;
    }
    else CurrentFrame--;

    NSLog(@"CurrentFrame:%d",CurrentFrame);
}

- (void)RoundButtonEndAnimation
{
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    NSLog(@" RoundButtonBeginAnimation X : %f    Y : %f",X,Y);
    CGRect OvalInRect = CGRectMake(X-ButtonRadius,Y- ButtonRadius, ButtonRadius * 2, ButtonRadius * 2);
    [RoundButton setFrame:OvalInRect];
}

- (void)ButtonLayerEndAnimation
{
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    CGRect OvalInRect = CGRectMake(X-ButtonRadius,Y- ButtonRadius, ButtonRadius * 2, ButtonRadius * 2);
    [ButtonLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:OvalInRect] CGPath]];
    
    self.ButtonLayer.opacity = [[[AnimateArray objectAtIndex:1] objectAtIndex:CurrentFrame] floatValue];
}
- (void)ButtonLayerCopyEndAnimation
{
    CGFloat Scale = [[[AnimateArray objectAtIndex:2] objectAtIndex:CurrentFrame] floatValue];
    CGFloat X = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].x + DefaultButtonPoint.x;
    CGFloat Y = [[[AnimateArray objectAtIndex:0] objectAtIndex:CurrentFrame] CGPointValue].y + DefaultButtonPoint.y;
    CGRect OvalInRect = CGRectMake(X-Scale,Y- Scale, Scale * 2, Scale * 2);
    [ButtonLayerCopy setPath:[[UIBezierPath bezierPathWithOvalInRect:OvalInRect] CGPath]];
}

- (NSMutableArray *)CalRouteFrom:(CGPoint)From
                              To:(CGPoint)To
                       WithSteps:(int)Steps
{
    NSMutableArray *RouteArray = [NSMutableArray arrayWithCapacity:(Steps + 1)];
    NSMutableArray *OpacityArray = [NSMutableArray arrayWithCapacity:(Steps + 1)];
    NSMutableArray *ScaleArray = [NSMutableArray arrayWithCapacity:(Steps + 1)];
    
    
    CGPoint ZeroPoint = CGPointMake(To.x, From.y);
    CGFloat XOffest = To.x - From.x;
    CGFloat YOffest = To.y - From.y;
    CGFloat OvalSquare = powf(XOffest, 2.0f) * powf(YOffest, 2.0f);
    CGFloat WidthAndHeight = sqrtf(powf((self.frame.size.width), 2.0f) + powf((self.frame.size.height), 2.0f));
    NSLog(@"OvalSquare:%f",OvalSquare);
    NSLog(@"XOffest %f, YOffest %f",XOffest,YOffest);
    NSLog(@"WidthAndHeight %f",WidthAndHeight);
    
    for (int i = 0; i <= Steps; i++)
    {
        //RouteArray
        float X = (To.x - From.x)*i/Steps;
        float Y;
        if (YOffest > 0)
        {
            Y = sqrtf((OvalSquare - powf((X + From.x - ZeroPoint.x)*YOffest, 2.0f))/powf(XOffest, 2.0f));
        }
        else
        {
            Y = - sqrtf((OvalSquare - powf((X + From.x - ZeroPoint.x)*YOffest, 2.0f))/powf(XOffest, 2.0f));
        }
        NSLog(@"X:%f Y:%f",X,Y);
        
        if (YOffest == 0)
        {
            [RouteArray addObject:[NSValue valueWithCGPoint:CGPointMake(X, From.y)]];
        }else
        {
            [RouteArray addObject:[NSValue valueWithCGPoint:CGPointMake(X, Y)]];
        }
        
        //OpacityArray
        CGFloat Opacity = (float)(Steps - i * 15)/(float)(Steps) ;
        if (Opacity < 0)
        {
            Opacity = 0.0f;
        }
        NSLog(@"%f",Opacity);
        [OpacityArray addObject:[NSNumber numberWithFloat:Opacity]];
        
        //ScaleArray
        CGFloat Scale;
        NSLog(@"%f",Scale);
        Scale = powf((float)(i)/(float)Steps, 2.0f) * (WidthAndHeight / 2 - ButtonRadius) + ButtonRadius;
        //Scale = ButtonRadius;
        [ScaleArray addObject:[NSNumber numberWithFloat:Scale]];
        
    }
    
    
    NSMutableArray *AllKeyFramesArray = [NSMutableArray arrayWithObjects:RouteArray,OpacityArray,ScaleArray, nil];
    return AllKeyFramesArray;
}


@end
