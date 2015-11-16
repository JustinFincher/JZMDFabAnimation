//
//  ViewController.m
//  JZMDFabAnimation
//
//  Created by Fincher Justin on 15/11/15.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//
#define HEIGHT 180

#define WIDTH 0

#import "JZMDFabView.h"

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic)  JZMDFabView *JZMDFab;

@end

@implementation ViewController
@synthesize JZMDFab;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *CoverView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cover"]];
    [CoverView setFrame:CGRectMake(WIDTH, 0, self.view.frame.size.width - WIDTH * 2, self.view.frame.size.width - WIDTH * 2)];
    CoverView.layer.shadowColor = [[UIColor blackColor] CGColor];
    CoverView.layer.shadowOffset = CGSizeMake(0.0, 6.0);
    CoverView.layer.shadowOpacity = 0.3f;
    CoverView.layer.shadowRadius = 4.0;
    CoverView.layer.masksToBounds = NO;
    
    [self.view addSubview:CoverView];
    
    
    JZMDFab = [[JZMDFabView alloc] initWithRect:CGRectMake(0, self.view.frame.size.width - WIDTH * 2, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.width - WIDTH * 2)
                                   ButtonRadius:self.view.frame.size.width/10
                                 ButtonPosition:self.view.frame.size.width * 8 / 10];
    [self.view addSubview:JZMDFab];
    JZMDFab.BottomView.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:81.0f/255.0f blue:98.0f/255.0f alpha:1.0f];
    
    
    
    UILabel *TitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    TitleLabel.text = @"Paradise Awaits (FKJ Remix)";
    TitleLabel.textColor = [UIColor whiteColor];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.JZMDFab.ContainerView addSubview:TitleLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
