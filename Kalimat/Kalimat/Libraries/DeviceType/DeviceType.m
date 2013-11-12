//
//  DeviceType.m
//  AePubReader
//
//  Created by Ahmed Aly on 11/20/12.
//
//

#import "DeviceType.h"


DeviceType *userDeviceType = nil;

@implementation DeviceType
#define IPHONE_STRING @""
#define IPHONE_RETINA_STRING @""
#define IPAD_STRING @"2"
#define IPAD_RETINA_STRING @"3"

@synthesize retinaDisplay, iPhone;


#pragma -
#pragma Initialization

- (id)init{
    self = [super init];
    if (self) {
        // Set Retina Display
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && ([[UIScreen mainScreen] scale] == 2.0)) {
			self.retinaDisplay = YES;
		} else {
			self.retinaDisplay = NO;
		}
		
		// Set iPhone/iPad
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.iPhone = NO;
		} else {
			self.iPhone = YES;
		}
    }
    return self;
}

+ (DeviceType *)getObject{
	if (userDeviceType == nil) {
		userDeviceType = [[DeviceType alloc] init];
	}
	
	return userDeviceType;
}

#pragma mark -
#pragma mark Get device type

+ (NSString *)getDeviceTypeString{
	NSString *deviceType = nil;
	
	if ([DeviceType getObject].iPhone) {
		if ([DeviceType getObject].retinaDisplay) {
			deviceType = IPHONE_RETINA_STRING;
		} else {
			deviceType = IPHONE_STRING;
		}
	} else {
		if ([DeviceType getObject].retinaDisplay) {
			deviceType = IPAD_RETINA_STRING;
		} else {
			deviceType = IPAD_STRING;
		}
	}
	
	return deviceType;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc{
    [userCountry release];
    [super dealloc];
}

@end

