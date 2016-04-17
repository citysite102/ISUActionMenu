//
//  ISUActionMenuView.m
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import "ISUActionMenuView.h"


@interface ISUActionMenuView()

@property (nonatomic, strong) UIView *touchPointView;
@property (nonatomic, strong) NSArray<ISUActionMenuItemView *> *itemViews;
@property (nonatomic, readwrite) NSInteger lastFocusedCellIndex;
@property (nonatomic, strong) CAShapeLayer *indicatorPath;
@property (nonatomic, readwrite) BOOL didDismiss;

@end

@implementation ISUActionMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoAdjustCenterDegree = YES;
        self.centerDegreeReferenceFrame = [UIScreen mainScreen].bounds;
        // Define self intersectionDegree between item.
        self.intersectionDegree = 60.0;
        // Define default center degree.
        self.centerDegree = 90;
        // Define circle radius.
        self.radius = 90.0;
        self.lastFocusedCellIndex = -1;
        self.minimumAcceptProgress = 0.8;
        
        self.touchPointView = [[UIView alloc] initWithFrame:CGRectZero];
        self.touchPointView.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
        self.touchPointView.layer.cornerRadius = 20.0;
        self.touchPointView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.touchPointView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.touchPointView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.touchPointView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.touchPointView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:40.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.touchPointView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:40.0f]];
        
        
        self.indicatorPath = [[CAShapeLayer alloc] init];
        self.indicatorPath.path        = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-40, -40, 80, 80)].CGPath;
        self.indicatorPath.strokeColor = [UIColor colorWithRed:229.0f/255.0f green:104.0f/255.0f blue:92.0f/255.0f alpha:1.0].CGColor;
        self.indicatorPath.fillColor   = [UIColor clearColor].CGColor;
        self.indicatorPath.lineWidth   = 6.0;
        self.indicatorPath.strokeEnd   = 0.0;
        self.indicatorPath.anchorPoint = (CGPoint){0.5, 0.5};
        self.indicatorPath.transform = CATransform3DRotate(self.indicatorPath.transform,
                                                            -M_PI_2,
                                                           0.0,
                                                           0.0,
                                                           1.0);
        [self.layer addSublayer:self.indicatorPath];
        
    }
    return self;
}

#pragma mark - Setter

- (void)setItems:(NSArray<ISUActionMenuItem *> *)items {
    
    _items = items;
    
    // Clean previous cell
    for (UIView *itemView in self.itemViews) {
        [itemView removeFromSuperview];
    }
    
    // Setup new cells
    NSMutableArray *itemViews = [NSMutableArray arrayWithCapacity:self.items.count];
    for (ISUActionMenuItem *item in self.items) {
        
        ISUActionMenuItemView *itemView = [[ISUActionMenuItemView alloc] initWithFrame:CGRectZero];
        itemView.item = item;
        
        [self addSubview:itemView];
        [itemViews addObject:itemView];
    }
    self.itemViews = itemViews;
}


- (void)setShowIndicatorPath:(BOOL)showIndicatorPath {
    _indicatorPath.hidden = !showIndicatorPath;
}

- (void)setShowProgress:(BOOL)showProgress {
    for (ISUActionMenuItemView *itemView in self.itemViews) {
        itemView.indicatorPath.hidden = !showProgress;
    }
}

- (void)setIndicatorPathColor:(UIColor *)indicatorPathColor {
    _indicatorPath.strokeColor = indicatorPathColor.CGColor;
}

#pragma mark - Events

