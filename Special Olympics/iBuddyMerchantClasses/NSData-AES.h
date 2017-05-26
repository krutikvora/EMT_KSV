

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256
#define KEYBITS		128
#define AESEncryptionErrorDescriptionKey @"description"

/**
 A category representing
 AES encryption
 */
@interface NSData(AES)
- (NSData *)AESEncryptWithPassphrase:(NSString *)pass;
- (NSData *)AESDecryptWithPassphrase:(NSString *)pass;
@end
