#import <Foundation/Foundation.h>
#if defined(DEBUG)
#define YBDPRINT(xx, ...)  NSLog(@"%s(%d行): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define YBDPRINT(xx, ...)  ((void)0)
#endif 
@interface QukanYBArchiveTool : NSObject
@end
