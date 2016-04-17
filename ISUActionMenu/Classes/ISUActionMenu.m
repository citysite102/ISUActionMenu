//
//  ISUActionMenu.m
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import "ISUActionMenu.h"
#import "ISUActionMenuView.h"

@interface ISUActionMenuGestureRecognizer()
 <
ISUActionMenuViewDelegate
>

typedef ISUActionMenuView *(^initializationHandler)();

@property (nonatomic, assign) BOOL initCalled;
@property (nonatomic, readwrite) SEL s_action;
@property (nonatomic, weak) id s_target;
@property (nonatomic, assign) initializationHandler initializationHandler;
//@property (nonatomic, weak) ISUActionMenuView *menuView;

@end

@implementation ISUActionMenuGestureRecognizer

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action {
    
    self = [super initWithTarget:self action:@selector(handleLongPressedGesture:)];
    if (self) {
        ISUActionMenuView *menuView = [[ISUActionMenuView alloc] initWithFrame:CGRectZero];
        
        self.s_target = target;
        self.s_action = action;
        self.menuView = menuView;
    }
    return self;
}


- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
         initializationHandler:(ISUActionMenuView *(^)())initializationHandler {
    
    self = [super initWithTarget:self action:@selector(handleLongPressedGesture:)];
    if (self) {
        self.s_target = target;
        self.s_action = action;
        self.initializationHandler = initializationHandler;
    }
    return self;
}

#pragma mark - Events

- (void)handleLongPressedGesture:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIView *targetView = self.targetView ? : self.view;
        
        ISUActionMenuView *menuView = self.initializationHandler();
        self.menuView          = menuView;
        self.menuView.frame    = CGRectZero;
        self.menuView.items    = self.items;
        self.menuView.center   = [sender locationInView:targetView];
        self.menuView.userInteractionEnabled = NO;
        self.menuView.delegate = self;
        [targetView addSubview:self.menuView];
        [self.menuView presentWithCompletionHandler:nil];
        
        if ([self.menuView respondsToSelector:@selector(menuTouchBegin:)]) {
            [self.menuView menuTouchBegin:sender];
        }
        _startPoint = [sender locationInView:targetView];
        _initCalled = YES;
   
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        if ([self.menuView respondsToSelector:@selector(menuTouchChanged:)]) {
            [self.menuView menuTouchChanged:sender];
        }
        
    } else {
        
        if (_initCalled) {
            [self.menuView dismissWithItem:nil completionHandler:^(ISUActionMenuView *sender) {
                [sender removeFromSuperview];
            }];
        }
        if ([self.menuView respondsToSelector:@selector(menuTouchEnded:)]) {
            [self.menuView menuTouchEnded:sender];
        }
        
        _startPoint = (CGPoint){ .x = INFINITY, .y = INFINITY};
        _selectedItem = nil;
        _initCalled = NO;
    }
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (_selectedItem && _initCalled) {
        _initCalled = NO;
        if ([self.s_target respondsToSelector:self.s_action]) {
            [self.s_target performSelector:self.s_action withObject:sender];
        }
    }
#pragma clang diagnostic pop
    
}

#pragma mark - Setter & Getter
- (void)setItems:(NSArray<ISUActionMenuItem *> *)items {
    _items = items;
    [items enumerateObjectsUsingBlock:^(ISUActionMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.index = idx;
    }];
}


#pragma mark - API method

- (CGPoint)startLocationInView:(UIView *)view {
    return [view convertPoint:self.startPoint fromView:self.menuView.superview];
}

#pragma mark - Action Menu View Delegate

- (void)actionMenu:(ISUActionMenuView *)actionMenuView
              item:(ISUActionMenuItem *)item
   progressChanged:(CGFloat)progress {
    _selectedItem = (progress >= 1.0) ? item : nil;
    if (_selectedItem) {
        [self.menuView dismissWithItem:item completionHandler:^(ISUActionMenuView *sender) {
            [sender removeFromSuperview];
        }];
    }
}

@end