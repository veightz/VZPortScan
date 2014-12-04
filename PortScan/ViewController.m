//
//  ViewController.m
//  PortScan
//
//  Created by Veight Zhou on 12/3/14.
//  Copyright (c) 2014 Veight Zhou. All rights reserved.
//

#import "ViewController.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_resultScrollView setEditable:NO];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)scanHandle:(NSButton *)sender {
    int fromPort = [[_fromPort stringValue] intValue];
    int toPort = [[_toPort stringValue] intValue];
    [self scrollView:_resultScrollView addLine:@"====== START ======"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = fromPort; i < toPort; i++) {
            if ([self scanHost:_hostTextField.stringValue withPort:i]) {
                printf("Open %d\n", i);
                NSString *str = [NSString stringWithFormat:@"%@ : %d", _hostTextField.stringValue, i];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scrollView:_resultScrollView addLine:str];
                });
            }
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self scrollView:_resultScrollView addLine:@"====== OVER ======"];
        });
    });



}

- (void)scrollView:(NSTextView *)textView addLine:(NSString *)string {
    NSString *contentString = textView.string;
    contentString = [contentString stringByAppendingString:string];
    contentString = [contentString stringByAppendingString:@"\n"];
    [textView setString:contentString];
}

- (BOOL)scanHost:(NSString *)host withPort:(int)port {
    struct sockaddr_in server_addr;
    server_addr.sin_len = sizeof(struct sockaddr_in);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = inet_addr([host UTF8String]);
    bzero(&(server_addr.sin_zero),8);

    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    // fcntl( server_socket, F_SETFL, O_NONBLOCK ); 
    if (server_socket == -1) {
        perror("socket error");
        return NO;
    }

    if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)  {
		printf("open %d\n", port);
		close(server_socket);
        return YES;
    } else {
		printf("not %d\n", port);
        return NO;
	}
}
@end
