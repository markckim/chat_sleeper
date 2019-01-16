//
//  MAAvatar.m
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/16/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAAvatar.h"

@implementation MAAvatar

+ (instancetype)avatarWithImageName:(NSString *)imageName textBorderColor:(UIColor *)textBorderColor {
    MAAvatar* avatar = [[MAAvatar alloc] init];
    avatar.imageName = [imageName copy];
    avatar.textBorderColor = textBorderColor;
    return avatar;
}

@end
