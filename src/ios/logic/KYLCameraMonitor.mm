//
//  KYLCameraMonitor.m
//  P2PCamera
//
//
//

#import "KYLCameraMonitor.h"

#import "APICommon.h"
#import "MBProgressHUD.h"
#import "KYLComFunUtil.h"

@interface KYLCameraMonitor()
{
    
    UIScrollView *m_pBgScrollView;
    
    BOOL bPlaying;
    BOOL m_bIsCreateOpenGL;
    BOOL m_bShowRightButton;
    BOOL m_bBtnStartShow;
    
    UIImageView *m_pImageViewForCover;
    
    float radius;
    float bubbleRadius;
    BOOL m_bIsSelected;
}

@end

@implementation KYLCameraMonitor
@synthesize delegate;
@synthesize m_pCameraObj;
@synthesize btnStart;
@synthesize btnRightBig;
@synthesize lableCameraName;
@synthesize m_pImageView;
//@synthesize myGLViewController;
@synthesize m_iIndex;
@synthesize m_nAudioStatusWhenLeaveFullScreen;
@synthesize m_nTalkStatusWhenLeaveFulllScreen;



- (id) init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void) initData
{
    m_nAudioStatusWhenLeaveFullScreen = 0;
    m_nTalkStatusWhenLeaveFulllScreen = 0;
    //self.myGLViewController = nil;
    self.m_pImageView = nil;
    bPlaying = NO;
    m_bIsCreateOpenGL = NO;
    m_iIndex = 0;
    
    radius = 60;
    bubbleRadius = 20;
    m_bIsSelected = NO;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        // Initialization code
        [self initTheUIWithFrame:frame];
        
    }
    return self;
}


- (void) initTheUIWithFrame:(CGRect)frame
{
    m_pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
    m_pBgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
    m_pBgScrollView.minimumZoomScale = ZOOM_MIN_SCALE;
    m_pBgScrollView.maximumZoomScale = ZOOM_MAX_SCALE;
    m_pBgScrollView.contentMode = UIViewContentModeScaleAspectFit;
    m_pBgScrollView.contentSize = self.m_pImageView.frame.size;
    m_pBgScrollView.delegate = self;
    [m_pBgScrollView addSubview:m_pImageView];
    
    [self addSubview:m_pBgScrollView];
    
    m_pImageViewForCover = [[UIImageView alloc] initWithFrame:m_pImageView.frame];
    m_pImageViewForCover.backgroundColor = [UIColor blackColor];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, 100, 20)];
    self.lableCameraName = tempLabel;
    self.lableCameraName.textColor = [UIColor whiteColor];
    self.lableCameraName.font = [UIFont systemFontOfSize:9];
    self.lableCameraName.backgroundColor = [UIColor clearColor];
    [tempLabel release];
    [self addSubview:tempLabel];
    
    //UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 4, 60, 60)];
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"btn_start2"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(btnStartClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnStart = tempBtn;
    [self addSubview:tempBtn];
    tempBtn.center = self.center;
    
    [self setMinimumGestureLength:40 MaximumVariance:20];
    
    self.backgroundColor  = [UIColor blackColor];
    
    
//    MyGLViewController *tempmyGLViewController = [[MyGLViewController alloc] init];
//    self.myGLViewController = tempmyGLViewController;
//    [tempmyGLViewController release];
    
    
    
}


