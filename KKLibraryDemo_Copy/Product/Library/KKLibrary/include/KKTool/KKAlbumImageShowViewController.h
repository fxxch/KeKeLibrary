//
//  KKAlbumImageShowViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKViewController.h"
#import "KKAlbumImagePickerManager.h"

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowViewControllerDelegate
#pragma mark ==================================================
@protocol KKAlbumImageShowViewControllerDelegate <NSObject>
@required

- (void)KKAlbumImageShowViewController_ClickedModal:(KKAlbumAssetModal*)aModal;

@end



@interface KKAlbumImageShowViewController : KKViewController

@property (nonatomic , weak) id<KKAlbumImageShowViewControllerDelegate> delegate;

/* 初始化 */
- (instancetype)initWithArray:(NSArray*)aImageArray
                  selectIndex:(NSInteger)aIndex;

@end
