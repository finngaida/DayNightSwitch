#import "DayNightSwitch.h"

@interface PSSwitchTableCell : UITableViewCell
- (SEL)cellAction;
@end

@interface PSSpecifier : NSObject
@end

// MARK: Settings
static BOOL enabled;
static BOOL global;

static void loadPrefs() {
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/de.finngaida.daynightswitch.plist"];
    
    enabled = [settings objectForKey:@"enabled"] ? [[settings objectForKey:@"enabled"] boolValue] : YES;
    global = [settings objectForKey:@"global"] ? [[settings objectForKey:@"global"] boolValue] : NO;
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("de.finngaida.daynightswitch/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    loadPrefs();
}

%hook UISwitch

- (void)didMoveToSuperview {
    %orig;
    
    if (enabled) {
        
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        
        if (global) {
            
            DayNightSwitch *sub = [[DayNightSwitch alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            sub.on = self.on;
            sub.changeAction = ^(BOOL on) {
                
                self.on = on;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            };
            
            self.layer.opacity = 0;
            self.layer.shadowOpacity = 0;
            [self addSubview: sub];
            
        } else if ([bundleId isEqual: @"com.apple.Preferences"]) {
            
            PSSwitchTableCell *cell = (PSSwitchTableCell *)self.superview;
            
            if ([cell respondsToSelector:@selector(specifier)] && [cell respondsToSelector:@selector(control)]) {
                
                id spec = [cell performSelector:@selector(specifier)];
                if ([spec respondsToSelector:@selector(identifier)]) {
                    NSString *identifier = [spec performSelector:@selector(identifier)];
                    
                    if ([identifier isEqual:@"DND_TOP_LEVEL"] && [cell performSelector:@selector(control)] == self) {
                        
                        DayNightSwitch *sub = [[DayNightSwitch alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                        sub.on = self.on;
                        sub.changeAction = ^(BOOL on) {
                            
                            self.on = on;
                            [self sendActionsForControlEvents:UIControlEventValueChanged];
                        };
                        
                        self.layer.opacity = 0;
                        self.layer.shadowOpacity = 0;
                        [self addSubview: sub];
                    }
                }
            }
        }
    }
}

%end