- (void) initTheUIWithFrame22:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    m_pBgScrollView = [[UIScrollView alloc]initWithFrame:rect];
    m_pImageView = [[UIImageView alloc] initWithFrame:rect];
    m_pBgScrollView.minimumZoomScale = ZOOM_MIN_SCALE;
    m_pBgScrollView.maximumZoomScale = ZOOM_MAX_SCALE;
    m_pBgScrollView.contentMode = UIViewContentModeScaleAspectFit;
    m_pBgScrollView.contentSize = self.m_pImageView.frame.size;
    m_pBgScrollView.delegate = self;
    [m_pBgScrollView addSubview:m_pImageView];
    
    [self addSubview:m_pBgScrollView];
    
    m_pImageViewForCover = [[UIImageView alloc] initWithFrame:m_pImageView.frame];
    m_pImageViewForCover.backgroundColor = [UIColor blackColor];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, 100, 20)];
    self.lableCameraName = tempLabel;
    self.lableCameraName.textColor = [UIColor whiteColor];
    self.lableCameraName.font = [UIFont systemFontOfSize:9];
    self.lableCameraName.backgroundColor = [UIColor clearColor];
    [tempLabel release];
    [self addSubview:tempLabel];
    
    //UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 4, 60, 60)];
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"btn_start2"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(btnStartClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnStart = tempBtn;
    [self addSubview:tempBtn];
    tempBtn.center = self.center;
    

    //self.btnStart.hidden = YES;
    [self setMinimumGestureLength:40 MaximumVariance:20];
    
    self.backgroundColor  = [UIColor blackColor];
    
//    MyGLViewController *tempmyGLViewController = [[MyGLViewController alloc] init];
//    self.myGLViewController = tempmyGLViewController;
//    [tempmyGLViewController release];
    
}






- (void)dealloc
{
    NSLog(@"KYLCameraMonitor dealloc()");
    self.m_pCameraObj.delegate = nil;
    self.m_pCameraObj.m_pImageDelegate = nil;
    
    if (m_pCameraObj) {
        [m_pCameraObj stopVideo];
        [m_pCameraObj stopTalk];
        [m_pCameraObj stopAudio];
    }
    self.m_pCameraObj = nil;
    //self.myGLViewController = nil;
    
    self.lableCameraName = nil;
    self.btnStart = nil;
    self.btnRightBig = nil;
    self.m_pImageView = nil;
    if (m_pImageViewForCover) {
        [m_pImageViewForCover release];
        m_pImageViewForCover = nil;
    }
    if (m_pBgScrollView) {
        [m_pBgScrollView release];
        m_pBgScrollView = nil;
    }

    [super dealloc];
}


#pragma mark actions

