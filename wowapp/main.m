//
//  main.m
//  wowapp
//
//  Created by g on 2016/9/25.
//  Copyright © 2016年 小黑. All rights reserved.
//

#ifndef main_h
#define main_h


#endif /* main_h */

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"192.168.1.148", "127.0.0.1", 0};

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
