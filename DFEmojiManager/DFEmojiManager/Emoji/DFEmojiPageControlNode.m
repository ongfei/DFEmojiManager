//
//  DFEmojiPageControlNode.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFEmojiPageControlNode.h"

@interface DFEmojiPageControlNode ()

@property (nonatomic, strong) UIPageControl *pageControl;
//@property (nonatomic, strong) UIView *dotView;

@end
@implementation DFEmojiPageControlNode

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        self.pageControl = [[UIPageControl alloc] init];
            self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"C0C0C0"];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"808080"];
        [self.pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
//        self.pageControl.frame = self.frame;
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureClick:)];
        [self.pageControl addGestureRecognizer:panG];
    }
    return self;
}

- (void)panGestureClick:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.pageControl];
    
    for (UIView *subV in self.pageControl.subviews) {
        if (subV.frame.origin.x <= point.x && point.x <= subV.frame.origin.x + subV.frame.size.width) {
            self.pageControl.currentPage = [self.pageControl.subviews indexOfObject:subV];
            if ([self.delegate respondsToSelector:@selector(emojiPageControlSelectIndex:)]) {
                [self.delegate emojiPageControlSelectIndex:self.pageControl.currentPage];
            }
        }
    }

}

- (void)pageControlClick:(UIPageControl *)pageControl {
    if ([self.delegate respondsToSelector:@selector(emojiPageControlSelectIndex:)]) {
        [self.delegate emojiPageControlSelectIndex:pageControl.currentPage];
    }
}

- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    
    _pageControl.numberOfPages = pageCount;
    //实现微信里面大圆点覆盖。 如果有需求 建议自定义page控件
//    if (pageControl.subviews.count == pageCount) {
//        [pageControl layoutSubviews];
//        CGRect frame = pageControl.subviews[0].frame;
//        self.dotView.frame = CGRectMake(frame.origin.x, frame.origin.y, 10, 10);
//    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    _pageControl.currentPage = currentPage;
//    if (pageControl.subviews.count > 0) {
//
//        CGRect frame = pageControl.subviews[currentPage].frame;
//
//        self.dotView.frame = CGRectMake(frame.origin.x, frame.origin.y, 10, 10);
//    }
}

//- (UiView *)dotView {
//    if (!_dotView) {
//        _dotView = [[UiView alloc] init];
//        _dotView.backgroundColor = [UIColor colorWithHexString:@"808080"];
//        _dotView.cornerRadius = 5;
//        _dotView.clipsToBounds = YES;
//        _dotView.frame = CGRectZero;
//        [self addSubview:_dotView];
//    }
//    return _dotView;
//}

@end