- (void) btnStartClicked:(id) sender
{
    m_bBtnStartShow = !m_bBtnStartShow;
    if (m_bBtnStartShow) {
        //[btnStart setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    else
    {
        //[btnStart setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}



 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.

/*
 - (void)drawRect:(CGRect)rect
 {
// // Drawing code
//     CGRect frame = self.frame;
//     //CGRect frame = self.frame;
//     m_pImageView.frame = CGRectMake(1, 1, frame.size.width-2, frame.size.height-2);
//     m_pBgScrollView.frame = m_pImageView.frame;
//     
//     lableCameraName.frame = CGRectMake( 5, 4, 60, 20);
//     [self refreshTheGLView:frame];
 }

  */
- (void) setNeedsLayout
{
    [super setNeedsLayout];
    //[self refreshTheUI];
    [self refreshTheFrame:self.frame];
}


- (void) refreshTheFrame:(CGRect) frame
{
    m_pImageView.frame = CGRectMake(1, 1, frame.size.width-2, frame.size.height-2);
    m_pImageViewForCover.frame = m_pImageView.frame;
    m_pBgScrollView.frame = m_pImageView.frame;
//    if (myGLViewController) {
//        myGLViewController.view.frame = m_pBgScrollView.frame;
//    }
    m_pBgScrollView.zoomScale = 1.0;
    lableCameraName.frame = CGRectMake( 5, 4, 100, 20);
    self.btnStart.center = self.center;
    
    [self bringSubviewToFront:btnStart];
}



- (void) refreshTheUI
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    m_pImageView.frame = rect;
    m_pImageViewForCover.frame = rect;
//    if (myGLViewController) {
//        myGLViewController.view.frame = rect;
//    }
    m_pBgScrollView.frame = rect;
    //m_pBgScrollView.zoomScale = 1.0;
    lableCameraName.frame = CGRectMake( 5, 4, 100, 20);
    self.btnStart.center = self.center;
    [self bringSubviewToFront:btnStart];
}


- (void) recoverTheScrollView
{
    if (m_pBgScrollView) {
//        if (myGLViewController) {
//            myGLViewController.view.frame = m_pBgScrollView.frame;
//        }
//        else
        {
            m_pBgScrollView.frame = m_pImageView.frame;
        }
        m_pBgScrollView.zoomScale = 1.0;
    }
}



#pragma mark - Public Methods

- (void) initTheDisplayView
{
//    if (myGLViewController) {
//        [myGLViewController.view removeFromSuperview];
//    }
    [self setPlay:NO];
}




- (void)setMinimumGestureLength:(NSInteger)length MaximumVariance:(NSInteger)variance
{
    minGestureLength = length;
    maxVariance = variance;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(doPinch:)] ;
    [self addGestureRecognizer:pinch];
    [pinch release];
    
    [self addGesture];
}


- (void) addGesture
{
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // ĂĹĂÂĂÂĂĹĂÂÄšÄ˝
    [self addGestureRecognizer:singleTapRecognizer];
    
    // ĂĹĂÂĂÂĂĹĂÂÄšÄ˝ÄÂ§ĂÂĂÂ Recognizer
    UITapGestureRecognizer* doubleTapRecognizer;
    doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleTapRecognizer.numberOfTapsRequired = 2; // ĂĹĂÂĂÂĂĹĂÂÄšÄ˝
    [self addGestureRecognizer:doubleTapRecognizer];
    
    // ĂĹĂÂÄšÂÄĹ ĂÂÄšËĂĹĂÂĂÂ¨ĂÂÄšĹşĂÂÄÂ¤ĂÂ¸ĂÂĂÂĂÂĂÂĂÂÄšĹĂÂĂĹÄšÂĂÂĂÂĂÂĂÂĂĹĂÂĂÂĂĹĂÂÄšÄ˝ÄÂ§ĂÂÄšËĂĹÄšËĂÂĂĹĂÂĂĹžĂÂĂÂ¸ÄšĹĄĂĹĂÂ¤ĂÂĂÂĂÂ´ĂËĂÂĂÂĂÂĂÂĂÂĂÂĂÂĂÂ§ÄšÂĂĹĂÂĂÂĂĹĂÂĂÂĂĹĂÂÄšÄ˝
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    // ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂĂÂÄšÂÄÂ§ĂÂĂÂ°
    UISwipeGestureRecognizer *oneFingerSwipeUp =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)] ;
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self  addGestureRecognizer:oneFingerSwipeUp];
    
    
    // ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂĂÂÄšÂÄÂ§ĂÂĂÂ°
    UISwipeGestureRecognizer *oneFingerSwipeDown =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)] ;
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self  addGestureRecognizer:oneFingerSwipeDown];
    
    // ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂĂÂÄšÂÄÂ§ĂÂĂÂ°
    UISwipeGestureRecognizer *oneFingerSwipeLeft =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self  addGestureRecognizer:oneFingerSwipeLeft];
    
    
    // ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂĂÂÄšÂÄÂ§ĂÂĂÂ°
    UISwipeGestureRecognizer *oneFingerSwipeRight =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)]   ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self  addGestureRecognizer:oneFingerSwipeRight];
    
    //ÄĹ ĂÂÄšĹşĂÂĂÂĂÂĂÂĂÂĂÂĂĹĂÂÄšĹş
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDid:)];
    longPressGesture.minimumPressDuration = 2;
    [self addGestureRecognizer:longPressGesture];
    
    
    //free memory
    
    [singleTapRecognizer release];
    [doubleTapRecognizer release];
    [oneFingerSwipeUp release];
    [oneFingerSwipeDown release];
    [oneFingerSwipeLeft release];
    [oneFingerSwipeRight release];
    [longPressGesture release];
}

// ÄĹ ĂÂÄšĹşĂÂĂÂĂÂĂÂĂÂĂÂĂĹĂÂÄšĹş
- (void)longPressGestureDid:(UILongPressGestureRecognizer*)recognizer {
    // ĂÂĂÂ§ÄšÂĂĹĂÂĂÂĂÂĂÂĂÂĂĹĂÂĂÂÄÂ¤ÄšÂĂÂÄÂ¤ÄšÄ˝ÄšÂĂĹĂÂĂÂĂÂÄšĹĂÂĂĹĂÂĂÂ¨ĂÂÄšĹşĂÂÄĹ ĂÂĂÂÄÂ¤ĂÂĂÂÄÂ¤ÄšÂĂÂÄÂ¤ÄšÂĂÂĂÂĂÂĂÂ
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureLongPressed:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureLongPressed:self];
        }
    }
    //[self showTheMenu];
    
}

