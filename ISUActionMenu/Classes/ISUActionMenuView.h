//
//  ISUActionMenuView.h
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISUActionMenu.h"
#import "ISUActionMenuItem.h"
#import "ISUActionMenuItemView.h"


@class ISUActionMenuView;

@protocol ISUActionMenuViewDelegate <NSObject>

- (void)actionMenu:(ISUActionMenuView *)actionMenuView
              item:(ISUActionMenuItem *)item
   progressChanged:(CGFloat)progress;

@end


@interface ISUActionMenuView : UIView
<
ISUActionMenuInterface
>

@property (nonatomic, readwrite) NSArray<ISUActionMenuItem *> *items;

/**
 *  Define the intersection degree among each item.
 */
@property (nonatomic, readwrite) CGFloat intersectionDegree;
/**
 *  Define the center degree among all the item.
 */
@property (nonatomic, readwrite) CGFloat centerDegree;
/**
 *  Define the radius of the action menu view.
 */
@property (nonatomic, readwrite) CGFloat radius;
/**
 *  Degine the minimum accept ratio to trigger the progress animation, [0;1]
 */
@property (nonatomic, readwrite) CGFloat minimumAcceptProgress;
/**
 *  Frame to calculate the aujust center degree when autoAdjustCenterDegree = YES, default is [UIScreen mainScreen].bounds
 */
@property (nonatomic, readwrite) CGRect  centerDegreeReferenceFrame;
/**
 *  Bool value to decide whether to auto adjust the center degree.
 */
@property (nonatomic, readwrite) BOOL autoAdjustCenterDegree;





/**
 *  Bool value to decide whether to show the indicator path when long pressed event start.
 */
@property (nonatomic, readwrite) BOOL showIndicatorPath;
/**
 *  Indicator path color.
 */
@property (nonatomic, strong) UIColor *indicatorPathColor;
/**
 *  Bool value to decide whether to show the progress path.
 */
@property (nonatomic, readwrite) BOOL showProgress;


@property (nonatomic, weak) id<ISUActionMenuViewDelegate> delegate;
//@property (nonatomic, readonly) CGFloat convertedCenterDegree;


- (void)presentWithCompletionHandler:(void(^)(ISUActionMenuView *sender))completionHandler;
- (void)dismissWithItem:(ISUActionMenuItem *)item completionHandler:(void(^)(ISUActionMenuView *sender))completionHandler;

@end
