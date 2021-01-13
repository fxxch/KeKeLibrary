//
//  KKAlbumAssetModalPreviewView.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"
#import "KKAlbumAssetModal.h"
#import "KKAlbumAssetModalPreviewItem.h"

@interface KKAlbumAssetModalPreviewView : KKView

@property (nonatomic , strong) NSMutableArray<KKAlbumAssetModal*> * _Nonnull itemsArray;
@property (nonatomic,assign)NSInteger nowSelectedIndex;

- (id _Nullable)initWithFrame:(CGRect)frame
                        items:(NSArray<KKAlbumAssetModal*>*_Nullable)aItemsArray
                selectedIndex:(NSInteger)aSelectedIndex
                     fromRect:(CGRect)aFromRect;

- (void)show;

@end