// ĂĹĂÂĂÂĂĹĂÂÄšÄ˝
- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        //[self changeBordColorToChoosedColor];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureOneTap:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureOneTap:self];
        }
    }
    
}

// ĂĹĂÂĂÂĂĹĂÂÄšÄ˝
- (void)handleDoubleTapFrom:(UITapGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"KYLCameraMonitor ĂĹĂÂĂÂĂĹĂÂÄšÄ˝ÄÂ§ÄšÂĂÂĂĹĂÂÄšÂ");
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureDoubleTap:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureDoubleTap:self];
        }
    }
    
}

//ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨
- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    
    NSLog(@"ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureSwiped:user:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureSwiped:DirectionUp user:self];
        }
        //[self up];
        //ĂÂĂÂÄšÂĂĹĂÂĂÂ¨ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšĹşĂÂĂĹĂÂĂÂ¨ĂÂÄšĹĂÂÄÂ§ĂÂĂÂĂĹĂÂĂÂ°ÄÂ§ĂÂĂÂĂĹĂÂÄšĹžĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂĂÂÄšÂĂĹĂÂĂÂ¨ĂÂÄšĹşĂÂĂĹĂÂĂÂ¨ĂÂĂÂÄšÄĂĹĂÂĂÂÄÂ§ĂÂĂÂ¸ĂĹĂÂĂÂĂÂÄšĹĂÂĂĹĂÂÄšĹžĂĹĂÂĂÂĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšĹşĂÂĂĹĂÂĂÂ¨
        if ([self.m_pCameraObj IsConnectedOK] && [self.m_pCameraObj IsAdmin])
        {
            [self down];
        }
        
    }
    
}

// ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨
- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    
    NSLog(@"ĂĹĂÂĂÂÄÂ¤ĂÂ¸ĂÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureSwiped:user:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureSwiped:DirectionDown user:self];
        }
        if ([self.m_pCameraObj IsConnectedOK] && [self.m_pCameraObj IsAdmin])
        {
            [self up];
        }
        //[self up];
    }
    
}

//ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨
- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    
    NSLog(@"ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureSwiped:user:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureSwiped:DirectionLeft user:self];
        }
      
        if ([self.m_pCameraObj IsConnectedOK] && [self.m_pCameraObj IsAdmin])
        {
            [self right];
        }
        //[self right];
    }
    
}

// ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨
- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"ĂĹĂÂĂÂĂĹĂÂÄšÂĂÂÄšÄ˝ĂÂĂĹĂÂĂÂ¨");
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGestureSwiped:user:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGestureSwiped:DirectionRight user:self];
        }
        if ([self.m_pCameraObj IsConnectedOK] && [self.m_pCameraObj IsAdmin])
        {
            [self left];
        }
        //[self left];
    }
    
}



- (void)doPinch:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateEnded) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KYLMontiorTouchProtocolDidGesturePinched:user:)]) {
            [self.delegate KYLMontiorTouchProtocolDidGesturePinched:pinch.scale user:self];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n KYLCameraMonitor touchedbegan------\n");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark opengl 

- (void) CreateGLView
{
    NSLog(@"CreateGLView in %s", __FUNCTION__);
    m_bIsCreateOpenGL = YES;
    //CGRect rect = CGRectMake(0, 50, m_nScreenWidth, m_nScreenHeight-100);
    CGRect rectMain = self.frame;
    CGRect rect = CGRectMake(0, 0, rectMain.size.width, rectMain.size.height);
    
//    if (myGLViewController) {
//        [myGLViewController.view removeFromSuperview];
//        myGLViewController.view.frame = rect;
//        [m_pBgScrollView addSubview:myGLViewController.view];
//    }
    
    [self bringSubviewToFront:lableCameraName];
    [self bringSubviewToFront:btnStart];
    //[self bringSubviewToFront:btnRightBig];
}


- (void) showTheRightButton:(BOOL) bShow
{
    if (bShow) {
        self.btnRightBig.hidden = NO;
    }
    else
    {
        self.btnRightBig.hidden = YES;
    }
}

//ĂÂĂÂÄšĹžÄÂ§ĂÂ¤ÄšÂHUD
- (void) showTheHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText =  NSLocalizedString(@"loading...", @"");
    //CGRect rect = self.view.frame;
    //hud.minSize = rect.size;
    hud.backgroundColor = [UIColor clearColor];
    hud.opacity = 0.2;
    hud.opaque = NO;
    hud.minSize = CGSizeMake(80.f, 80.f);
    
}

