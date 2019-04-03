//
//  ViewController.m
//  DFEmojiManager
//
//  Created by ongfei on 2019/4/3.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "ViewController.h"
#import "DFChatInputMenuBarEmojiView.h"

@interface ViewController ()

@property (nonatomic, strong) DFChatInputMenuBarEmojiView *emojiView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setTitle:@"点我呀" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 50, 50);
    [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.selected = YES;
    
    self.emojiView.EmojiSelectBlock = ^(NSInteger section, NSString * _Nonnull desc, NSString * _Nonnull path, UIImage * _Nonnull img) {
        NSLog(@"%@---%@---%@",desc,path,img);
    };
}

- (void)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    }else {
        [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(250);

        }];
    }
}

- (DFChatInputMenuBarEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[DFChatInputMenuBarEmojiView alloc] init];
        [self.view addSubview:_emojiView];
        [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.height.mas_equalTo(220);
        }];
    }
    return _emojiView;
}


@end
