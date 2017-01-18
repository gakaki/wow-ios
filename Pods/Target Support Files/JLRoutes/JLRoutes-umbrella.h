#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JLRoutes.h"
#import "JLROptionalRouteParser.h"
#import "JLRRouteDefinition.h"
#import "JLRRouteRequest.h"
#import "JLRRouteResponse.h"

FOUNDATION_EXPORT double JLRoutesVersionNumber;
FOUNDATION_EXPORT const unsigned char JLRoutesVersionString[];