- (void) showTheHUD2
{
    NSLog(@"showthehud2");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText =  NSLocalizedString(@"", @"");
    //CGRect rect = self.view.frame;
    //hud.minSize = rect.size;
    hud.backgroundColor = [UIColor clearColor];
    hud.opacity = 0.2;
    hud.opaque = NO;
    hud.minSize = CGSizeMake(80.f, 80.f);
    
}

//ÄĹ ĂÂĂÂĂÂĂÂĂÂHUD
- (void) hideTheHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (BOOL) isCreateGLView
{
    return m_bIsCreateOpenGL;
}


- (void) showTheVideoStopedStatus
{
    if (m_pImageViewForCover) {
        m_pImageViewForCover.image = [UIImage imageNamed:@"backdev"];
        //self.m_pImageView.image = [UIImage imageNamed:@"backdev"];
        //[m_pBgScrollView addSubview:m_pImageViewForCover];
        [self insertSubview:m_pImageViewForCover aboveSubview:m_pBgScrollView];
    }
}

- (void) hideTheVideoStopedStatus
{
    if (m_pImageViewForCover) {
        //[m_pImageViewForCover removeFromSuperview];
        //[self insertSubview:m_pImageViewForCover belowSubview:m_pBgScrollView];
        [m_pImageViewForCover removeFromSuperview];
    }
}


- (void) showTheVideoStopedBgImage:(BOOL) bShow
{
    if (bShow) {
        [self showTheVideoStopedStatus];
    }
    else
    {
        [self hideTheVideoStopedStatus];
    }
}

#pragma mark menus

- (void) showTheMenu
{
}







#pragma mark action

- (int) startVideo
{
    NSLog(@"uso sam ovdje");
    int nRet = -1;
    if (self.m_pCameraObj) {
        NSString *strCameraName = self.m_pCameraObj.m_sDeviceName;
        self.lableCameraName.text = strCameraName;
        if (self.m_pCameraObj.m_nDeviceType == DEVICE_TYPE_NVR) {
            self.lableCameraName.text = [NSString stringWithFormat:@"%@_%d",NSLocalizedString(@"Channel", nil),self.m_pCameraObj.m_nCurrentChannel+1];;
        }
        [self hideTheHUD];
        [self showTheHUD2];
        [self performSelector:@selector(hideTheHUD) withObject:nil afterDelay:2];
        self.m_pCameraObj.m_pImageDelegate = self;
        //[self.m_pCameraObj stopVideo];
        [self setPlay:NO];
        nRet = [self.m_pCameraObj startVideo];
        NSLog(@"self.m_pCameraObj startVideo : %d", nRet);
    }
    return nRet;
}




- (int) stopVideo
{
    int nRet = -1;
    if (self.m_pCameraObj) {
        self.m_pCameraObj.m_pImageDelegate = nil;
        nRet = [self.m_pCameraObj stopVideo];
        [self.m_pCameraObj stopAudio];
        [self.m_pCameraObj stopTalk];
        [self hideTheHUD];
        [self initTheDisplayView];
    }
    return nRet;
}

- (void) startAudio
{
    if (m_pCameraObj) {
        [m_pCameraObj startAudio];
    }
}

- (void) stopAudio
{
    if (m_pCameraObj) {
        [m_pCameraObj stopAudio];
    }
}

- (void) startTalk
{
    if (m_pCameraObj) {
        [m_pCameraObj startTalk];
    }
}

- (void) stopTalk
{
    if (m_pCameraObj) {
        [m_pCameraObj stopTalk];
    }
}


