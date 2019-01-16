//
//  MATextView.h
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/15/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAKeyboardView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

NS_ASSUME_NONNULL_END
