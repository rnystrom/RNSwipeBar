//  Created by Ryan Nystrom on 4/14/12.
//
//  Copyright (C) 2012 Ryan Nystrom
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RNSwipeBar.h"

@interface RNSwipeBar ()

//  Gesture handler for swiping
- (void)barViewWasSwiped:(UIPanGestureRecognizer*)recognizer;
//  Finishes animating the bar if not completely swiped up/down
- (void)completeAnimation:(BOOL)show;

@end

@implementation RNSwipeBar

@synthesize parentView = _parentView;
@synthesize delegate = _delegate;
@synthesize barView = _barView;

#pragma mark - Init

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
    }
    return self;
}

- (id)initWithMainView:(UIView *)view
{
    if (self = [self init]) {
        [self setParentView:view];
        
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
    if (self = [self initWithMainView:view]) {
        _height = barView.frame.size.height;
        _barView = barView;
        [self addSubview:_barView];
    }
    return self;
}

#pragma mark - Display methods

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

#pragma mark - UIGestureRecognizer handlers

- (void)barViewWasSwiped:(UIPanGestureRecognizer*)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:_parentView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _canMove = YES;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(swipebarWasSwiped:)]) {
                [self.delegate swipebarWasSwiped:self];
            }
        }
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

#pragma mark - Private methods

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
    } completion:^(BOOL finished){
        if (finished && self.delegate) {
            if (show && [self.delegate respondsToSelector:@selector(swipeBarDidAppear:)]) {
                [self.delegate swipeBarDidAppear:self];
            }
            else if (!show && [self.delegate respondsToSelector:@selector(swipeBarDidDisappear:)]) {
                [self.delegate swipeBarDidDisappear:self];
            }
        }
    }];
}

#pragma mark - Getters/Setters

- (void)setBarView:(UIView *)view
{
    _barView = view;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _barView.frame.size.width, _barView.frame.size.height)];
    
    [self addSubview:_barView];
}

- (void)setPadding:(float)padding
{
    _padding = padding;
    CGRect oldFrame = self.frame;
    float yOrigin = self.parentView.frame.size.height - padding;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, yOrigin, oldFrame.size.width, oldFrame.size.height);
    [self setFrame:newFrame];
}

- (BOOL)isHidden
{
    return _isHidden;
}

@end