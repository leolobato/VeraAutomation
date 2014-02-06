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
#import "VeraScene.h"

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
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
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
	
	[self checkForOperationCompletion:operation withTimeout:10];
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
		requestString = [NSString stringWithFormat:@"%@lu_sdata&timeout=30&minimumdelay=2000", [self requestPrefix]];
		
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
		AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, VeraUnitInfo *responseObject) {
			DebugLog(@"responseObject for polling: %@ %@", operation.request, responseObject);
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
		
		[self checkForOperationCompletion:operation];
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

- (void) checkForOperationCompletion:(AFHTTPRequestOperation *) operation
{
	[self checkForOperationCompletion:operation withTimeout:30];
}

- (void) checkForOperationCompletion:(AFHTTPRequestOperation *) operation withTimeout:(NSUInteger) timeout
{
	// Kill the request after 30 seconds. NSURLConnection's timeout doesn't work how you'd
	// think it works. The timeout is for data not being received, but isn't a connect timeout.
	// We really want a connect timeout.
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		if (operation.response == nil)
		{
			DebugLog(@"Cancelling: %@", operation);
			[operation cancel];
		}
		else
		{
			DebugLog(@"Not cancelling: %@", operation);
		}
	});
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

- (NSArray *) devicesForRoom:(VeraRoom *) inRoom forType:(VeraDeviceTypeEnum) deviceType
{
	NSMutableArray *devices = [NSMutableArray array];
	if (deviceType == VeraDeviceTypeScene)
	{
		for (VeraScene *scene in self.unitInfo.scenes)
		{
			if (scene.room == inRoom.roomIdentifier)
			{
				BOOL addScene = YES;
				for (NSString *excludeString in self.sceneNamesToExclude)
				{
					if ([scene.name rangeOfString:excludeString options:NSCaseInsensitiveSearch].location != NSNotFound)
					{
						addScene = NO;
						break;
					}
				}
				
				if (addScene)
				{
					[devices addObject:scene];
				}
			}
		}
		
		[devices sortUsingComparator:^NSComparisonResult(VeraScene *scene1, VeraScene *scene2) {
			return [scene1.name caseInsensitiveCompare:scene2.name];
		}];
	}
	else
	{
		for (VeraDevice *device in self.unitInfo.devices)
		{
			if (device.room == inRoom.roomIdentifier)
			{
				// Check the device type before adding it
				switch (deviceType)
				{
					case VeraDeviceTypeSwitch:
					{
						BOOL addDevice = YES;
						for (NSString *excludeString in self.deviceNamesToExclude)
						{
							if ([device.name rangeOfString:excludeString options:NSCaseInsensitiveSearch].location != NSNotFound)
							{
								addDevice = NO;
								break;
							}
						}
						
						if (addDevice &&  (device.category == 3 || device.category == 2))
						{
							[devices addObject:device];
						}
						
						break;
					}
						
					case VeraDeviceTypeAudio:
					{
						if (device.name && [device.name rangeOfString:@"Audio" options:NSCaseInsensitiveSearch].location != NSNotFound)
						{
							[devices addObject:device];
						}
						break;
					}
						
					case VeraDeviceTypeThermostat:
					{
						if (device.category == 5)
						{
							[devices addObject:device];
						}
						break;
					}
						
					case VeraDeviceTypeLock:
					{
						if (device.category == 7)
						{
							[devices addObject:device];
						}
						
						break;
					}

					case VeraDeviceTypeSensor:
					{
						if (device.category == 4)
						{
							[devices addObject:device];
						}
						
						break;
					}

					default:
					{
						break;
					}
				}
			}
		}

		[devices sortUsingComparator:^NSComparisonResult(VeraDevice *device1, VeraDevice *device2) {
			return [device1.name caseInsensitiveCompare:device2.name];
		}];
	}
	
	return devices;
}

- (void) toggleDevice:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", [self requestPrefix], (unsigned long) device.deviceIdentifier, !device.status];
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];

}

- (void) runScene:(VeraScene *) scene withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&serviceId=urn:micasaverde-com:serviceId:HomeAutomationGateway1&action=RunScene&SceneNum=%lu", [self requestPrefix], (unsigned long) scene.sceneIdentifier];
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}

- (void) setLockState:(VeraDevice *) device locked:(BOOL) locked withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:DoorLock1&action=SetTarget&newTargetValue=%d", [self requestPrefix], (unsigned long) device.deviceIdentifier, locked];
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}



- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=lu_action&DeviceNum=116&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=0

	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:SwitchPower1&action=SetTarget&newTargetValue=%d", [self requestPrefix], (unsigned long) device.deviceIdentifier, on];

	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

	[self checkForOperationCompletion:operation];
}

- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=104&serviceId=urn:micasaverde-com:serviceId:Volume1&action=Up
	
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Volume1&action=", [self requestPrefix], (unsigned long) device.deviceIdentifier];

	if (up)
	{
		requestString = [requestString stringByAppendingString:@"Up"];
	}
	else
	{
		requestString = [requestString stringByAppendingString:@"Down"];
	}

	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

	[self checkForOperationCompletion:operation];
}

- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=104&serviceId=urn:micasaverde-com:serviceId:InputSelection1&action=Input1
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:InputSelection1&action=Input%ld", [self requestPrefix], (unsigned long) device.deviceIdentifier, (long)input];
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

	[self checkForOperationCompletion:operation];
}

- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=103&serviceId=urn:micasaverde-com:serviceId:Misc1&action=AllOff
	
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:micasaverde-com:serviceId:Misc1&action=", [self requestPrefix], (unsigned long) device.deviceIdentifier];
	
	if (on)
	{
		requestString = [requestString stringByAppendingString:@"AllOn"];
	}
	else
	{
		requestString = [requestString stringByAppendingString:@"AllOff"];
	}
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

	[self checkForOperationCompletion:operation];
}

- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level withHandler:(void (^)(NSError *error)) handler
{
	// http://10.0.1.101:3480/data_request?id=action&DeviceNum=3&serviceId=urn:upnp-org:serviceId:Dimming1&action=SetLoadLevelTarget&newLoadlevelTarget=0

	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	//VeraAPI __weak *weakSelf = self;
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:Dimming1&action=SetLoadLevelTarget&newLoadlevelTarget=%ld", [self requestPrefix], (unsigned long) device.deviceIdentifier, (long)level];
	
	DebugLog(@"sending request: %@", requestString);
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}

- (void) setHVACMode:(VeraHVACMode) hvacMode device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	NSString *newMode = nil;
	switch (hvacMode)
	{
		case VeraHVACModeAuto:
		{
			newMode = @"AutoChangeOver";
			break;
		}
			
		case VeraHVACModeOff:
		{
			newMode = @"Off";
			break;
		}

		case VeraHVACModeHeat:
		{
			newMode = @"HeatOn";
			break;
		}

		case VeraHVACModeCool:
		{
			newMode = @"CoolOn";
			break;
		}
	}
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:HVAC_UserOperatingMode1&action=SetModeTarget&NewModeTarget=%@", [self requestPrefix], (unsigned long) device.deviceIdentifier, newMode];
	
	DebugLog(@"sending request: %@", requestString);
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}

- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:HVAC_FanOperatingMode1&action=SetMode&NewMode=%@", [self requestPrefix], (unsigned long) device.deviceIdentifier, fanMode == VeraFanModeAuto ? @"Auto" : @"ContinuousOn"];
	
	DebugLog(@"sending request: %@", requestString);
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}

- (void) setTemperature:(NSUInteger) temperature heat:(BOOL) heat device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler
{
	VeraHTTPOperationManager *manager = [VeraHTTPOperationManager manager];
	manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	NSString *requestString = [NSString stringWithFormat:@"%@lu_action&DeviceNum=%lu&serviceId=urn:upnp-org:serviceId:TemperatureSetpoint1_%@&action=SetCurrentSetpoint&NewCurrentSetpoint=%ld", [self requestPrefix], (unsigned long) device.deviceIdentifier, heat ? @"Heat" : @"Cool", (long)temperature];
	
	DebugLog(@"sending request: %@", requestString);
	
	AFHTTPRequestOperation *operation = [manager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
	
	[self checkForOperationCompletion:operation];
}

- (NSString *) requestPrefix
{
	if ([self.unit.ipAddress length])
	{
		return [NSString stringWithFormat:@"http://%@:3480/data_request?id=", self.unit.ipAddress];
	}
	else
	{
		VeraForwardServer *server = [self.unit.forwardServers firstObject];
		return [NSString stringWithFormat:@"https://%@/%@/%@/%@/data_request?id=", server.hostName, self.username, self.password, self.unit.serialNumber];
		
	}
}

- (void) resetAPI
{
	self.unit = nil;
	self.unitInfo = nil;
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

