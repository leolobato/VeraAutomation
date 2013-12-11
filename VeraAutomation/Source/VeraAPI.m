//
//  VeraAPI.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraAPI.h"
#import "AFNetworking.h"
#import "VeraUnit.h"
#import "VeraForwardServer.h"
#import "VeraUnitInfo.h"
#import "VeraRoom.h"
#import "VeraDevice.h"

NSString *kVeraAPIErrorDomain = @"VeraErrorDomain";

@interface VeraAPI ()
@property (nonatomic, assign) BOOL pollingUnit;
@end

@interface VeraUserResponseSerializer : AFJSONResponseSerializer
@end

@interface VeraDataResponseSerializer : AFJSONResponseSerializer
@end

@interface VeraHTTPOperationManager : AFHTTPRequestOperationManager

@end

@implementation VeraAPI
- (void) getVeraInformationWithHandler:(void (^)(NSError *error)) handler
{
	VeraAPI __weak *weakSelf = self;
	[self getVeraInformationWithServerNumber:1 andHandler:^(NSError *error) {
		if (error)
		{
			[weakSelf getVeraInformationWithServerNumber:2 andHandler:^(NSError *error) {
				if (handler)
				{
					handler(error);
				}
			}];
		}
		else
		{
			if (handler)
			{
				handler(error);
			}
		}
	}];
}

- (void) getVeraInformationWithServerNumber:(NSUInteger) serverNumber andHandler:(void (^)(NSError *error)) handler
{
	// https://sta1.mios.com/locator_json.php?username=user
	
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [VeraUserResponseSerializer serializer];
	
	VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"https://sta%lu.mios.com/locator_json.php?username=%@", (unsigned long) serverNumber, weakSelf.username];
	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
		DebugLog(@"responseObject: %@", [responseObject componentsJoinedByString:@"\n"]);
		weakSelf.unit = [responseObject firstObject];
		if (handler)
		{
			handler(nil);
		}
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(error);
		}
	}];
}

- (void) getUnitInformationWithHandler:(void (^)(NSError *error, BOOL fullReload)) handler
{
	if (self.pollingUnit)
	{
		if (handler)
		{
			handler(nil, NO);
		}
		
		return;
	}
	
	self.pollingUnit = YES;
	if (self.unit)
	{
		NSString *requestString = nil;
		if ([self.unit.ipAddress length])
		{
			requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_sdata&timeout=30&minimumdelay=2000", self.unit.ipAddress];
		}
		else
		{
			VeraForwardServer *server = [self.unit.forwardServers firstObject];
			requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_sdata&timeout=60&minimumdelay=2000", server.hostName, self.username, self.password, self.unit.serialNumber];
			
		}
		
		if (self.unitInfo.loadtime > 0)
		{
			requestString = [requestString stringByAppendingFormat:@"&loadtime=%lu", (unsigned long) self.unitInfo.loadtime];
		}

		if (self.unitInfo.dataversion > 0)
		{
			requestString = [requestString stringByAppendingFormat:@"&dataversion=%lu", (unsigned long) self.unitInfo.dataversion];
		}
		
		DebugLog(@"requestString: %@", requestString);
		
		//		http://76.168.224.30:3480/data_request?id=lu_sdata&loadtime=1282441735&dataversion=441736333&timeout=60
		VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
		manager.responseSerializer = [VeraDataResponseSerializer serializer];
		
		VeraAPI __weak *weakSelf = self;
		[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, VeraUnitInfo *responseObject) {
			DebugLog(@"responseObject for polling: %@", responseObject);
			//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
			BOOL fullReload = NO;
			if (responseObject.full || weakSelf.unitInfo == nil)
			{
				weakSelf.unitInfo = responseObject;
				fullReload = YES;
			}
			else
			{
				// Update
				if (weakSelf.unitInfo)
				{
					[weakSelf.unitInfo updateDeviceInfo:responseObject];
				}
			}
			
			if (handler)
			{
				handler(nil, fullReload);
			}
			weakSelf.pollingUnit = NO;
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			DebugLog(@"failure: %@", error);
			NSString *rawData = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
			if ([rawData caseInsensitiveCompare:@"Invalid user/pass."] == NSOrderedSame)
			{
				error = [NSError errorWithDomain:kVeraAPIErrorDomain code:VeraAPIIncorrectLogin userInfo:nil];
			}
			
			if (handler)
			{
				handler(error, NO);
			}
			weakSelf.pollingUnit = NO;
		}];

	}
	else
	{
		if (handler)
		{
			handler(nil, NO);
			self.pollingUnit = NO;
		}
	}
}