//record
- (void) stopRecord
{
    if (m_pCameraObj) {
        [m_pCameraObj startLocalRecord];
    }
}

- (void) startRecord
{
    if (m_pCameraObj) {
        [m_pCameraObj stopLocalRecord];
    }
}




- (int) up
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj up];
    }
    return nRet;
}

- (int) down
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj down];
    }
    return nRet;
}


- (int) left
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj left];
    }
    return nRet;
}


- (int) right
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj right];
    }
    return nRet;
}

- (int) goLeftRight
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj startGoLeftRight];
    }
    return nRet;
}


- (int) goUpDown
{
    int nRet = -1;
    if (self.m_pCameraObj && bPlaying) {
        nRet = [self.m_pCameraObj startGoUpDown];
    }
    return nRet;
}

- (void) startTurnLeftRight
{
    if (m_pCameraObj) {
        [m_pCameraObj startGoLeftRight];
    }
}

- (void) stopTurnLeftRight
{
    if (m_pCameraObj) {
        [m_pCameraObj stopGoLeftRight];
    }
}

- (void) startTurnUpDown
{
    if (m_pCameraObj) {
        [m_pCameraObj startGoUpDown];
    }
}

- (void) stopTurnUpDown
{
    if (m_pCameraObj) {
        [m_pCameraObj stopGoUpDown];
    }
}

- (void) setPlay:(BOOL) bPlay
{
    {
        bPlaying = bPlay;
    }
}

- (void) snapPicture
{
}



- (void) initTheBordColor
{
    //self.layer.borderColor=[[UIColor greenColor] CGColor];
    self.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.layer.borderWidth=0.6;
    m_bIsSelected = NO;
}

- (void) clearTheBordColor
{
    self.layer.borderColor=[[UIColor clearColor] CGColor];
    self.layer.borderWidth=0;
    m_bIsSelected = NO;
}

- (void) changeBordColorToChoosedColor
{
    self.layer.borderColor=[[UIColor yellowColor] CGColor];
    self.layer.borderWidth=2;
    m_bIsSelected = YES;
}

- (BOOL) isSelected
{
    return m_bIsSelected;
}


#pragma mark common functions
- (NSString*) GetRecordFileName
{
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.rec", self.m_pCameraObj.m_sDID, strDateTime];
    
    [formatter release];
    
    return strFileName;
    
}

- (NSString*) GetRecordPath: (NSString*)strFileName
{
//    //ĂĹĂÂĂÂĂĹÄšÄ˝ÄšÂĂÂĂÂĂÂÄÂ¤ÄšÄ˝ÄšÂÄÂ§ÄšËĂÂÄÂ§ĂÂĂÂĂĹĂÂĂÂ¨
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //ĂÂĂÂĂÂĂĹĂÂĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    //ĂĹĂÂĂÂĂÂĂÂĂÂ°NSDocumentDirectoryĂÂÄšÂĂÂĂÂĂÂĂÂĂĹĂÂĂÂÄĹ ĂÂÄšÂÄÂ§ĂÂ§ĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];//ĂĹĂÂÄšÄ˝ĂĹĂÂ¤ĂÂÄĹ ĂÂĂÂĂÂÄšÂĂÂÄÂ§ĂÂĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    
//    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:self.m_pCameraObj.m_sDID];
//    //NSLog(@"strPath: %@", strPath);
//    
//    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    //{{-- kongyulu at 20150427
    //ĂÂÄšËÄšĹžÄÂ§ĂÂÄšËÄÂ¤ĂÂ¸ĂÂĂĹĂÂ¤ĂÂÄÂ¤ÄšÄ˝ĂÂĂĹĂÂĂÂ°iCloudÄÂ§ĂÂĂÂĂÂĂÂ ĂÂĂÂÄšĹĽĂÂĂÂĂÂĂÂ
    NSString *strPath = [KYLComFunUtil getDefaultFolderInDocumentForDid:self.m_pCameraObj.m_sDID];

    //}}-- kongyulu at 20150427
    
    strPath = [strPath stringByAppendingPathComponent:strFileName];
    
    return strPath;
    
    
}




#pragma mark - ScrollView Delegate

