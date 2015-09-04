//
//  RSAEncrypt.h
//  Test_RSA_Class
//
//  Created by Sywine on 4/14/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//公钥名字及后缀名
#define PubKeyFileName @"security"
#define PubKeyFileType @"der"

@interface RSAEncrypt : NSObject{
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

@end
