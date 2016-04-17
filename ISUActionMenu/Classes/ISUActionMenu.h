//
//  ISUActionMenu.h
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISUActionMenuInterface <NSObject>
@optional
- (void)menuTouchBegin:(UILongPressGestureRecognizer *)sender;
- (void)menuTouchChanged:(UILongPressGestureRecognizer *)sender;
- (void)menuTouchEnded:(UILongPressGestureRecognizer *)sender;
@end

@class ISUActionMenuItem;
@class ISUActionMenuView;

@interface ISUActionMenuGestureRecognizer : UILongPressGestureRecognizer

@property (nonatomic, readwrite) ISUActionMenuView *menuView;
@property (nonatomic, readwrite) NSArray<ISUActionMenuItem *> *items;
@property (nonatomic, readonly) ISUActionMenuItem *selectedItem;
@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, weak) UIView *targetView;

- (CGPoint)startLocationInView:(UIView *)view;
- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
         initializationHandler:(ISUActionMenuView *(^)())initializationHandler;

@end

NS_ASSUME_NONNULL_END