//- (CGRect)zoomRectForScrollView:(UIScrollView *)_scrollView withScale:(float)scale withCenter:(CGPoint)center {
//    CGRect zoomRect;
//    // The zoom rect is in the content view's coordinates.
//    // At a zoom scale of 1.0, it would be the size of the
//    // imageScrollView's bounds.
//    // As the zoom scale decreases, so more content is visible,
//    // the size of the rect grows.
//    zoomRect.size.height = _scrollView.frame.size.height / scale;
//    zoomRect.size.width  = _scrollView.frame.size.width  / scale;
//
//    // choose an origin so as to get the right center.
//    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
//    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
//
//    return zoomRect;
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    UIView *pView = nil;
//    if (m_bIsCreateOpenGL) {
//        pView = myGLViewController.view;
//    }
//    else
    {
        pView = self.m_pImageView;
    }
     return pView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale
{
//    if( myGLViewController ) {
//      //myGLViewController.view.frame = CGRectMake( 0, 0, scrollView.frame.size.width*scale, scrollView.frame.size.height*scale );
//      NSLog( @"{0,0,%d,%d}", (int)(scrollView.frame.size.width*scale), (int)(scrollView.frame.size.height*scale) );
//  }
}


#pragma mark the KYLCameraDelegate call back

- (void) updateImage:(UIImage *) img
{
    if (img && self.m_pImageView) {
        self.m_pImageView.image = img;
    }
}

- (void) updateTheCamearStatus:(NSString *) sStatus
{
    int status = [sStatus intValue];
    switch (status) {
            
        case CONNECT_STATUS_CONNECTED:
        {
            self.btnStart.hidden = YES;
        }
            break;
        case CONNECT_STATUS_DISCONNECT:
        {
            self.btnStart.hidden = NO;
        }
            break;
        case CONNECT_STATUS_CONNECTING:
        {
            
        }
            break;
        case CONNECT_STATUS_ONLINE:
        {
            
        }
            break;
        case CONNECT_STATUS_CONNECT_FAILED:
        case CONNECT_STATUS_INVALID_ID:
        case CONNECT_STATUS_DEVICE_NOT_ONLINE:
        case CONNECT_STATUS_CONNECT_TIMEOUT:
        case CONNECT_STATUS_WRONG_USER_PWD:
        case CONNECT_STATUS_INVALID_REQ:
        case CONNECT_STATUS_EXCEED_MAX_USER:
        case CONNECT_STATUS_INITIALING:
        case CONNECT_STATUS_UNKNOWN:
        {
            
        }
            break;
            
        default:
            break;
    }

    
}



// video stream


- (NSString *) getThePath
{
//    //ĂĹĂÂĂÂĂĹÄšÄ˝ÄšÂĂÂĂÂĂÂÄÂ¤ÄšÄ˝ÄšÂÄÂ§ÄšËĂÂÄÂ§ĂÂĂÂĂĹĂÂĂÂ¨
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //ĂÂĂÂĂÂĂĹĂÂĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    //ĂĹĂÂĂÂĂÂĂÂĂÂ°NSDocumentDirectoryĂÂÄšÂĂÂĂÂĂÂĂÂĂĹĂÂĂÂÄĹ ĂÂÄšÂÄÂ§ĂÂ§ĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];//ĂĹĂÂÄšÄ˝ĂĹĂÂ¤ĂÂÄĹ ĂÂĂÂĂÂÄšÂĂÂÄÂ§ĂÂĂÂĂÂĂÂÄšĹĽĂĹÄšĹžĂÂ
//    
//    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.m_pCameraObj.m_sDID]];
//    
//    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //{{-- kongyulu at 20150427
    //ĂÂÄšËÄšĹžÄÂ§ĂÂÄšËÄÂ¤ĂÂ¸ĂÂĂĹĂÂ¤ĂÂÄÂ¤ÄšÄ˝ĂÂĂĹĂÂĂÂ°iCloudÄÂ§ĂÂĂÂĂÂĂÂ ĂÂĂÂÄšĹĽĂÂĂÂĂÂĂÂ
    NSString *strPath  = [KYLComFunUtil getDefaultFolderInDocumentForDid:self.m_pCameraObj.m_sDID];

    //}}-- kongyulu at 20150427
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString* strDateTime = [formatter stringFromDate:date];
    [formatter release];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@_%@.rec", [NSString stringWithFormat:@"%@",self.m_pCameraObj.m_sDID], strDateTime];
    strFileName = [strPath stringByAppendingString:strFileName];
    
    return strFileName;
}



