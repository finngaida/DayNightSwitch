#include "FGARootListController.h"
#include <spawn.h>

@implementation FGARootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }
    
    return _specifiers;
}

- (void)respring {
    pid_t pid;
    const char* args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)twitter {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:[NSURL URLWithString:@"twitter://fga"]]) {
        [app openURL:[NSURL URLWithString:@"twitter://user?screen_name=fga"] options: @{} completionHandler: nil];
    } else if ([app canOpenURL:[NSURL URLWithString:@"tweetbot://fga/user_profile/fga"]]) {
        [app openURL:[NSURL URLWithString:@"tweetbot://fga/user_profile/fga"] options: @{} completionHandler: nil];
    } else if ([app canOpenURL:[NSURL URLWithString:@"https://twitter.com/fga"]]) {
        [app openURL:[NSURL URLWithString:@"https://twitter.com/fga"] options: @{} completionHandler: nil];
    }
}

- (void)github {
    [self openURL: [NSURL URLWithString:@"https://github.com/finngaida"]];
}

- (void)mail {
    [self openURL: [NSURL URLWithString:@"mailto:f@fga.pw?subject=DayNightSwitch%20Feature%20Request"]];
}

- (void)paypal {
    [self openURL: [NSURL URLWithString:@"https://paypal.me/fga"]];
}

-(void)openURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL: url options: @{} completionHandler: nil];
}

@end
