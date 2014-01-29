#import "AppDelegate.h"
#import "ALPValidator.h"

@interface AppDelegate () <ALPValidatorDelegate>

@end

@implementation AppDelegate

#pragma mark App Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Required validation
    ALPValidator *requiredValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [requiredValidator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [requiredValidator validate:nil];
    NSLog(@"%@", requiredValidator);
    [requiredValidator validate:@"present"];
    NSLog(@"%@", requiredValidator);
    
    // Minimum length validation
    ALPValidator *minLenghtValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [minLenghtValidator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"This is not long enough!", nil)];
    [minLenghtValidator validate:@"small"];
    NSLog(@"%@", minLenghtValidator);
    [minLenghtValidator validate:@"biiiiig"];
    NSLog(@"%@", minLenghtValidator);
    
    // Maximum length validation
    ALPValidator *maxLenghtValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [maxLenghtValidator addValidationToEnsureMaximumLength:10 invalidMessage:NSLocalizedString(@"This is too long!", nil)];
    [maxLenghtValidator validate:@"short"];
    NSLog(@"%@", maxLenghtValidator);
    [maxLenghtValidator validate:@"loooooooong"];
    NSLog(@"%@", maxLenghtValidator);
    
    // Regular expression validation
    ALPValidator *regexValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [regexValidator addValidationToEnsureRegularExpressionIsMetWithPattern:@"hello" invalidMessage:NSLocalizedString(@"You have to say hello!", nil)];
    [regexValidator validate:@"hi"];
    NSLog(@"%@", regexValidator);
    [regexValidator validate:@"hello"];
    NSLog(@"%@", regexValidator);
    
    // Email validation
    ALPValidator *emailValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [emailValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];
    [emailValidator validate:@"invalid@email,co,uk"];
    NSLog(@"%@", emailValidator);
    [regexValidator validate:@"valid@email.co.uk"];
    NSLog(@"%@", emailValidator);
    
    // Custom validation
    ALPValidator *customValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [customValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
        return ([instance rangeOfString:@"A"].location == NSNotFound);
    } invalidMessage:NSLocalizedString(@"No capital As are allowed", nil)];
    [customValidator validate:@"hAllo world!"];
    NSLog(@"%@", customValidator);
    [regexValidator validate:@"hello world!"];
    NSLog(@"%@", customValidator);
    
    // Multiple validations mixed together:
    ALPValidator *mixedValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [mixedValidator addValidationToEnsureMinimumLength:15 invalidMessage:NSLocalizedString(@"This is too short!", nil)];
    [mixedValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
        return ([instance rangeOfString:@"A"].location == NSNotFound);
    } invalidMessage:NSLocalizedString(@"No capital As are allowed!", nil)];
    [mixedValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];
    [mixedValidator validate:@"invA@lid,com"];
    NSLog(@"%@", mixedValidator);
    [mixedValidator validate:@"valid@email.com"];
    NSLog(@"%@", mixedValidator);
    
    // Remote validation (Note - run the mock server using the Sinatra server included)
    // The server returns JSON "true" if the input does not contain the word "invalid" and JSON "false" otherwise.
    // The delegate logs the repsonse in this example
    ALPValidator *remoteValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [remoteValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:[NSURL URLWithString:@"http:127.0.0.1:4567/validate"] invalidMessage:NSLocalizedString(@"Remote condition has not been satisfied", nil)];
    remoteValidator.delegate = self;
    [remoteValidator validate:@"valid"];
    [remoteValidator validate:@"invalid"];
    
    // Change handlers
    ALPValidator *someValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    someValidator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        switch (newState) {
            case ALPValidatorValidationStateValid:
                // do valid happy things
                break;
            case ALPValidatorValidationStateInvalid:
                // do invalid unhappy things
                break;
            case ALPValidatorValidationStateWaitingForRemote:
                // do loading indicator things
                break;
        }
    };
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark ALPValidatorDelegate

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid
{
    NSLog(@"Remote validation returned: %@", (remoteConditionValid) ? @"YES" : @"NO");
    NSLog(@"%@", validator);
}

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

@end
