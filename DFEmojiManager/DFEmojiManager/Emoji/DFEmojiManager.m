//
//  DFEmojiManager.m
//  AlumniRecord
//
//  Created by ongfei on 2019/3/17.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import "DFEmojiManager.h"


//根据bundle获取图片
#define kBundlePathImage(resource, extension, imgName, type) ([[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:imgName ofType:type])

@interface DFEmojiManager ()

@property (nonatomic, strong, readwrite) NSArray<DFEmojiPlist *> *allEmojis;

@end

@implementation DFEmojiManager

static DFEmojiManager *instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initEmojis];
    }
    return self;
}

- (void)initEmojis {
    
    NSString *path = [NSBundle.mainBundle pathForResource:@"EmojisInfo" ofType:@"plist"];
    if (!path) {
        return;
    }
    
    NSArray *sourceArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *allEmojisArr = [NSMutableArray array];
    for (NSDictionary *dic in sourceArray) {
        DFEmojiPlist *plist = [[DFEmojiPlist alloc] init];
        plist.classes = dic[@"classes"];
        NSArray *emojiArr = dic[@"emoticons"];
        NSMutableArray<DFEmojiModel *> *emojis = [NSMutableArray array];
        for (NSDictionary *emojiDict in emojiArr) {
            DFEmojiModel *emoji = [[DFEmojiModel alloc] init];
            emoji.emojiName = emojiDict[@"image"];
            emoji.emojiDescription = emojiDict[@"desc"];
            [emojis addObject:emoji];
        }
        plist.emojis = emojis;
        [allEmojisArr addObject:plist];
    }
    
    [allEmojisArr addObjectsFromArray:allEmojisArr];
    [allEmojisArr addObjectsFromArray:allEmojisArr];
    [allEmojisArr addObjectsFromArray:allEmojisArr];

    self.allEmojis = allEmojisArr;
}

- (NSString *)emojiPathWithEmojiDescription:(NSString *)emojiDescription {
    if (!emojiDescription.length) {
        return nil;
    }
    if ([emojiDescription containsString:@"["] ) {
        NSRange range = [emojiDescription rangeOfString:@"["];
        NSRange newRange = NSMakeRange(range.location + range.length, emojiDescription.length - range.location - range.length);
        emojiDescription = [emojiDescription substringWithRange:newRange];

    }
    if ([emojiDescription containsString:@"]"]) {
        NSRange range = [emojiDescription rangeOfString:@"]"];
        NSRange newRange = NSMakeRange(0, range.location);
        emojiDescription = [emojiDescription substringWithRange:newRange];
    }
    for (DFEmojiPlist *plist in self.allEmojis) {
        for (DFEmojiModel *emoji in plist.emojis) {
            if ([emoji.emojiDescription isEqualToString:emojiDescription]) {
                NSString *path = kBundlePathImage(@"Emojis", @"bundle", emoji.emojiName, @"png");
                return path;
            }
        }
    }
    return nil;
}


@end

@implementation DFEmojiModel

@end

@implementation DFEmojiPlist

@end
