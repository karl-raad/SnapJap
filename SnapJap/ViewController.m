//
//  ViewController.m
//  ocr
//
//  Created by mac on 12/9/14.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()
@property (nonatomic) UIImagePickerController *imagePickerController;
@property BOOL imgPicked;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *snapButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *retakeButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *useButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (retain, strong) UIImage *image;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property NSString *recognizedText;
@property Tesseract *tesseract;
@end

@implementation ViewController
@synthesize imgPicked;
@synthesize image = _image;
@synthesize progressView = _progressView;
@synthesize recognizedText = _recognizedText;
@synthesize tesseract;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgPicked = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showImagePicker];
}

- (void)showImagePicker {
    if (self.imgPicked == NO) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.showsCameraControls = NO;
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)takePhoto:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)usePhoto:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    if (self.imgPicked == YES) {
        self.imgPicked = NO;
        tesseract = [[Tesseract alloc] initWithLanguage:@"jpn"];
        tesseract.delegate = self;
        [tesseract setImage:[self.image blackAndWhite]];
        [tesseract recognize];
        self.recognizedText = [tesseract recognizedText];
        //recognizedText = [[recognizedText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"%0A"];
        //recognizedText = [[recognizedText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@"%20"];
        self.progressView.progress = 1.0f;
        NSLog(@"%@", self.recognizedText);
        tesseract = nil;
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.recognizedTxt = self.recognizedText;
        webViewController = nil;
        
        }
        });
}
    

- (IBAction)RetakePhoto:(id)sender {
    self.imgPicked = NO;
    self.tesseract = nil;
    [self showImagePicker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imagePickerController = nil;
    self.imgPicked = YES;
    self.toolBar.hidden = NO;
    self.image = info[UIImagePickerControllerOriginalImage];
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawAtPoint:CGPointMake(0,0)];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.imageView setImage:self.image];
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract {
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"progress: %d", self.tesseract.progress);
    self.progressView.progress = (float)self.tesseract.progress/100.0f;
    });
    return NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
