#import <objc/runtime.h>

#import "EJAppViewController.h"
#import "EJJavaScriptView.h"

@implementation EJAppViewController

- (id)initWithScriptAtPath:(NSString *)pathp {
	if( self = [super init] ) {
		path = [pathp retain];
		landscapeMode = [[[NSBundle mainBundle] infoDictionary][@"UIInterfaceOrientation"]
			hasPrefix:@"UIInterfaceOrientationLandscape"];
	}
	return self;
}

- (void)dealloc {
	self.view = nil;
	[path release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	[(EJJavaScriptView *)self.view clearCaches];
	[super didReceiveMemoryWarning];
}

- (void)loadView {
	CGRect frame = UIScreen.mainScreen.bounds;

	// iOS pre 8.0 doesn't rotate the frame size in landscape mode, so we have to
	// do it ourselfs
	if( landscapeMode && EJECTA_SYSTEM_VERSION_LESS_THAN(@"8.0") ) {
		frame.size = CGSizeMake(frame.size.height, frame.size.width);
	}
	
	EJJavaScriptView *view = [[EJJavaScriptView alloc] initWithFrame:frame];
	self.view = view;
	
	[view loadScriptAtPath:path];
	[view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
