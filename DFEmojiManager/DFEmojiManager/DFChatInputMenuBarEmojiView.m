//
//  DFChatInputMenuBarEmojiView.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/14.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFChatInputMenuBarEmojiView.h"
#import "DFEmojiManager.h"
#import "DFEmojiContentNode.h"
#import "DFEmojiPageControlNode.h"
#import "DFEmojiClassesBarNode.h"

@interface DFChatInputMenuBarEmojiView ()<DFEmojiClassesBarDelegate,EmojiContentDelegate,EmojiPageControlDelegate>

@property (nonatomic, strong) DFEmojiContentNode *contentNode;
@property (nonatomic, strong) DFEmojiPageControlNode *pageNode;
@property (nonatomic, strong) DFEmojiClassesBarNode *barNode;

@end

@implementation DFChatInputMenuBarEmojiView
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self prepareLayout];
    }
    return self;
}

- (void)prepareLayout {
    
    self.pageNode = [[DFEmojiPageControlNode alloc] init];
    self.pageNode.delegate = self;
    [self addSubview:self.pageNode];
    
    self.contentNode = [[DFEmojiContentNode alloc] init];
    self.contentNode.delegate = self;
    [self addSubview:self.contentNode];
    
    self.barNode = [[DFEmojiClassesBarNode alloc] init];
    [self addSubview:self.barNode];
    
    self.barNode.delegate = self;
   
    [self.contentNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(160);
    }];
    [self.pageNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.contentNode.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    [self.barNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.pageNode.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.height.mas_equalTo(40 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom);
        } else {
            make.height.mas_equalTo(40);
        }
    }];
}


#pragma mark -  ----------delegateForBar----------
-(NSArray<NSString *> *)arrayForEmojiClassesBar {
    NSMutableArray *arr = [NSMutableArray array];
    for (DFEmojiPlist *plist in [[DFEmojiManager shareInstance] allEmojis]) {
        NSString *path = kBundlePathImage(@"Emojis", @"bundle", plist.classes, @"png");
        [arr addObject:path];
    }
    return arr;
}

- (void)didselectWithIndex:(NSInteger)index {
    [self.contentNode scrollToSection:index];
}

#pragma mark -  ----------delegateForContent----------
/**
 总共有几种表情包
 */
- (NSInteger)allClassesOfEmojiContent {
    return [DFEmojiManager shareInstance].allEmojis.count;
}
//当前index表情包所有元素
- (NSArray<DFEmojiModel *> *)allItemOfEmojiContentForClassesIndex:(NSInteger)ClassesIndex {
    
    DFEmojiManager *emojiManager = [DFEmojiManager shareInstance];
    //emoji加入删除按钮 数据
    if (ClassesIndex == 0) {
        DFEmojiPlist *plist = emojiManager.allEmojis[0];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:plist.emojis];
        int i = 0;
        while (i < plist.emojis.count) {
            if ((i+1) % 24 == 0 && i != 0) {
                DFEmojiModel *model = [[DFEmojiModel alloc] init];
                model.emojiName = @"delete-emoji";
                [arr insertObject:model atIndex:i];
            }
            i++;
        }
        
        return arr;
    }
    
    return emojiManager.allEmojis[ClassesIndex].emojis;
}

- (void)currentPageOfEmojiContent:(NSInteger)page {
    self.pageNode.currentPage = page;
}

- (void)pageCountOfEmojiContent:(NSInteger)count {
    self.pageNode.pageCount = count;
}

- (void)currentSectionOfEmojiContent:(NSInteger)section {
    self.barNode.selectIndex = section;
}

- (void)emojiPageControlSelectIndex:(NSInteger)index {
    [self.contentNode scrollToItem:index];
}
//长按emoji删除按钮
- (void)emojiDeleteBtnClick {
    if (self.EmojiDeleteBlock) {
        self.EmojiDeleteBlock();
    }
}

- (void)didSelectWithIndexPath:(NSIndexPath *)indexP andImg:(UIImage *)img desc:(NSString *)desc path:(NSString *)path isDelete:(BOOL)isDelete {
    if (isDelete) {
        [self emojiDeleteBtnClick];
    }else {
        if (self.EmojiSelectBlock) {
            self.EmojiSelectBlock(indexP.section, desc, path, img);
        }
    }
}


@end
