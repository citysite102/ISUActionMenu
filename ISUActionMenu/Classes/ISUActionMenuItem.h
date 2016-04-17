//
//  ISUActionMenuItem.h
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ISUActionMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger index;

+ (instancetype)itemWithImage:(UIImage *)image
                         text:(NSString *)text;

@end
