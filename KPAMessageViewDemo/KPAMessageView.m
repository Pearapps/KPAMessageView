//
//  KPAMessageView.m
//  KPAMessageViewDemo
//
//  Created by Kenneth Parker Ackerson on 5/30/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//
#import "KPAMessageView.h"

@interface KPAMessageView ()

@property (nonatomic, assign) BOOL isDismissing;

@property (nonatomic, assign) KPAMessageViewPosition position;

- (void)didDismiss;
- (void)didShow;

@end

@interface KPAMessagePresenter : NSObject <UIGestureRecognizerDelegate>

@end

@implementation KPAMessagePresenter

- (void)showMessageView:(KPAMessageView *)messageView toView:(UIView *)view {
    [view addSubview:messageView];
    [messageView setCenter:[self offScreenForMessageView:messageView forSuperView:view]];
    [UIView animateWithDuration:0.3 animations:^{
        [messageView setCenter:[self onScreenForMessageView:messageView forSuperView:view]];
    } completion:^(BOOL finished) {
        if (finished) {
            [messageView didShow];
        }
    }];
    
}

- (void)dismissMessageView:(KPAMessageView *)messageView {
    
    if (messageView.isDismissing) {
        return;
    }
    
    messageView.isDismissing = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [messageView setCenter:[self offScreenForMessageView:messageView forSuperView:messageView.superview]];
    } completion:^(BOOL finished) {
        if (finished) {
            [messageView removeFromSuperview];
            [messageView didDismiss];
        }
    }];
}

#pragma mark - Private -

- (CGPoint)offScreenForMessageView:(KPAMessageView *)messageView forSuperView:(UIView *)superView {
    if (messageView.position == KPAMessageViewPositionBottom) {
        return CGPointMake(CGRectGetMidX([superView bounds]), CGRectGetMaxY([superView bounds]) + CGRectGetMaxY(messageView.bounds)/2.f);
    } else {
        return CGPointMake(CGRectGetMidX([superView bounds]), 0 - CGRectGetMaxY(messageView.bounds)/2.f);
    }
}

- (CGPoint)onScreenForMessageView:(KPAMessageView *)messageView forSuperView:(UIView *)superView {
    if (messageView.position == KPAMessageViewPositionBottom) {
        return CGPointMake(CGRectGetMidX([superView bounds]), CGRectGetMaxY([superView bounds]) - CGRectGetMaxY(messageView.bounds)/2.f);
    } else {
        return CGPointMake(CGRectGetMidX([superView bounds]), 0 + CGRectGetMaxY(messageView.bounds)/2.f);
    }
}

@end

@implementation KPAMessageView

static KPAMessagePresenter *presenter = nil;

- (id)initWithMessage:(NSAttributedString *)message withPresentationPosition:(KPAMessageViewPosition)position {
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 55)];
    if (self) {
        
        if (!presenter) {
            presenter = [[KPAMessagePresenter alloc] init];
        }
        
        self.position = position;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *messageLabel = [[UILabel alloc] init];
        [messageLabel setAttributedText:message];
        [messageLabel setNumberOfLines:0];
        CGSize size = [messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds)*0.8, CGRectGetHeight(self.bounds))];
        [messageLabel setBounds:CGRectMake(0, 0, size.width, size.height)];
        [messageLabel setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [self addSubview:messageLabel];
        
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
    [presenter showMessageView:self toView:view];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showInView:[[UIApplication sharedApplication] keyWindow]];
    });
}

- (void)dismiss {
    [presenter dismissMessageView:self];
}

- (void)addCloseButton {
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"X" forState:UIControlStateNormal];
    [close sizeToFit];
    [close setCenter:CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(close.bounds)/2 - 5, CGRectGetMidY(self.bounds))];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
}

- (void)dismissAfterDelay:(NSTimeInterval)timeInterval {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

#pragma mark - Private -

- (void)tapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageView:)]) {
        [self.delegate didTapMessageView:self];
    }
}

- (void)didShow {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowMessageView:)]) {
        [[self delegate] didShowMessageView:self];
    }
}

- (void)didDismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissMessageView:)]) {
        [[self delegate] didDismissMessageView:self];
    }
}

@end