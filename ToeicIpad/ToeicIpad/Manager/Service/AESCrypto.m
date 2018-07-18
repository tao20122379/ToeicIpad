//
//  AESCrypto.m
//
//  Created by Alan YU on 16/11/15.
//  Copyright © 2015 yDiva.com. All rights reserved.
//

#import "AESCrypto.h"

typedef struct {
    char ivData[kCCBlockSizeAES128];
    unsigned long dataLength;
} AES256Header;

@implementation AESCrypto

+ (NSData *)encrypt:(NSData *)data key:(NSString *)key {
    
    AES256Header header;
    
    char keyPointer[kCCKeySizeAES256 + 2];
    bzero(keyPointer, sizeof(keyPointer));
    
    NSData *ivData = [self generateRandomIV:kCCBlockSizeAES128];
    memcpy(header.ivData, [ivData bytes], [ivData length]);
    
    if ([key length] > kCCKeySizeAES256) {
        //NSLog(@"Will limit the key size to %d", kCCKeySizeAES256);
        key = [key substringToIndex:kCCKeySizeAES256];
    }
    [key getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    
    header.dataLength = [data length];
    
    //see https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/CCryptorCreateFromData.3cc.html
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block.
    size_t buffSize = header.dataLength + kCCBlockSizeAES128;
    void *buff = malloc(buffSize);
    
    size_t numBytesEncrypted = 0;
    
    //refer to http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
    //for details on this function
    //Stateless, one-shot encrypt or decrypt operation.
    CCCryptorStatus status = CCCrypt(kCCEncrypt,                    /* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128,            /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding,         /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer,
                                     kCCKeySizeAES256,  /* key and its length */
                                     header.ivData,                 /* initialization vector - use random IV everytime */
                                     [data bytes], [data length],   /* input  */
                                     buff, buffSize,                /* output */
                                     &numBytesEncrypted);
    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding|kCCOptionECBMode,
//                                          keyPtr, kCCKeySizeAES256,
//                                          NULL /* initialization vector (optional) */,
//                                          [self bytes], dataLength, /* input */
//                                          buffer, bufferSize, /* output */
//                                          &numBytesEncrypted);
    
    if (status == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
//        NSMutableData *result =  [NSMutableData dataWithBytes:&header length:sizeof(AES256Header)];
//        [result appendData:[NSData dataWithBytesNoCopy:buff length:numBytesEncrypted]];
        
//        return result;
    }
    
    free(buff);
    return nil;
}

+ (NSData *)decrypt:(NSData *)package key:(NSString *)key {
    
    AES256Header header;
    
    char keyPointer[kCCKeySizeAES256 + 2];
    bzero(keyPointer, sizeof(keyPointer));
    
    NSData *ivData = [self generateRandomIV:kCCBlockSizeAES128];
    memcpy(header.ivData, [ivData bytes], [ivData length]);
    header.dataLength = [package length];

//    NSUInteger dataLength = [package length] - headerLength;
    
//    [package getBytes:&header length:headerLength];
    
    NSData *data =package;//; [package subdataWithRange:NSMakeRange(headerLength, dataLength)];
    
    if ([key length] > kCCKeySizeAES256) {
        //NSLog(@"Will limit the key size to %d", kCCKeySizeAES256);
        key = [key substringToIndex:kCCKeySizeAES256];
    }
    [key getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    
    //see https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/CCryptorCreateFromData.3cc.html
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block.
    size_t buffSize = package.length + kCCBlockSizeAES128;
    
    void *buff = malloc(buffSize);
    
    size_t numBytesEncrypted = 0;
    
    //refer to http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
    //for details on this function
    //Stateless, one-shot encrypt or decrypt operation.
    CCCryptorStatus status = CCCrypt(kCCDecrypt,                    /* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128,            /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding,         /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer, kCCKeySizeAES256,  /* key and its length */
                                     header.ivData,                 /* initialization vector - use same IV which was used for decryption */
                                     [data bytes], [data length],   /* input */
                                     buff, buffSize,                /* output */
                                     &numBytesEncrypted);
    if (status == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
    }
    
    free(buff);
    return nil;
}

+ (NSData *)generateRandomIV:(size_t)length {
    
    NSMutableData *data = [NSMutableData new];
    
//    int err = SecRandomCopyBytes(kSecRandomDefault,
//                                   length,
//                                   data.mutableBytes);
    for (int i=0; i<16; i++) {
        Byte item=11;
        [data appendBytes:(const uint8_t*)&item length:1];
    }
    
//    if (err == 0) {
        return data;
//    }
    
    return nil;
    
}

/**
 * This function computes the SHA256 hash of input string
 * @param text input text whose SHA256 hash has to be computed
 * @param length length of the text to be returned
 * @return returns SHA256 hash of input text
 */
+ (NSString*) sha256:(NSString *)key length:(NSInteger) length{
    const char *s=[key cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    if(length > [hash length])
    {
        return  hash;
    }
    else
    {
        return [hash substringToIndex:length];
    }
}

@end
