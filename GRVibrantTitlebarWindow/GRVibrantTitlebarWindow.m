//
//  GRVibrantTitlebarWindow.m
//  Visual Experiments
//
//  Created by Guilherme Rambo on 23/08/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRVibrantTitlebarWindow.h"

#import "GRVibrantTitlebarView.h"
#import "GRVibrantTitleView.h"

@interface GRVibrantTitlebarWindow ()

@property (nonatomic, assign) NSWindowTitleVisibility internalTitleVisibility;
@property (nonatomic, strong) GRVibrantTitlebarView *titlebarView;

@end

@implementation GRVibrantTitlebarWindow

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.styleMask |= NSFullSizeContentViewWindowMask;
    self.titlebarAppearsTransparent = YES;
    
    [self setupTitlebar];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillEnterFullScreenNotification object:self queue:nil usingBlock:^(NSNotification *note) {
        if (self.hidesTitlebarWhenFullscreen) [self.titlebarView setHidden:YES];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillExitFullScreenNotification object:self queue:nil usingBlock:^(NSNotification *note) {
        if (self.hidesTitlebarWhenFullscreen) [self.titlebarView setHidden:NO];
    }];
    
    // defaults
    self.titleVisibility = NSWindowTitleVisible;
    self.titlebarAppearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    self.hidesTitlebarWhenFullscreen = NO;
}

- (void)setupTitlebar
{
    if (self.titlebarView) return;
    
    // create a vibrant titlebar view and put it in the window
    self.titlebarView = [[GRVibrantTitlebarView alloc] initWithFrame:NSMakeRect(0, NSHeight(self.frame)-60, NSWidth(self.frame), 60)];
    self.titlebarView.autoresizingMask = NSViewMinYMargin|NSViewWidthSizable;
    self.titlebarView.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    
    [self.contentView addSubview:self.titlebarView];
}

#pragma mark Setters

- (void)setTitlebarAppearance:(NSAppearance *)titlebarAppearance
{
    self.titlebarView.appearance = titlebarAppearance;
}

- (void)setTitleVisibility:(NSWindowTitleVisibility)titleVisibility
{
    self.internalTitleVisibility = titleVisibility;
    
    [super setTitleVisibility:NSWindowTitleHidden];
}

- (void)setInternalTitleVisibility:(NSWindowTitleVisibility)internalTitleVisibility
{
    _internalTitleVisibility = internalTitleVisibility;
    
    self.titlebarView.titleView.hidden = (self.internalTitleVisibility == NSWindowTitleHidden) ? YES : NO;
}

@end
