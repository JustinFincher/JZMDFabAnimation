//
//  JZMDFabVIew.h
//  JZMDFabAnimation
//
//  Created by Fincher Justin on 15/11/16.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZMDFabView : UIView

@property (nonatomic) UIView *BottomView;
@property (nonatomic) UIButton *RoundButton;
@property (nonatomic) UIView *ContainerView;
@property (nonatomic) CAShapeLayer* ButtonLayer;

- (instancetype)initWithRect:(CGRect)Rect
                ButtonRadius:(CGFloat)Radius
              ButtonPosition:(CGFloat)DistanceFromZero;

- (void)beginAnimation;
- (void)reverseAnimation;


- (void)setBottomViewColor:(UIColor *)color;
- (void)setRoundButtonColor:(UIColor *)color;
- (void)setRoundButtonIcon:(UIImage *)image;


@end
