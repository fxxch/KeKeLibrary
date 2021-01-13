//
//  NSData+KKCommonCryptor.h
//  KKLibrary
//
//  Created by 刘波 on 2020/12/17.
//  Copyright © 2020 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kk_kCommonCryptoErrorDomain;

@interface NSData (KKCommonDigest)

- (NSData *) kk_MD2Sum;
- (NSData *) kk_MD4Sum;
- (NSData *) kk_MD5Sum;

- (NSData *) kk_SHA1Hash;
- (NSData *) kk_SHA224Hash;
- (NSData *) kk_SHA256Hash;
- (NSData *) kk_SHA384Hash;
- (NSData *) kk_SHA512Hash;

@end

@interface NSData (KKCommonCryptor)

- (NSData *) kk_AES256EncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) kk_decryptedAES256DataUsingKey: (id) key error: (NSError **) error;

- (NSData *) kk_DESEncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) kk_decryptedDESDataUsingKey: (id) key error: (NSError **) error;

- (NSData *) kk_CASTEncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) kk_decryptedCASTDataUsingKey: (id) key error: (NSError **) error;

@end

