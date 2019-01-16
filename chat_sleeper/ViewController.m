//
//  ViewController.m
//  chatdemosleeperapp
//
//  Created by Mark Kim on 1/15/19.
//  Copyright © 2019 Mark Kim. All rights reserved.
//

#import "ViewController.h"
#import "MAAvatar.h"
#import "MAKeyboardView.h"
#import "MAMessage.h"
#import "MAMessageCell.h"
#import "MATextBank.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray<MAAvatar*>* avatars;
@property (nonatomic, strong) NSArray<NSString*>* textBank;
@property (nonatomic, strong) NSMutableArray<MAMessage*>* messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MAKeyboardView *keyboardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardViewWidthBottomLayoutConstraint;

@end

@implementation ViewController

- (void)scrollToLastVisibleMessageAnimated:(BOOL)animated {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:([_messages count]-1) inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (NSString *)getReadableDate:(NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterFullStyle];
}

// helper method to determine height of labels; source: https://stackoverflow.com/a/27374760/1198964
- (CGFloat)getLabelHeight:(UILabel*)label {
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (IBAction)didTapSend:(UIButton *)sender {
    [self textFieldShouldReturn:_keyboardView.textField];
}

- (void)setupCell:(MAMessageCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row >= [_messages count]) {
        return;
    }
    // populate cell
    MAMessage* message = _messages[row];
    cell.messageLabel.text = message.text;
    cell.dateLabel.text = message.dateString;
    cell.avatarImageView.image = [UIImage imageNamed:message.avatar.imageName];
    cell.messageLabel.layer.borderColor = message.avatar.textBorderColor.CGColor;
    cell.messageLabel.layer.borderWidth = 0.5;
    
    // size cell
    cell.messageLabelHeightLayoutConstraint.constant = [self getLabelHeight:cell.messageLabel];
}

// UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self setupCell:cell tableView:tableView indexPath:indexPath];
    return cell;
}

// UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // use dummy cell to determine height
    static MAMessageCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    });
    [self setupCell:cell tableView:tableView indexPath:indexPath];
    // guarantees visible space between avatar images (i.e., i didn't want the avatar images to overlap)
    return MAX(cell.avatarImageView.frame.size.height + cell.avatarImageTopLayoutConstraint.constant + 5.0,
               cell.messageLabelHeightLayoutConstraint.constant + cell.dateLabelHeightLayoutConstraint.constant);
}

// UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_keyboardView.textField resignFirstResponder];
}

// UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        MAMessage* message = [[MAMessage alloc] init];
        message.text = textField.text;
        message.dateString = [self getReadableDate:[NSDate date]];
        message.avatar = _avatars[0];
        [_messages addObject:message];
        textField.text = nil;
        [_tableView reloadData];
        [self scrollToLastVisibleMessageAnimated:YES];
    }
    return YES;
}

// Keyboard Notifications

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.25f animations:^{
        self.keyboardViewWidthBottomLayoutConstraint.constant = keyboardSize.height;
        [self.view layoutIfNeeded];
    }];
    [self scrollToLastVisibleMessageAnimated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.25f animations:^{
        self.keyboardViewWidthBottomLayoutConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

- (void)setupAvatars {
    // assume avatar at index 0 is our own avatar
    // the rest of the avatars are associated with other people
    _avatars = @[[MAAvatar avatarWithImageName:@"avatar_1" textBorderColor:[UIColor cyanColor]],
                 [MAAvatar avatarWithImageName:@"avatar_2" textBorderColor:[UIColor redColor]],
                 [MAAvatar avatarWithImageName:@"avatar_3" textBorderColor:[UIColor orangeColor]],
                 [MAAvatar avatarWithImageName:@"avatar_4" textBorderColor:[UIColor yellowColor]],
                 [MAAvatar avatarWithImageName:@"default_avatar" textBorderColor:[UIColor lightGrayColor]],
                 ];
}

- (void)testReceiveTextAtIndex:(NSNumber *)indexNum {
    NSInteger index = [indexNum integerValue];
    if (index < [_textBank count]) {
        MAMessage* message = [[MAMessage alloc] init];
        message.text = _textBank[index];
        message.dateString = [self getReadableDate:[NSDate date]];
        message.avatar = _avatars[arc4random_uniform((uint32_t)[_avatars count] - 1) + 1];
        [_messages addObject:message];
        [_tableView reloadData];
        // on other avatars' messages, only force scroll down if we are already near the bottom
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([_messages count] - 2) inSection:0];
        [_tableView visibleCells];
        if ([_tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self scrollToLastVisibleMessageAnimated:YES];
        }
        uint32_t randomDelay = arc4random_uniform(9) + 2;
        [self performSelector:@selector(testReceiveTextAtIndex:) withObject:@(index+1) afterDelay:randomDelay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAvatars];
    _textBank = [MATextBank randomizedTextBank];
    _messages = [NSMutableArray array];
    // for debug purposes to see if the tableView is adjusting properly
    _tableView.layer.borderColor = [UIColor greenColor].CGColor;
    _tableView.layer.borderWidth = 0.5;
    [self testReceiveTextAtIndex:0];
}

@end