- (VeraRoom *) roomWithIdentifier:(NSUInteger) identifier
{
	for (VeraRoom *room in self.unitInfo.rooms)
	{
		if (room.roomIdentifier == identifier)
		{
			return room;
		}
	}
	
	return nil;
}

- (NSArray *) devicesForRoom:(VeraRoom *) inRoom
{
	NSMutableArray *devices = [NSMutableArray array];
	for (VeraDevice *device in self.unitInfo.devices)
	{
		if (device.room == inRoom.roomIdentifier)
		{
			[devices addObject:device];
		}
	}
	
	return devices;
}

- (void) toggleDevice:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", self.unit.ipAddress, (unsigned long) device.deviceIdentifier, !device.status];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier, !device.status];
		
	}
	
	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}

- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=lu_action&DeviceNum=116&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=0

	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", self.unit.ipAddress, (unsigned long) device.deviceIdentifier, on];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier, on];

	}

	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}

- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=104&serviceId=urn:micasaverde-com:serviceId:Volume1&action=Up
	
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Volume1&action=", self.unit.ipAddress, (unsigned long) device.deviceIdentifier];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Volume1&action=", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier];
		
	}

	if (up)
	{
		requestString = [requestString stringByAppendingString:@"Up"];
	}
	else
	{
		requestString = [requestString stringByAppendingString:@"Down"];
	}

	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}

- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=104&serviceId=urn:micasaverde-com:serviceId:InputSelection1&action=Input1
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:InputSelection1&action=Input%ld", self.unit.ipAddress, (unsigned long) device.deviceIdentifier, (long)input];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:InputSelection1&action=Input%ld", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier, (long)input];
		
	}
	
	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}

- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=103&serviceId=urn:micasaverde-com:serviceId:Misc1&action=AllOff
	
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Misc1&action=", self.unit.ipAddress, (unsigned long) device.deviceIdentifier];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Misc1&action=", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier];
	}
	
	if (on)
	{
		requestString = [requestString stringByAppendingString:@"AllOn"];
	}
	else
	{
		requestString = [requestString stringByAppendingString:@"AllOff"];
	}
	
	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}

- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=3&serviceId=urn:upnp-org:serviceId:Dimming1&action=SetLoadLevelTarget&newLoadlevelTarget=0

	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = nil;
	if ([self.unit.ipAddress length])
	{
		requestString = [NSString stringWithFormat:@"http://%@:3480/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:Dimming1&action=SetLoadLevelTarget&newLoadlevelTarget=%ld", self.unit.ipAddress, (unsigned long) device.deviceIdentifier, (long)level];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		requestString = [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:Dimming1&action=SetLoadLevelTarget&newLoadlevelTarget=%ld", server.hostName, self.username, self.password, self.unit.serialNumber, (unsigned long) device.deviceIdentifier, (long)level];
		
	}
	
	DebugLog(@"sending request: %@", requestString);
	
	[manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DebugLog(@"responseObject: %@", responseObject);
		if (handler)
		{
			handler(nil);
		}
		
		//DebugLog(@"raw data: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DebugLog(@"failure: %@", error);
		if (handler)
		{
			handler(nil);
		}
	}];
}


@end

@implementation VeraUserResponseSerializer
- (instancetype)init
{
    self = [super init];
    if (!self)
	{
        return nil;
    }
	
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
	
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error

{
	id object = [super responseObjectForResponse:response data:data error:error];
	if (object && [object isKindOfClass:[NSDictionary class]])
	{
		NSMutableArray *units = [NSMutableArray array];
		id unitArray = ((NSDictionary *) object)[@"units"];
		if ([unitArray isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *dict in unitArray)
			{
				VeraUnit *unit = [VeraUnit modelObjectWithDictionary:dict];
				[units addObject:unit];
			}
			
			return units;
		}
	}
	
	return nil;
}


@end

@implementation VeraDataResponseSerializer
- (instancetype)init
{
    self = [super init];
    if (!self)
	{
        return nil;
    }
	
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
	
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error

{
	id object = [super responseObjectForResponse:response data:data error:error];
	if (object && [object isKindOfClass:[NSDictionary class]])
	{
		VeraUnitInfo *info = [VeraUnitInfo modelObjectWithDictionary:object];
		return info;
	}
	
	return nil;
}


@end

@implementation VeraHTTPOperationManager
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters];
	request.timeoutInterval = 60.0f;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
	
    return operation;
}
@end
