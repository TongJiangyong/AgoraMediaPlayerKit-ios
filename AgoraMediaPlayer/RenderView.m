//
//  RenderView.m
//  AgoraMediaPlayerKit
//
//  Created by 李晓晨 on 2019/7/5.
//  Copyright © 2019 李晓晨. All rights reserved.
//

#import "RenderView.h"

@implementation RenderView

- (void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    
     NSLog(@"render view frame: %f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
}
@end
