//
//  ISUActionMenuItem.m
//  issuu-action-menu
//
//  Created by YU CHONKAO on 2016/4/11.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

#import "ISUActionMenuItem.h"

@implementation ISUActionMenuItem

+ (instancetype)itemWithImage:(UIImage *)image
                         text:(NSString *)text {
    
    ISUActionMenuItem *item = ({
        ISUActionMenuItem *item_internal = [[ISUActionMenuItem alloc] init];
        item_internal.image = image;
        item_internal.text  = text;
        item_internal;
    });
    return item;
}

@end
