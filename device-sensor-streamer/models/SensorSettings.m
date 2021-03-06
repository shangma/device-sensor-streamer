    //
    //  SensorSettings.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/3/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "SensorSettings.h"

#define kSETTINGS_DICTIONARY        @"dictionarySettings"

#define kUSING_BROADCAST            @"usingBroadcast"
#define kTARGET_ADDRESS             @"targetAddress"

#define kACCELEROMETER_SENDING_DATA @"accelerometerSendingData"
#define kACCELEROMETER_PORT         @"accelerometerPort"

#define kCAMERA_SENDING_DATA        @"cameraSendingData"
#define kCAMERA_PORT                @"cameraPort"
#define kUSING_FRONT_CAMERA         @"usingFrontCamera"

#define vYES                        @"YES"
#define vNO                         @"NO"

@interface SensorSettings ()

@property (nonatomic, strong) NSUserDefaults* defaults;

@end

@implementation SensorSettings

-(BOOL) setAccelerometerPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.accelerometerPort = port;
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) setCameraPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.cameraPort = port;
        return YES;
    } else {
        return NO;
    }
}

-(void) updatePersistentState {
    NSString* accSendDataString = (self.accelerometerSendingData ? vYES : vNO);
    NSString* camSendDataString = (self.cameraSendingData ? vYES : vNO);
    NSString* useFrontString = (self.usingFrontCamera ? vYES : vNO);

    NSDictionary* settingsDictionary =
    @{kUSING_BROADCAST: [NSString stringWithFormat:@"%c", self.usingBroadcast],
      kTARGET_ADDRESS: self.targetAddress,
      kACCELEROMETER_SENDING_DATA: accSendDataString,
      kACCELEROMETER_PORT: [NSString stringWithFormat:@"%d", self.accelerometerPort],
      kCAMERA_SENDING_DATA: camSendDataString,
      kCAMERA_PORT: [NSString stringWithFormat:@"%d", self.cameraPort],
      kUSING_FRONT_CAMERA: useFrontString};

    [self.defaults setObject:settingsDictionary forKey:kSETTINGS_DICTIONARY];
    [self.defaults synchronize];
}

-(id) initWithPreviousStateIfPossible {
    self = [super init];
    if (self) {
        if ([self hasPreviousState]) {
            NSDictionary* settingsDictionary = [self.defaults objectForKey:kSETTINGS_DICTIONARY];

            self.usingBroadcast = [[settingsDictionary objectForKey:kUSING_BROADCAST] boolValue];
            self.targetAddress = [settingsDictionary objectForKey:kTARGET_ADDRESS];
            NSString* accSendDataString = [settingsDictionary objectForKey:kACCELEROMETER_SENDING_DATA];
            self.accelerometerPort = [[settingsDictionary objectForKey:kACCELEROMETER_PORT] integerValue];
            NSString* camSendDataString = [settingsDictionary objectForKey:kCAMERA_SENDING_DATA];
            self.cameraPort = [[settingsDictionary objectForKey:kCAMERA_PORT] integerValue];
            NSString* useFrontString = [settingsDictionary objectForKey:kUSING_FRONT_CAMERA];

            self.accelerometerSendingData = ([accSendDataString isEqualToString:@"YES"] ? YES : NO);
            self.cameraSendingData = ([camSendDataString isEqualToString:@"YES"] ? YES : NO);
            self.usingFrontCamera = ([useFrontString isEqualToString:@"YES"] ? YES : NO);
        }
    }
    return self;
}

-(BOOL) hasPreviousState {
    return ([self.defaults objectForKey:kSETTINGS_DICTIONARY] != nil);
}


#pragma mark Special getters and setters

-(NSUserDefaults* )defaults {
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(NSString* )targetAddress {
    if (!_targetAddress) {
            //Serves as default "Unicast address"
        _targetAddress = @"192.168.x.x";
    }
    return _targetAddress;
}

#pragma mark -
@end
