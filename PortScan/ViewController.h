//
//  ViewController.h
//  PortScan
//
//  Created by Veight Zhou on 12/3/14.
//  Copyright (c) 2014 Veight Zhou. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak, nonatomic) IBOutlet NSTextField *hostTextField;
@property (weak, nonatomic) IBOutlet NSTextField *fromPort;
@property (weak, nonatomic) IBOutlet NSTextField *toPort;

@property IBOutlet NSTextView *resultScrollView;

@property (weak, nonatomic) IBOutlet NSButton *scanButton;
- (IBAction)scanHandle:(NSButton *)sender;

@end

