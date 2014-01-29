//
//  Defines.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#ifndef VeraAutomation_Defines_h
#define VeraAutomation_Defines_h

#ifdef INFO_PLIST
#define STRINGIFY(_x)        _x
#else
#define STRINGIFY(_x)      # _x
#endif

#define STRX(x)			x

#define APP_VERSION_NUMBER				STRINGIFY(0.1.0)
#define CF_BUNDLE_VERSION				STRINGIFY(5)

#ifndef INFO_PLIST

extern NSString *kPasswordKey;
extern NSString *kUsernameKey;

extern NSString *kDeviceInfoNotification;
extern NSString *kDeviceUpdatedNotification;
#endif

#endif
