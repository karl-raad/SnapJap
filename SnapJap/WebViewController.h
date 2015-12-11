//
//  ViewController.h
//  ocr
//
//  Created by mac on 12/9/14.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) NSString *recognizedTxt;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

