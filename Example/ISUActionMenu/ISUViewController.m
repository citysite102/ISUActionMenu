//
//  ISUViewController.m
//  ISUActionMenu
//
//  Created by Samuel on 04/17/2016.
//  Copyright (c) 2016 Samuel. All rights reserved.
//

#import <ISUActionMenu/ISUActionMenuSupport.h>
#import "ISUViewController.h"

@interface ISUViewController ()

@property (nonatomic, strong) ISUActionMenuGestureRecognizer *ActionMenuGesture;

@end

@implementation ISUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
//    self.ActionMenuGesture = [[ISUActionMenuGestureRecognizer alloc]
//                             initWithTarget:self
//                             action:@selector(handleActionMenuGesture:)
//                             initializationHandler:^ISUActionMenuView * _Nonnull {
//                                 ISUActionMenuView *actionMenuView = [[ISUActionMenuView alloc] init];
//                                 return actionMenuView;
//                             }];
//    
    self.ActionMenuGesture = [[ISUActionMenuGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionMenuGesture:)];
    
    self.ActionMenuGesture.items = @[[ISUActionMenuItem itemWithImage:[UIImage imageNamed:@"icon_move"] text:@"Move"],
                                    [ISUActionMenuItem itemWithImage:[UIImage imageNamed:@"icon_duplicate"] text:@"Duplicate"],
                                    [ISUActionMenuItem itemWithImage:[UIImage imageNamed:@"icon_rotation"] text:@"Rotation"]];
    
    [self.view addGestureRecognizer:self.ActionMenuGesture];
}

- (void)handleActionMenuGesture:(ISUActionMenuGestureRecognizer *)sender {
    
    if (sender.selectedItem) {
        switch (sender.selectedItem.index) {
            case 0: {
                NSLog(@"Action 1");
                break;
            }
            case 1: {
                NSLog(@"Action 2");
                break;
            }
            case 2: {
                NSLog(@"Action 3");
                break;
            }
            default:
                break;
        }
    }
}
@end
