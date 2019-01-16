//
//  MAMessageCell.h
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/15/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImageTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeightLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
