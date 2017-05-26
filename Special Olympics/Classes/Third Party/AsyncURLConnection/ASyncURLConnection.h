#import <Foundation/Foundation.h>

typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface AsyncURLConnection : NSURLConnection
{
	NSMutableData *data_;
	completeBlock_t completeBlock_;
	errorBlock_t errorBlock_;
}

+(AsyncURLConnection *)sharedManager;


+ (id)request:(NSURLRequest *)request completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

- (id)initWithRequest:(NSURLRequest *)request completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

-(NSMutableURLRequest *) createJSONRequestForDictionary:(NSMutableDictionary *) dictionary method:(NSString *)methodName;

-(NSMutableURLRequest *)createJSONRequestForDictionary2:(NSMutableDictionary *)dictionary method:(NSString *)methodName;

@end