

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256
#define KEYBITS		128

#define AESEncryptionErrorDescriptionKey	@"description"
/**
 A category representing
 AES encryption
 */
@interface NSFileManager(AES)
-(BOOL)AESEncryptFile:(NSString *)inPath toFile:(NSString *)outPath usingPassphrase:(NSString *)pass error:(NSError **)error;
-(BOOL)AESDecryptFile:(NSString *)inPath toFile:(NSString *)outPath usingPassphrase:(NSString *)pass error:(NSError **)error;
@end
