//
//  PMSocketClientImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketClientImpl.h"
#import <SocketRocket/SRWebSocket.h>
#import "PMBaseSocketCommand.h"
#import "PMSocketResponse.h"
#import <Mantle/Mantle.h>
#import "PMObjectMapper.h"
#import <AFNetworking/AFNetworking.h>

@interface PMBaseSocketClientImpl () <SRWebSocketDelegate>
@property (strong, nonatomic) SRWebSocket *socket;
@property (strong, nonatomic) NSURL *baseUrl;

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString * , RACSubject *> * > *subjectsByIdx;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString * , RACSubject *> * > *subjectByCommand;
@end

@implementation PMBaseSocketClientImpl

#pragma mark - public

- (instancetype)initWithBaseURL:(NSURL *)url;
{
    self = [super init];
    if (self) {
        self.baseUrl = url;
        
        self.subjectsByIdx = [NSMutableDictionary dictionary];
        self.subjectByCommand = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc
{
    [self closeSocket];
}

- (void)openSocketWithParams:(NSDictionary *)params
{
    NSURL *url = [self baseUrlWithParameters:params];
    [self createSocketWithUrl:url];
    [self.socket open];
}

- (void)closeSocket
{
    [self.socket close];
}

- (RACSignal *)registerCommand:(NSString *)command ofType:(NSString *)type mapResponseToClass:(Class)class
{
    RACSubject *subject = [RACSubject subject];
    RACSignal *signal = [self mapResponse:subject keyPath:PMSelectorString(payload) toClass:class];
    [self addSubject:subject type:type command:command];
    return signal;
}

- (RACSignal *)sendCommand:(PMBaseSocketCommand *)command mapResponseToClass:(Class)class
{
    RACSubject *subject = [self generateSubjectForCommand:command];
    RACSignal *signal = [self mapResponse:subject keyPath:PMSelectorString(payload) toClass:class];
    [self sendCommand:command];
    return signal;
}

- (void)sendCommand:(PMBaseSocketCommand *)command
{
    NSData *data = [self dataFromCommand:command];
    [[NSNotificationCenter defaultCenter] postNotificationName:PMSocketClientDidSendMessage object:self userInfo:@{PMSocketClientResponseDataKey: data}];
    [self.socket send:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    PMSocketResponse *response = [self soketResponseFromMessage:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:PMSocketClientDidReceiveMessage object:self userInfo:@{PMSocketClientResponseDataKey: message}];
    [self routeSocketResponse:response];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PMSocketClientDidConnect object:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PMSocketClientDidFail object:self userInfo:@{PMSocketClientErrorKey: error}];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PMSocketClientDidDisconnect object:self userInfo:@{PMSocketClientCodeKey: @(code),
                                                                                                                  PMSocketClientReasonKey: reason ?: @""}];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{}

#pragma mark - private

- (NSURL *)baseUrlWithParameters:(NSDictionary *)parameters
{
    NSString *baseUrlString = [self.baseUrl absoluteString];
    NSString *query = [self queryStringFromParameters:parameters];
    return [NSURL URLWithString:[baseUrlString stringByAppendingFormat:@"?%@", query]];
}

- (NSString *)queryStringFromParameters:(NSDictionary *)parameters
{
    return AFQueryStringFromParameters(parameters);
}

- (void)createSocketWithUrl:(NSURL *)url
{
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    self.socket.delegate = self;
}

- (RACSubject *)generateSubjectForCommand:(PMBaseSocketCommand *)command
{
    command.idx = [self generateIdx];
    RACSubject *subject = [RACSubject subject];
    [self addSubject:subject forCommandByIdx:command];
    return subject;
}

- (NSString *)generateIdx
{
    return [[NSUUID UUID] UUIDString];
}

- (void)addSubject:(RACSubject *)subject type:(NSString *)type command:(NSString *)command
{
    NSMutableDictionary *dict = [self subjectsDictionaryForType:type fromDictionary:self.subjectByCommand];
    [dict setObject:subject forKey:command];
}

- (void)addSubject:(RACSubject *)subject forCommandByIdx:(PMBaseSocketCommand *)command
{
    NSMutableDictionary *dict = [self subjectsDictionaryForType:command.type fromDictionary:self.subjectsByIdx];
    [dict setObject:subject forKey:command.idx];
}

- (NSMutableDictionary *)subjectsDictionaryForType:(NSString *)type fromDictionary:(NSMutableDictionary *)dict
{
    NSMutableDictionary *subjectsDictionary = [dict objectForKey:type];
    
    if (!subjectsDictionary) {
        subjectsDictionary = [NSMutableDictionary dictionary];
        [dict setObject:subjectsDictionary forKey:type];
    }
    
    return subjectsDictionary;
}

- (NSData *)dataFromCommand:(PMBaseSocketCommand *)command
{
    NSDictionary *message = [MTLJSONAdapter JSONDictionaryFromModel:command error:nil];
    return [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
}

- (PMSocketResponse *)soketResponseFromMessage:(id)message
{
    NSDictionary *json = [self dictionaryFromMessage:message];
    return [MTLJSONAdapter modelOfClass:[PMSocketResponse class] fromJSONDictionary:json error:nil];
}

- (NSDictionary *)dictionaryFromMessage:(id)message
{
    NSData *data = message;
    
    if ([message isKindOfClass:[NSString class]]) {
        data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)routeSocketResponse:(PMSocketResponse *)response
{
    if (response.replyTo) {
        [self routeResponseByReplyTo:response];
    }
    else {
        [self routeResponseByCommand:response];
    }
}

- (void)routeResponseByReplyTo:(PMSocketResponse *)response
{
    RACSubject *subject = [[self.subjectsByIdx objectForKey:response.type] objectForKey:response.replyTo];
    [subject sendNext:response];
    [subject sendCompleted];
    [self.subjectsByIdx removeObjectForKey:response.replyTo];
}

- (void)routeResponseByCommand:(PMSocketResponse *)response
{
    RACSubject *subject = [[self.subjectByCommand objectForKey:response.type] objectForKey:response.replyTo];
    [subject sendNext:response];
}

- (RACSignal *)mapResponse:(RACSubject *)signal keyPath:(NSString *)keyPath toClass:(Class)klass
{
    @weakify(self);
    return [signal flattenMap:^RACSignal *(id responseObject) {
        @strongify(self);
        return [self.objectMapper mapResponseObject:responseObject keyPath:keyPath toClass:klass];
    }];
}

@end
