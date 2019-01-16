//
//  MAMessage.h
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/15/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MAAvatar;

@interface MAMessage : NSObject

@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* dateString;
@property (nonatomic, strong) MAAvatar* avatar;

@end

NS_ASSUME_NONNULL_END
