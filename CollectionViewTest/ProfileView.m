//
//  ProfileView.m
//  CollectionViewTest
//
//  Created by Takashi Kawakami on 2016/02/07.
//  Copyright © 2016年 Takashi Kawakami. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

@end
