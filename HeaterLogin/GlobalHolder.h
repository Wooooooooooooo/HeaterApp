

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GlobalHolder : NSObject

@property (copy, nonatomic) NSString *city;

@property (strong, nonatomic, readonly) UIColor *ballColdColor;
@property (strong, nonatomic, readonly) UIColor *ballWarmColor;
@property (strong, nonatomic, readonly) UIColor *backgroundColdColor;
@property (strong, nonatomic, readonly) UIColor *backgroundWarmColor;

+ (GlobalHolder *)sharedSingleton;


@end
