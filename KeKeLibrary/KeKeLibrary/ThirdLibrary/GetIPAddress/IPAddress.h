//
//  IPAddress.h
//  Artup
//
//  Created by liubo on 13-11-1.
//  Copyright (c) 2013年 Artup. All rights reserved.
//

#define MAXADDRS    32

extern char *ip_names[MAXADDRS];

void InitAddresses(void);
void GetIPAddresses(void);
void GetHWAddresses(void);