#pragma mark ImageProtocol delegate
- (void) KYLImageProtocol_didReceiveMJPEGImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did user:(void *) pUser
{
    if (image != nil) {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
    }
    if (bPlaying == NO)
    {
        bPlaying = YES;
        [self performSelectorOnMainThread:@selector(hideTheHUD) withObject:nil waitUntilDone:NO];
    }
    
}

- (void) KYLImageProtocol_didReceiveOneVideoFrameYUVNotify: (char*) yuvdata length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser
{
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    
//    if (version < 4.5) {//4.3.3ÄÂ§ĂÂĂÂĂÂĂÂÄšĹĄ
//        return;
//    }
//    
//    if (bPlaying == NO)
//    {
//        bPlaying = YES;
//        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
//        [self performSelectorOnMainThread:@selector(hideTheHUD) withObject:nil waitUntilDone:NO];
//    }
//    if (myGLViewController) {
//        [myGLViewController WriteYUVFrame:(Byte*) yuvdata Len:length width:width height:height];
//    }
    
}

- (void) KYLImageProtocol_didReceiveOneVideoFrameRGB24Notify: (char*) rgb24data length:(unsigned long)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did user:(void *) pUser
{
    if (bPlaying == NO)
    {
        bPlaying = YES;
        [self performSelectorOnMainThread:@selector(hideTheHUD) withObject:nil waitUntilDone:NO];
    }
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //if ([IpCameraClientAppDelegate is43Version])
    //if (version < 4.5)
    {//4.3.3ÄÂ§ĂÂĂÂĂÂĂÂÄšĹĄ
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        UIImage *image=[APICommon RGB888toImage:(Byte*)rgb24data width:width height:height];
        
        if (image != nil) {
            [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        }
        
        [pool drain];
        return;
    }
    
}

- (void) KYLImageProtocol_didReceiveOneH264VideoFrameWithH264Data: (char*) h264Framedata length: (unsigned long) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did user:(void *) pUser
{
    
}


- (void) registerTheNotifications
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveGetCameraStatusNotification:) name:@KYL_NOTIFICATION_DEVICE_STATUS_CHANGE object:nil];
    
    //REREQUEST_VIDEO_STREAM_NOTIFICATION
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRerequestVideoStreamNotification:) name:@"REREQUEST_VIDEO_STREAM_NOTIFICATION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppWillInBackgroundNotification:)
                                                 name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAppWillInForgroundNotification:)
                                                 name: UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) removeTheNotifications
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@KYL_NOTIFICATION_DEVICE_STATUS_CHANGE object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"REREQUEST_VIDEO_STREAM_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//ĂÂÄšĹşĂÂĂĹĂÂĂËĂĹĂÂĂÂĂĹĂÂĂÂ°ÄĹ ĂÂĂÂÄÂ§ĂÂĂË
- (void) didReceiveAppWillInBackgroundNotification:(NSNotification *) notification
{
    //ÄÂ¤ÄšĹşĂÂĂĹĂÂ­ĂÂĂÂÄšËÄšĹžĂĹĂÂ¤ĂÂÄÂ§ÄšÂĂÂĂĹĂÂÄšÂĂĹĂÂĂÂĂĹĂÂĂÂĂÂĂÂ§ĂÂÄĹ ĂÂĂÂÄÂ§ĂÂĂÂÄÂ§ĂÂÄšÂĂÂĂÂĂÂ
    @synchronized(self)
    {
    }
}

//ĂÂÄšĹşĂÂĂĹĂÂĂËĂĹĂÂĂÂĂĹĂÂĂÂ°ÄĹ ĂÂĂÂÄÂ§ĂÂĂË
- (void) didReceiveAppWillInForgroundNotification:(NSNotification *) notification
{
    @synchronized(self)
    {
    }
}







@end
