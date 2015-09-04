//
//  HYJSocketEnCodeDeCode.m
//  聊天
//
//  Created by weststar on 13-2-7.
//  Copyright (c) 2013年 weststar. All rights reserved.
//

#import "EnCodeDeCode.h"
@implementation EnCodeDeCode

//加密
+ (NSData *)encode:(NSData*)data
{
    int portId = 10;
    NSMutableData *allData = [[NSMutableData alloc]init];
    NSData *portIdData = [NSData dataWithBytes:&portId length: sizeof(portId)];
    [allData appendData:portIdData];
    [allData appendData:data];
    
    return [EnCodeDeCode binaryEncode:allData];
}

//解密
+ (NSData *)decode:(NSData*)data
{
    return [EnCodeDeCode binaryDecode:data];
}

//数据处理
+ (NSData *)dataWithLongLong:(long long)intNumber
{
    NSData *data = [NSData dataWithBytes:&intNumber length:sizeof(intNumber)];
    return data;
}

+ (NSData *)dataWithInt:(int)intNumber
{
    NSData *data = [NSData dataWithBytes:&intNumber length:sizeof(intNumber)];
    return data;
}

+ (NSData *)NSDataFromNSString:(NSString *)nsstring
{
    NSData *nsdata = [nsstring dataUsingEncoding:NSASCIIStringEncoding];
    return nsdata;
}

+ (long long)longlongWithData:(NSData *)data
{
    long long intNumber;
    [data getBytes:&intNumber length:sizeof(intNumber)];
    return intNumber;
}

+ (int)intWithData:(NSData *)data
{
    int intNumber;
    [data getBytes:&intNumber length:sizeof(intNumber)];
    return intNumber;
}

+ (NSString *)NSStringFromNSData:(NSData *)nsdata
{
    NSString *nsstring = [[NSString alloc] initWithData:nsdata encoding:NSASCIIStringEncoding];
    return nsstring;
}

//加密
+ (NSMutableData*) nfxEncode:(NSData*)data key:(int)key
{
    int datalen = (int)data.length;
    
    Byte *tempByte = (Byte *)[data bytes];
    Byte *tempLaByte = (Byte *)malloc(datalen);
    
    key = key % 255;
    key = key >= 0 ? key : -key;

    for (int len = 0; len < datalen; len++) {
        int code =  tempByte[len];
        code += key;
        code = code <= 255 ? code : (code - 256);
        tempLaByte[len] = (Byte) (code ^ 0xff);
    }

    NSMutableData* returnlist = [[NSMutableData alloc]initWithBytes:tempLaByte length:datalen];
    free(tempLaByte);
    
    return returnlist;
}

//二进制编码
+ (NSData*) binaryEncode:(NSData *)actionContent
{
    NSMutableData *buf = [[NSMutableData alloc]init];
	NSMutableData *bufTemp = [[NSMutableData alloc]init];
    
    int z = 0;
    int datalength = (int)actionContent.length + 30;
    
    short key = 1;
    
    [buf appendBytes:&z length:sizeof((short)z)];
    [buf appendBytes:&datalength length:sizeof((short)datalength)];
    [buf appendBytes:&key length:sizeof(key)];
    
    for(unsigned i = 0; i < 6; ++i)
    {
        [bufTemp appendBytes:&z length:sizeof(z)];
    }
    
    [bufTemp appendData:actionContent];
    bufTemp = [self nfxEncode:bufTemp key:(datalength-key)];
    [buf appendData:bufTemp];
    
    return buf;
}

//解密
+ (Byte*) nfxDecode:(Byte *)baseBytes length:(int)length key:(int)key
{
    int code = 0;
    int datalen = length;
    
    Byte *returnlist = (Byte *)malloc(sizeof(Byte) * datalen);
    
    key = key % 255;
    key = key >= 0 ? key : -key;
    
    for (int len  = 0; len < datalen; len++) {
        code = baseBytes[len] ^ 0xff;
        code = code >= key ? code - key : 256 + code - key;
        returnlist[len] = (Byte) code;
    }
    
    return returnlist;
}

//二进制解码
+ (NSData *) binaryDecode:(NSData *)inputData
{
    static int RUBBISH_HEADER_LENGTH = 30;
    
    short s;
    short length;
    short key;
    
    if (inputData.length < RUBBISH_HEADER_LENGTH) {
        return nil;
    }
    
    [inputData getBytes:&s length:2];
    [inputData getBytes:&length range:NSMakeRange(2,2)];
    [inputData getBytes:&key range:NSMakeRange(4,2)];
    
    int realLength = length - 6;
    
    if (inputData.length < realLength) {
        return nil;
    }
    
    Byte dst[realLength];
    [inputData getBytes:&dst range:NSMakeRange(6,realLength)];
    Byte *buf = [self nfxDecode:dst length:realLength key:(length - key)];
    NSData *data = [[NSData alloc] initWithBytes:buf length:realLength];
    
    free(buf);
    
    int DeCodeCode;
    NSData *DeCodeContent;
    [data getBytes:&DeCodeCode range:NSMakeRange((24),sizeof(int))];
    DeCodeContent = [data subdataWithRange:NSMakeRange((28),realLength-28)];
    
    return DeCodeContent;
}

@end
