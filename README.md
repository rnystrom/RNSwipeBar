RNSwipeBar
=========

RNSwipeBar is a lightweight iOS widget, optimized for iPhone/iPod Touch projects, that takes back roughly 44px of UI space. The bar works rather simply: create a UIView that contains all of your necessary objects and images for the bar. This is usually created completely custom. I left out any bar building parts because I want to leave it open ended how this is used. If you are interested in *how* to create a custom bar for this widget, please take a look at the included example.

### Installation

Simple. Drag and drop RNSwipeBar.h and RNSwipeBar.m into your project. RNSwipeBar is designed to be used with ARC, iOS 5+ projects **only**. If you really, really need this project in non-ARC I wouldn't mind revising it (but you should really be targetting iOS 5+ anyways).

### Usage

Simply initialize the RNSwipeBar, set up your properties, and add it to your view. RNSwipeBar will handle gestures by itself. 

    RNSwipeBar *swipeBar = [[RNSwipeBar alloc] initWithMainView:self.view];
    [swipeBar setPadding:20.0f];
    [self.view addSubview:swipeBar];

I did include some convenience methods to handle toggling of the bar without the swipe gestures.

    - (void)show:(BOOL)shouldShow;
    - (void)hide:(BOOL)shouldHide;
    - (void)toggle;

Bear in mind that <code>show:</code> and hide: are exactly the same method, just opposite effects. The idea is to allow you some flexibility in fitting your semantics. For me, toggle is the most frequently used.

### Customizing

Really the only thing that you need to worry about is the padding. Here I'm using padding as a property to describe how far (in pixels) from the bottom of your view should the RNSwipeBar stick out.
