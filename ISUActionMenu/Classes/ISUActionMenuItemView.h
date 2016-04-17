//
//  ISUActionMenuItemView.h
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISUActionMenuItem;

@interface ISUActionMenuItemView : UIView

@property (nonatomic, strong) ISUActionMenuItem *item;
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) BOOL showText;


@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView  *textContainer;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CAShapeLayer *indicatorPath;

//Exposed Parameter
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) UIColor *textContainerColor;
@property (nonatomic, strong) UIColor *textLabelColor;


//Exposed Parameter - Indicator
@property (nonatomic, strong) UIColor *indicatorPathColor;
@property (nonatomic, assign) double indicatorPathWidth;


@end
