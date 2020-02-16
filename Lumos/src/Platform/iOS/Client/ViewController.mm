#import "ViewController.h"

#include "../iOSOS.h"
#include "../iOSWindow.h"
#include "../iOSKeyCodes.h"
#include "App/Application.h"

#include "UIWindow.h"

#import <QuartzCore/CAMetalLayer.h>

#pragma mark -
#pragma mark ViewController

@implementation ViewController {
    CADisplayLink* _displayLink;
    BOOL _viewHasAppeared;
    Lumos::iOSOS* os;
    LumosUIWindow* uiWindow;
}

- (void)didReceiveMemoryWarning {
    printf("Receive memory warning!\n");
};

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeAll;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation {
    return YES;
};

/** Since this is a single-view app, init Vulkan when the view is loaded. */
-(void) viewDidLoad {
	[super viewDidLoad];

    self.view.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.view.contentMode = UIViewContentModeScaleAspectFill;

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }
    
    assert([self.view isKindOfClass:[UIView class]]);
    
    self.view.autoresizesSubviews = true;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    _viewHasAppeared = NO;

}

-(void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    
    _viewHasAppeared = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    Lumos::iOSWindow::SetIOSView((__bridge void *)self.view);
    Lumos::iOSOS::SetWindowSize(self.view.bounds.size.width * self.view.contentScaleFactor, self.view.bounds.size.height * self.view.contentScaleFactor);
    Lumos::iOSOS::Create();
    os = (Lumos::iOSOS*)Lumos::iOSOS::Instance();
    os->SetIOSView((__bridge void *)self.view);
     
    uint32_t fps = 60;
    _displayLink = [CADisplayLink displayLinkWithTarget: self selector: @selector(renderFrame)];
    _displayLink.preferredFramesPerSecond = fps;
    [_displayLink addToRunLoop: NSRunLoop.currentRunLoop forMode: NSDefaultRunLoopMode];

    // Setup tap gesture to toggle virtual keyboard
    UITapGestureRecognizer* tapSelector = [[UITapGestureRecognizer alloc]
                                        initWithTarget: self action: @selector(handleTapGesture:)];
    tapSelector.numberOfTapsRequired = 3;
    tapSelector.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer: tapSelector];
}

-(BOOL) canBecomeFirstResponder { return _viewHasAppeared; }

-(void) renderFrame {
    os->OnFrame();
}

-(void) dealloc {
    os->OnQuit();
    delete os;
    [super dealloc];
}

// Toggle the display of the virtual keyboard
-(void) toggleKeyboard {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    } else {
        [self becomeFirstResponder];
    }
}

// Display and hide the keyboard by tapping on the view
-(void) handleTapGesture: (UITapGestureRecognizer*) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self toggleKeyboard];
    }
}

// Handle keyboard input
-(void) handleKeyboardInput: (unichar) keycode {
    os->OnKeyPressed(keycode, true);
}

#pragma mark UIKeyInput methods

// Returns whether text is available
-(BOOL) hasText { return YES; }

// A key on the keyboard has been pressed.
-(void) insertText: (NSString*) text {
    unichar keycode = (text.length > 0) ? [text characterAtIndex: 0] : 0;
    [self handleKeyboardInput: keycode];
}

// The delete backward key has been pressed.
-(void) deleteBackward {
    [self handleKeyboardInput: 0x33];
}

-( void )touchesBegan:( NSSet< UITouch* >* )touches withEvent:( UIEvent* )event
{
    for( UITouch* touch in touches )
    {
        CGPoint   point = [ touch locationInView:self.view ];
        NSInteger index = [ touch.estimationUpdateIndex integerValue ];
        Lumos::iOSOS::Get()->OnScreenPressed(point.x, point.y, (u32)index, true);
    }
}

-( void )touchesMoved:( NSSet< UITouch* >* )touches withEvent:( UIEvent* )event
{
    for( UITouch* touch in touches )
    {
        CGPoint   point = [ touch locationInView:self.view ];
        //NSInteger index = [ touch.estimationUpdateIndex integerValue ];
        Lumos::iOSOS::Get()->OnMouseMovedEvent(point.x, point.y);
    }
}

-( void )touchesEnded:( NSSet< UITouch* >* )touches withEvent:( UIEvent* )event
{
    for( UITouch* touch in touches )
    {
        CGPoint   point = [ touch locationInView:self.view ];
        NSInteger index = [ touch.estimationUpdateIndex integerValue ];
        Lumos::iOSOS::Get()->OnScreenPressed(point.x, point.y, (u32)index,false);
    }
}

-( void )touchesCancelled:( NSSet< UITouch* >* )touches withEvent:( UIEvent* )event
{
    for( UITouch* touch in touches )
    {
        CGPoint   point = [ touch locationInView:self.view ];
        NSInteger index = [ touch.estimationUpdateIndex integerValue ];
        Lumos::iOSOS::Get()->OnScreenPressed(point.x, point.y, (u32)index,false);
    }
}

-( void )layoutSubviews
{
    [ super layoutSubviews ];
    Lumos::iOSOS::Get()->OnScreenResize(self.view.bounds.size.width * self.view.contentScaleFactor, self.view.bounds.size.height * self.view.contentScaleFactor);
}

@end

#pragma mark -
#pragma mark MetalView

@implementation MetalView

/** Returns a Metal-compatible layer. */
+(Class) layerClass { return [CAMetalLayer class]; }

@end
