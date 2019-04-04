//
//  DFEmojiClassesBarNode.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFEmojiClassesBarNode.h"


@interface DFEmojiClassesBarNode ()

@property (nonatomic, strong) NSArray<NSString *> *sourceArr;
@property (nonatomic, strong) UIButton *addNode;
@property (nonatomic, strong) UIScrollView *scrollNode;
@property (nonatomic, strong) UIButton *senderNode;
@property (nonatomic, strong) NSMutableArray *scrollSubNode;
@property (nonatomic, strong) UIButton *selectedNode;

@end

@implementation DFEmojiClassesBarNode

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self prepareLayout];
    }
    return self;
}

- (void)prepareLayout {
    
    self.addNode = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.addNode setTitle:@"add" forState:(UIControlStateNormal)];
    [self.addNode addTarget:self action:@selector(addNodeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.addNode];
    //添加按钮右边线
    CALayer *addNodeBorder = [CALayer layer];
    addNodeBorder.frame = CGRectMake(39, 5, 0.5, 30);
    addNodeBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.addNode.layer addSublayer:addNodeBorder];
    
    self.scrollNode = [[UIScrollView alloc] init];
    self.scrollNode.showsVerticalScrollIndicator = NO;
    self.scrollNode.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollNode];
    
    self.senderNode = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.senderNode setTitle:@"发送" forState:UIControlStateNormal];
    [self.senderNode addTarget:self action:@selector(senderNodeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.senderNode.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self addSubview:self.senderNode];
    
    //发送按钮左边线
    CALayer *senderNodeBorder = [CALayer layer];
    senderNodeBorder.frame = CGRectMake(0, 1, 0.5, 38);
    senderNodeBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    senderNodeBorder.shadowOffset = CGSizeMake(-0.5,0);
    senderNodeBorder.shadowOpacity = 1;
    [self.senderNode.layer addSublayer:senderNodeBorder];
    
    [self.addNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    [self.senderNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    [self.scrollNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addNode.mas_right);
        make.right.equalTo(self.senderNode.mas_left);
        make.height.mas_equalTo(40);
    }];
}

- (void)setDelegate:(id<DFEmojiClassesBarDelegate>)delegate {
    _delegate = delegate;
    [self layoutSubNode];
}

- (void)layoutSubNode {
    self.scrollSubNode = [NSMutableArray array];
    if ([self.delegate respondsToSelector:@selector(arrayForEmojiClassesBar)]) {
        self.sourceArr = [NSArray arrayWithArray:[self.delegate arrayForEmojiClassesBar]];
    }else {
        self.sourceArr = [NSArray array];
    }
    UIButton *tempBtn = nil;
    for (NSString *imgPath in self.sourceArr) {
        
        UIButton *subBtnNode = [[UIButton alloc] init];
        [subBtnNode setImage:[UIImage imageWithContentsOfFile:imgPath] forState:(UIControlStateNormal)];
        [subBtnNode setBackgroundColor:[UIColor colorWithHexString:@"F5F5F5"]];
        [subBtnNode addTarget:self action:@selector(scrollSubNodeClick::) forControlEvents:(UIControlEventTouchUpInside)];
        //添加按钮右边线
        CALayer *nodeBorder = [CALayer layer];
        nodeBorder.frame = CGRectMake(41, 5, 0.5, 30);
        nodeBorder.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"].CGColor;
        [subBtnNode.layer addSublayer:nodeBorder];
        
        [self.scrollNode addSubview:subBtnNode];
        [self.scrollSubNode addObject:subBtnNode];
        [subBtnNode mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!tempBtn) {
                make.left.mas_equalTo(0);
            }else {
                make.left.equalTo(tempBtn.mas_right);
            }
            make.top.bottom.equalTo(self.scrollNode);
            make.width.equalTo(subBtnNode.mas_height);
        }];
        tempBtn = subBtnNode;
    }
    //默认选中第一个
    if (self.scrollSubNode.count >0) {
        [self scrollSubNodeClick:self.scrollSubNode.firstObject:NO];
    }
//    self.scrollNode.contentSize = CGSizeMake(self.scrollSubNode.count * 42 , 40);
    [self.scrollNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addNode.mas_right);
        make.right.equalTo(tempBtn.mas_right);
        make.height.mas_equalTo(40);
    }];

}

#pragma mark -  ----------layout----------
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (self.sourceArr.count > selectIndex) {
        UIButton *node = [self.scrollSubNode objectAtIndex:selectIndex];
        [self scrollSubNodeClick:node :YES];
        //scrollview 选中的在可见frame内
        if ((CGRectGetMaxX(node.frame) - self.scrollNode.contentOffset.x) > CGRectGetMaxX(self.scrollNode.frame)) {
            [self.scrollNode setContentOffset:CGPointMake(node.frame.origin.x - (KScreenWidth - 92) + node.frame.size.width, 0) animated:YES];
        }
        if (CGRectGetMaxX(node.frame) < self.scrollNode.contentOffset.x) {
            [self.scrollNode setContentOffset:CGPointMake(node.frame.origin.x, 0) animated:YES];
        }
    }
}

#pragma mark -  ----------action----------
- (void)addNodeClick:(UIButton *)node {
    NSLog(@"打印。。");
}

- (void)senderNodeClick:(UIButton *)node {
    NSLog(@"打印。。");
}

- (void)scrollSubNodeClick:(UIButton *)node :(BOOL)bo {
    node.selected = !node.selected;
    
    if (node.selected) {
        if (self.selectedNode) {
            self.selectedNode.backgroundColor = [UIColor clearColor];
            self.selectedNode.selected = NO;
        }
        self.selectedNode = node;
        node.backgroundColor = [UIColor darkGrayColor];
    }else {
        if (self.selectedNode != node) {
            node.backgroundColor = [UIColor clearColor];
            self.selectedNode = nil;
        }else {
            node.selected = YES;
        }
    }
    //点击的时候才会触发代理，滑动造成的不触发代理
    if (!bo) {
        if ([self.delegate respondsToSelector:@selector(didselectWithIndex:)]) {
            [self.delegate didselectWithIndex:[self.scrollSubNode indexOfObject:node]];
        }
    }
}

@end
