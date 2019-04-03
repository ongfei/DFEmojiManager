//
//  DFEmojiPreviewImageView.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/27.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFEmojiPreviewImageView.h"

@interface DFEmojiPreviewImageView ()


@end
@implementation DFEmojiPreviewImageView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.emojiImageView.frame = CGRectMake(30, 10, self.frame.size.width - 60, self.frame.size.width - 60);
    self.descriptionLabel.frame = CGRectMake(10,CGRectGetMaxY(self.emojiImageView.frame) + 10, self.frame.size.width - 20, 30);
}

- (UIImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
        [self addSubview:_emojiImageView];
    }
    return _emojiImageView;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        [self addSubview:_descriptionLabel];
        _descriptionLabel.font = [UIFont systemFontOfSize:13.0];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel;
}

-(void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineWidth = 1;
    //边距1、画弧直径10
    CGPoint topLeftArcCenter = CGPointMake(11,11);
    CGPoint topRightArcCenter = CGPointMake(self.frame.size.width - 11,11);
    CGPoint bottomLeftArcCenter = CGPointMake(11,self.frame.size.height - 20);
    CGPoint bottomRightArcCenter = CGPointMake(self.frame.size.width - 11,self.frame.size.height - 20);
    
    self.sharpPoint = CGPointMake(self.sharpPoint.x - self.frame.origin.x, self.sharpPoint.y - self.frame.origin.y);
    [path moveToPoint:self.sharpPoint];
    
    [path addLineToPoint:CGPointMake(self.sharpPoint.x - 10,self.sharpPoint.y - 10)];
    [path addLineToPoint:CGPointMake(10,self.sharpPoint.y - 10)];
    [path addArcWithCenter:bottomLeftArcCenter radius:10 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(1,10)];
    [path addArcWithCenter:topLeftArcCenter radius:10 startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 10,1)];
    [path addArcWithCenter:topRightArcCenter radius:10 startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width- 1, self.sharpPoint.y -20)];
    [path addArcWithCenter:bottomRightArcCenter radius:10 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.sharpPoint.x + 10, self.sharpPoint.y - 10)];
    
    [[UIColor colorWithWhite:0.866 alpha:1] setStroke];
    [[UIColor colorWithWhite:1 alpha:0.92] setFill];
    [path fillWithBlendMode:(kCGBlendModeNormal) alpha:0.92];
    [path closePath];
    [path stroke];

}

@end