- (void)presentWithCompletionHandler:(void (^)(ISUActionMenuView *))completionHandler {
    
    if (self.itemViews.count <= 0) {
        return;
    }
    
    [self layoutIfNeeded];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    for (ISUActionMenuItemView *itemView in self.itemViews) {
        itemView.alpha  = 0;
        itemView.center = center;
        itemView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        for (ISUActionMenuItemView *itemView in self.itemViews) {
            itemView.alpha  = 1.0;
        }
    }];
    
    
    for (NSUInteger i = self.itemViews.count - 1 ; i != NSUIntegerMax ; i--) {
        [UIView animateWithDuration:0.5
                              delay: -(i - self.itemViews.count) * 0.1
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self updateCellAtIndex:i withProgress:0];
                         } completion:^(BOOL finished) {
                             if (i == self.itemViews.count - 1) {
                                 if (completionHandler) {
                                     completionHandler(self);
                                 }
                             }
                         }];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        CABasicAnimation *indicatorSizeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        indicatorSizeAnimation.fromValue = @1;
        indicatorSizeAnimation.toValue = @0.8;
        indicatorSizeAnimation.duration = 0.6;
        indicatorSizeAnimation.removedOnCompletion = NO;
        indicatorSizeAnimation.fillMode = kCAFillModeForwards;
        indicatorSizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        [self.indicatorPath addAnimation:indicatorSizeAnimation forKey:nil];
    }];
    
    CABasicAnimation *indicatorPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    indicatorPathAnimation.fromValue = @0;
    indicatorPathAnimation.toValue = @1.0;
    indicatorPathAnimation.repeatCount = 1;
    indicatorPathAnimation.duration = 0.5;
    indicatorPathAnimation.removedOnCompletion = NO;
    indicatorPathAnimation.fillMode = kCAFillModeForwards;
    indicatorPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.indicatorPath addAnimation:indicatorPathAnimation forKey:nil];
    [CATransaction commit];
    


}

- (void)dismissWithItem:(ISUActionMenuItem *)item completionHandler:(void (^)(ISUActionMenuView *))completionHandler {
    
    self.didDismiss = YES;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0;
        if (item) {
            self.itemViews[[self.items indexOfObject:item]].progress = 1.0;
        }
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        for (ISUActionMenuItemView *itemView in self.itemViews) {
            
            if (itemView.item == item) {
                itemView.layer.transform = CATransform3DMakeScale(2.0, 2.0, 1.0);
            } else {
                itemView.center = center;
                itemView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
            }
            itemView.alpha  = 0;
        }
    } completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler(self);
        }
    }];
}

#pragma mark - Animation Update

- (void)updateCellAtIndex:(NSInteger)index withProgress:(CGFloat)progress {
    
    progress = progress >= 0 ? progress : MAX(-0.1, progress * 0.25);
    
    CGFloat centerDegree = self.convertedCenterDegree;
    CGFloat totalDegree  = ((CGFloat)self.itemViews.count -1) * self.intersectionDegree;
    CGFloat startDegree  = centerDegree - totalDegree * 0.5;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Update cell
    ISUActionMenuItemView *itemView = self.itemViews[index];
    CGFloat degree = startDegree +(index * self.intersectionDegree);
    CGFloat angle  = degree  / 180. * M_PI;
    CGFloat scale  = MIN(1.25, 1.0 + 0.25 *progress);
    
    itemView.progress = progress;
    itemView.center = CGPointMake(center.x + self.radius * scale * cos(angle),
                              center.y - self.radius * scale * sin(angle));
    itemView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
}

- (CGFloat)convertedCenterDegree {
    
    if (self.autoAdjustCenterDegree) {
        
        CGFloat centerDegree  = self.centerDegree;
        CGFloat totalDegree   = ((CGFloat)self.itemViews.count -1) * self.intersectionDegree;
        CGPoint pointInWindow = [self.window convertPoint:CGPointZero fromView:self];
        CGFloat deltaProgress = 0;
        
        
        CGFloat deltaX = pointInWindow.x - CGRectGetMidX(self.centerDegreeReferenceFrame);
        
        /* Rotate conter degree by position X
         deltaProgress = deltaX / (CGRectGetWidth(self.centerDegreeReferenceFrame) *0.5);
         */
        
        if (deltaX >= 0 &&
            pointInWindow.x +self.radius + 22/*Cell radius*/ >
            CGRectGetMaxX(self.centerDegreeReferenceFrame)) {
            deltaProgress = 1;
        }
        else if (deltaX < 0 &&
                 pointInWindow.x -self.radius - 22/*Cell radius*/ <
                 CGRectGetMinX(self.centerDegreeReferenceFrame)) {
            deltaProgress = -1;
        }
        
        // Refine center degree
        if (deltaProgress >= 0) { // Right side
            
            CGFloat minDegree = centerDegree -totalDegree *0.5;
            if (minDegree < 90) {
                centerDegree += (90 -minDegree) * fabs(deltaProgress);
            }
            
        } else { // Left side
            
            CGFloat maxDegree = centerDegree +totalDegree *0.5;
            if (maxDegree > 90) {
                centerDegree += (90 -maxDegree) * fabs(deltaProgress);
            }
        }
        
        return centerDegree;
    } else {
        return self.centerDegree;
    }
}

