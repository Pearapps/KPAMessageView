//
//  KPAMessageView.h
//  KPAMessageViewDemo
//
//  Created by Kenneth Parker Ackerson on 5/30/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KPAMessageViewPosition) {
    KPAMessageViewPositionBottom,
    KPAMessageViewPositionTop, // Beta
};

@class KPAMessageView;
@protocol KPAMessageViewDelegate <NSObject>

@optional
- (void)didDismissMessageView:(KPAMessageView *)view;
- (void)didShowMessageView:(KPAMessageView *)view;
- (void)didTapMessageView:(KPAMessageView *)view;

@end

@interface KPAMessageView : UIView

- (id)initWithMessage:(NSAttributedString *)message withPresentationPosition:(KPAMessageViewPosition)position;
- (void)showInView:(UIView *)view;
- (void)show;
- (void)dismissAfterDelay:(NSTimeInterval)timeInterval;
- (void)dismiss;
- (void)addCloseButton;

@property (nonatomic, weak) id <KPAMessageViewDelegate> delegate;

@end
