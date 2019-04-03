//
//  DFBaseView.h
//  DFEmojiManager
//
//  Created by ongfei on 2019/4/3.
//  Copyright © 2019 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>
#import <Masonry.h>

//根据bundle获取图片
#define kBundlePathImage(resource, extension, imgName, type) ([[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:imgName ofType:type])

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)


NS_ASSUME_NONNULL_BEGIN

@interface DFBaseView : UIView

@end

NS_ASSUME_NONNULL_END
