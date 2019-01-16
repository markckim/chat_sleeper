//
//  MAAvatar.h
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/16/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIColor;

@interface MAAvatar : NSObject

@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, strong) UIColor* textBorderColor;

+ (instancetype)avatarWithImageName:(NSString *)imageName textBorderColor:(UIColor *)textBorderColor;

@end

NS_ASSUME_NONNULL_END
