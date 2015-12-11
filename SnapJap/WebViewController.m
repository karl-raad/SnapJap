//
//  WebViewController.m
//  ocr
//
//  Created by mac on 12/11/14.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface WebViewController ()
@end

@implementation WebViewController
@synthesize recognizedTxt;
@synthesize webView;

-(void)viewDidLoad:(BOOL)animated{
    NSString *urlAddress = @"https://translate.google.com/m/translate#ja/en/";
    urlAddress = [urlAddress stringByAppendingString:recognizedTxt];
    NSURL *url = [NSURL URLWithString:[urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [[UIApplication sharedApplication] openURL:url];
    [webView setDataDetectorTypes:UIDataDetectorTypeLink];
    [webView loadRequest:requestObj];
}

@end
