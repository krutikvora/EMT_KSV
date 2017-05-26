#import "AsyncURLConnection.h"
#import "JSON.h"

@implementation AsyncURLConnection

static AsyncURLConnection *sharedInstance = nil;

+(AsyncURLConnection *)sharedManager
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        
        sharedInstance = [[AsyncURLConnection alloc] init];        
    });
    
    return sharedInstance;
}


+ (id)request:(NSURLRequest *)request completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
	return [[self alloc] initWithRequest:request
		completeBlock:completeBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSURLRequest *)request completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
	if ((self = [super
			initWithRequest:request delegate:self startImmediately:NO])) {
		data_ = [[NSMutableData alloc] init];

		completeBlock_ = [completeBlock copy];
		errorBlock_ = [errorBlock copy];
		
		[self start];
	}

	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	completeBlock_(data_);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	errorBlock_(error);
}


-(NSMutableURLRequest *)createJSONRequestForDictionary:(NSMutableDictionary *)dictionary method:(NSString *)methodName
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kURL,methodName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    NSData *data;
    if([methodName isEqualToString:kReferAFriend])
    {
        NSDictionary *refByDict=[[NSDictionary alloc] initWithObjectsAndKeys:[[[dictionary valueForKey:@"data"] objectAtIndex:0] valueForKey:@"referr_by"],@"referr_by" , nil];
        for(int i=0;i<[[dictionary valueForKey:@"data"] count];i++)
        {
            [[[dictionary valueForKey:@"data"] objectAtIndex:i] removeObjectForKey:@"referr_by"];
        }
      //  NSDictionary *refByDict=[[NSDictionary alloc] initWithObjectsAndKeys:[dictionary valueForKey:@"referr_by"],@"referr_by" , nil];
      //  [dictionary removeObjectForKey:@"referr_by"];
       // NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:1];
       // [arr addObject:dictionary];
      //  NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
       // [dict setValue:[arr objectAtIndex:0] forKey:@"data"];
        [dictionary setValue:[refByDict valueForKey:@"referr_by"] forKey:@"referr_by"];
        NSString *jsonRequest = [dictionary JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
       data = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: data];
        NSLog(@"URL :: %@%@",kURL,methodName);
        NSLog(@"data :: %@", dictionary);
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody: data];
    }
    else
    {
        data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0 error:nil];
        NSLog(@"URL :: %@%@",kURL,methodName);
        NSLog(@"data :: %@", dictionary);
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: data];
    }
    
   
    return request;
}

-(NSMutableURLRequest *)createJSONRequestForDictionary2:(NSMutableDictionary *)dictionary method:(NSString *)methodName
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOlderURL,methodName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0 error:nil];
    NSLog(@"URL :: %@%@",kURL,methodName);
    NSLog(@"date ::%@", dictionary);
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];
    return request;
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    return YES;
	return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	}
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
@end
