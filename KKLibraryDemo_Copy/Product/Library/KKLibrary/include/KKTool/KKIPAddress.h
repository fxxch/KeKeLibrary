//
//  KKIPAddress.h
//  Artup
//
//  Created by liubo on 13-11-1.
//  Copyright (c) 2013年 Artup. All rights reserved.
//

#define MAXADDRS    32

extern char *KK_ip_names[MAXADDRS];

void KK_InitAddresses(void);
void KK_GetIPAddresses(void);
void KK_GetHWAddresses(void);

