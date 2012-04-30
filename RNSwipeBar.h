//
//  RNSwipeBar.h
//  RNSwipeBar
//
//  Created by Ryan Nystrom on 4/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kActiveSwipeModifier 0.90f

enum {
    // Tap the main view
    RNSwipeBarDismissTap = 1,
    // Swipe the bar down
    RNSwipeBarDismissSwipe = 2
};
typedef NSUInteger RNSwipeBarDismissType;

@protocol RNNotificationBarDelegate;

@interface RNSwipeBar : UIView
{
    BOOL _isHidden;
    BOOL _canMove;
    float _height;
    float _padding;
    float _animationDuration;
    RNSwipeBarDismissType _dismissType;
}

@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) UIView *view;
@property (strong) NSObject *delegate;

- (id)initWithMainView:(UIView*)view;
- (id)initWithMainView:(UIView*)view barView:(UIView*)barView;
- (void)setDismissType:(RNSwipeBarDismissType)dismissType;
- (void)setPadding:(float)padding;
- (void)show:(BOOL)shouldShow;
- (void)hide:(BOOL)shouldHide;
- (void)toggle;

@end

@protocol RNNotificationBarDelegate

@optional

- (void)notificationBarDidAppear:(id)sender;
- (void)notificationBarWillAppear:(id)sender;
- (void)notificationBarDidDisappear:(id)sender;
- (void)notificationBarWillDisappear:(id)sender;

@end