#pragma mark - Action Menu Interface Protocol

- (void)menuTouchChanged:(UILongPressGestureRecognizer *)sender {
    
    if (self.didDismiss) {
        return;
    }
    
    // Generate center degree according to touch position.
    CGFloat centerDegree = self.convertedCenterDegree;
    
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint touchPoint = [sender locationInView:self];
    CGPoint cgTouchPoint = CGPointApplyAffineTransform(touchPoint, CGAffineTransformMakeScale(1, -1));
    
    // Calculate center angle and evaluate center vector
    CGFloat centerAngle  = centerDegree / 180. * M_PI;
    CGPoint centerVector = CGPointMake(cos(centerAngle), sin(centerAngle));
    
    // Calculate drag vector
    CGPoint dragVector   = (CGPoint){ .x = cgTouchPoint.x - center.x, .y = cgTouchPoint.y - center.y };
    
    // Calculate direction
    CGPoint convertedDragVector = CGPointApplyAffineTransform(dragVector, CGAffineTransformMakeRotation(-centerDegree / 180. * M_PI));
    
    // Calculate intersection degree between center vector and drag vector (Law of cosines)
    CGFloat intersectionAngle = acos(((centerVector.x * dragVector.x) + (centerVector.y * dragVector.y)) /
                                     (hypot(centerVector.x, centerVector.y) * hypot(dragVector.x, dragVector.y)));
    CGFloat intersectionDegree = (intersectionAngle * 180. / M_PI) * (convertedDragVector.y > 0 ? 1 : -1);
    
    
    // Calculate the startDegree for the item
    CGFloat startDegree = -((CGFloat)self.itemViews.count - 1) * self.intersectionDegree * 0.5;
    
    // Calculate item view status
    NSInteger itemViewIndex = round((intersectionDegree - startDegree) / self.intersectionDegree);
    CGFloat itemViewDegree = (centerDegree + startDegree) + (itemViewIndex * self.intersectionDegree);
    CGFloat itemViewangle  = itemViewDegree / 180. * M_PI;
    CGPoint itemViewCenter = CGPointMake(center.x + self.radius * cos(itemViewangle), center.y - self.radius * sin(itemViewangle));
    
    CGFloat progress = 1.0 -(hypot(itemViewCenter.x - touchPoint.x, itemViewCenter.y - touchPoint.y) / self.radius);
    progress = MIN(1.0, progress *(1.0 / self.minimumAcceptProgress));
    
    if ([self.delegate respondsToSelector:@selector(actionMenu:item:progressChanged:)]) {
        
        ISUActionMenuItem *item = nil;
        if (itemViewIndex >= 0 && itemViewIndex < self.itemViews.count) {
            item = self.items[itemViewIndex];
        }
        [self.delegate actionMenu:self item:item progressChanged:item ? progress : 0];
    }
    if (self.didDismiss) {
        return;
    }
    
    // Text
    if (itemViewIndex != self.lastFocusedCellIndex &&
                        self.lastFocusedCellIndex >= 0 &&
                        self.lastFocusedCellIndex < self.itemViews.count) {
        self.itemViews[self.lastFocusedCellIndex].showText = NO;
    }
    
    if (itemViewIndex >= 0 && itemViewIndex < self.itemViews.count) {
        self.itemViews[itemViewIndex].showText = progress > 0.1;
    }
    
    // Animation
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (itemViewIndex != self.lastFocusedCellIndex &&
                            self.lastFocusedCellIndex >= 0 &&
                            self.lastFocusedCellIndex < self.itemViews.count) {
            [self updateCellAtIndex:self.lastFocusedCellIndex withProgress:0];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView
     animateWithDuration:0.15 * (1.0 - progress) delay:0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         
         if (itemViewIndex >= 0 && itemViewIndex < self.itemViews.count) {
             [self updateCellAtIndex:itemViewIndex withProgress:progress];
             self.lastFocusedCellIndex = itemViewIndex;
         } else {
             self.lastFocusedCellIndex = -1;
         }
         
     } completion:^(BOOL finished) {
         
     }];
}


@end
