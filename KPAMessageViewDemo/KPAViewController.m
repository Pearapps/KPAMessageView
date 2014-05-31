//
//  KPAViewController.m
//  KPAMessageViewDemo
//
//  Created by Kenneth Parker Ackerson on 5/30/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KPAViewController.h"
#import "KPAMessageView.h"

@interface KPAViewController () <KPAMessageViewDelegate>

@end

@implementation KPAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak id weakSelf = self;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"Create An Account: Secure your data by creating an account."];
    
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:15] range:NSMakeRange(0, att.string.length)];
    [att addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[[att string] rangeOfString:@"Create An Account:"]];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, att.string.length)];
    
    KPAMessageView *messageView = [[KPAMessageView alloc] initWithMessage:att withPresentationPosition:KPAMessageViewPositionBottom];
    [messageView show];
    [messageView setDelegate:weakSelf];
    [messageView dismissAfterDelay:10];
    [messageView addCloseButton];
}

- (void)didDismissMessageView:(KPAMessageView *)view {
    NSLog(@"%@", view);
}

- (void)didTapMessageView:(KPAMessageView *)view {
    [view dismiss];
}

@end
