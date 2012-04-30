//
//  RNNotificationBar.m
//  RNNotificationBar
//
//  Created by Ryan Nystrom on 4/14/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNSwipeBar.h"

@interface RNSwipeBar ()

- (void)mainViewWasSwiped:(UIPanGestureRecognizer*)recognizer;
- (void)barViewWasSwiped:(UIPanGestureRecognizer*)recognizer;
- (void)completeAnimation:(BOOL)show;

@end

@implementation RNSwipeBar

@synthesize parentView = _parentView;
@synthesize delegate = _delegate;
@synthesize view = _view;

- (id)init
{
    if (self = [super init]) {
        _isHidden = YES;
        _canMove = NO;
        _height = 88.0f;
        _padding = 0.0f;
        _animationDuration = 0.1f;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:NO];
        [self setDismissType:RNSwipeBarDismissTap];
    }
    return self;
}

- (id)initWithMainView:(UIView *)view
{
    if (self = [self init]) {
        [self setParentView:view];
        
        UIPanGestureRecognizer *swipeUp = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewWasSwiped:)];
        [_parentView addGestureRecognizer:swipeUp];
        UIPanGestureRecognizer *swipeDown = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(barViewWasSwiped:)];
        [self addGestureRecognizer:swipeDown];        
        
        CGRect parentFrame = _parentView.frame;
        CGRect frame = CGRectMake(0, parentFrame.size.height, parentFrame.size.width, _height);
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithMainView:(UIView*)view barView:(UIView*)barView
{
    _height = barView.frame.size.height;
    _view = barView;
    [self addSubview:_view];
    return [self initWithMainView:view];
}

- (void)show:(BOOL)shouldShow
{
    [self completeAnimation:shouldShow];
}

- (void)hide:(BOOL)shouldHide
{
    [self completeAnimation:(!shouldHide)];
}

- (void)toggle
{
    [self completeAnimation:_isHidden];
}

- (void)mainViewWasSwiped:(UIPanGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:_parentView];
    if (recognizer.state == UIGestureRecognizerStateBegan && _isHidden) {
        float mainViewThreshhold = kActiveSwipeModifier * self.parentView.frame.size.height;
        if (swipeLocation.y > mainViewThreshhold) {
            _canMove = YES;
            return;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged && _canMove) {
        float maxYPosition = self.parentView.frame.size.height - self.frame.size.height;
        if (swipeLocation.y > maxYPosition) {
            CGRect frame = CGRectMake(self.frame.origin.x, swipeLocation.y, self.frame.size.width, self.frame.size.height);
            [self setFrame:frame];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded && _canMove) {
        float pivotYPosition = self.parentView.frame.size.height - self.frame.size.height / 2;
        _canMove = NO;
        [self completeAnimation:(self.frame.origin.y < pivotYPosition)];
    }
}

- (void)barViewWasSwiped:(UIPanGestureRecognizer*)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:_parentView];
    if (recognizer.state == UIGestureRecognizerStateBegan && ! _isHidden) {
        _canMove = YES;
        return;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged && _canMove) {
        float maxYPosition = self.parentView.frame.size.height - self.frame.size.height;
        if (swipeLocation.y > maxYPosition) {
            CGRect frame = CGRectMake(self.frame.origin.x, swipeLocation.y, self.frame.size.width, self.frame.size.height);
            [self setFrame:frame];
        }
        return;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded && _canMove) {
        float pivotYPosition = self.parentView.frame.size.height - self.frame.size.height / 2;
        _canMove = NO;
        [self completeAnimation:(self.frame.origin.y < pivotYPosition)];
        return;
    }
}

- (void)completeAnimation:(BOOL)show
{
    _isHidden = !show;
    CGRect parentFrame = self.parentView.frame;
    CGRect goToFrame;
    if (show) {
        goToFrame = CGRectMake(self.frame.origin.x, parentFrame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
    else {
        goToFrame = CGRectMake(self.frame.origin.x, parentFrame.size.height - _padding, self.frame.size.width, self.frame.size.height);
    }
    [UIView animateWithDuration:_animationDuration animations:^{
        [self setFrame:goToFrame];
    }];
}

- (void)setDismissType:(RNSwipeBarDismissType)dismissType
{
    _dismissType = dismissType;
    if (_parentView && dismissType) {
        switch (dismissType) {
            case RNSwipeBarDismissTap:
                break;
            case RNSwipeBarDismissSwipe:
                break;
        }
    }
}

- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
    if (_dismissType) {
        [self setDismissType:_dismissType];
    }
    else {
        [self setDismissType:RNSwipeBarDismissTap];
    }
}

- (void)setView:(UIView *)view
{
    _view = view;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _view.frame.size.width, _view.frame.size.height)];
    
    [self addSubview:_view];
}

- (void)setPadding:(float)padding
{
    _padding = padding;
    CGRect oldFrame = self.frame;
    float yOrigin = self.parentView.frame.size.height - padding;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, yOrigin, oldFrame.size.width, oldFrame.size.height);
    [self setFrame:newFrame];
}

@end