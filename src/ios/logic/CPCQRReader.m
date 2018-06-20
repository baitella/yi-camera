#import <AVFoundation/AVFoundation.h>
#import "CPCQRReader.h"

@implementation CPCQRReader

- (id)initWithView:(UIView *)view
{
    self = [super self];
    
    if (self) {
        self.uiView = view;
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(tapHandler:)
                              ];
        
        serialQueue = dispatch_queue_create("com.euroart93.cordova.camera.queue", NULL);
    }

    return self;
}

- (void)startReadingWithFailBlock:(QRReaderFailBlock)fBlock andSuccessBlock:(QRReaderSuccessBlock)sBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self startReading]) {
            if (fBlock) {
                fBlock();
            }
        }
        else {
            self.failBlock = fBlock;
            self.successBlock = sBlock;
        }
    });
}

- (BOOL)startReading
{
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureMetadataOutput *metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input == nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:metaDataOutput];
    
    [metaDataOutput setMetadataObjectsDelegate:self
                                         queue:serialQueue];
    [metaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.uiView.layer.bounds];

    self.eventTrap = [[UIView alloc] init];
    [self.eventTrap setFrame:self.uiView.layer.bounds];
    [self.eventTrap.layer addSublayer:self.previewLayer];
    [self.eventTrap addGestureRecognizer:self.tapRecognizer];
    
    [self.uiView addSubview:self.eventTrap];

    [self.captureSession startRunning];
    
    return YES;
}

-  (void)captureOutput:(AVCaptureOutput *)captureOutput
   didOutputMetadataObjects:(NSArray *)metadataObjects
        fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if ([obj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@", obj.stringValue);
            if (self.successBlock) {
                self.successBlock(obj.stringValue);
                self.successBlock = nil;
                self.failBlock = nil;
            }
            [self cleanup];
        }
    }
}

- (void)cleanup
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.previewLayer removeFromSuperlayer];
        self.previewLayer = nil;
    
        [self.eventTrap removeFromSuperview];
        self.eventTrap = nil;
    });
}

- (void)tapHandler:(UITapGestureRecognizer *)recognizer;
{
    if (self.failBlock) {
        self.failBlock();
        self.failBlock = nil;
        self.successBlock = nil;
    }

    [self cleanup];
}

@end