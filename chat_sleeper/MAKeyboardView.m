//
//  MATextView.m
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/15/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import "MAKeyboardView.h"

@interface MAKeyboardView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonWidthConstraint;

@end

@implementation MAKeyboardView

- (void)layoutSubviews {
    // determine text field width constraint constant based on width of MATextView
    [super layoutSubviews];
    _textFieldWidthConstraint.constant = self.bounds.size.width - _sendButtonWidthConstraint.constant - _textFieldLeadingConstraint.constant;
}

@end
