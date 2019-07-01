// Objective-C API for talking to gitlab.udux.com/tools/rntools Go package.
//   gobind -lang=objc gitlab.udux.com/tools/rntools
//
// File is generated by gobind. Do not edit.

#ifndef __Rntools_H__
#define __Rntools_H__

@import Foundation;
#include "Universe.objc.h"


@class RntoolsCache;
@class RntoolsConfig;
@class RntoolsFileStore;
@class RntoolsHLSProxy;
@class RntoolsNoSIGPIPEDialer;
@class RntoolsProxyResult;
@class RntoolsServer;
@protocol RntoolsEventBus;
@class RntoolsEventBus;

@protocol RntoolsEventBus <NSObject>
- (void)sendMessageEvent:(NSString*)channel message:(NSString*)message;
@end

@interface RntoolsCache : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
/**
 * CacheKey generate cache key hash
 */
- (NSString*)cacheKey:(NSString*)key;
@end

@interface RntoolsConfig : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)target;
- (void)setTarget:(NSString*)v;
- (BOOL)debug;
- (void)setDebug:(BOOL)v;
- (NSString*)cacheFolder;
- (void)setCacheFolder:(NSString*)v;
- (NSString*)port;
- (void)setPort:(NSString*)v;
@end

@interface RntoolsFileStore : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped method FileStore.Get with unsupported parameter or return types

/**
 * Has from a NoopStore will always return false, nil.
 */
- (BOOL)has:(NSString*)key ret0_:(BOOL*)ret0_ error:(NSError**)error;
// skipped method FileStore.Put with unsupported parameter or return types

@end

/**
 * HLSProxy handles file cache
 */
@interface RntoolsHLSProxy : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
/**
 * NewHLSProxy creates a new server
 */
- (instancetype)init;
// skipped field HLSProxy.Logger with unsupported type: *log.Logger

/**
 * Clear clear proxy cache
 */
- (RntoolsProxyResult*)clear;
/**
 * Has check if cache has item or cache item
 */
- (RntoolsProxyResult*)has:(NSString*)fullURL;
/**
 * RewriteHLS rewrite hls segment urls to proxy urls
 */
- (RntoolsProxyResult*)rewriteHLS:(NSString*)fullURL;
/**
 * Setup setup cache proxy
 */
- (void)setup:(NSString*)addr cachePath:(NSString*)cachePath;
@end

/**
 * NoSIGPIPEDialer returns a dialer that won't SIGPIPE should a connection
actually SIGPIPE. This prevents the debugger from intercepting the signal
even though this is normal behaviour.
 */
@interface RntoolsNoSIGPIPEDialer : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field NoSIGPIPEDialer.Timeout with unsupported type: time.Duration

// skipped field NoSIGPIPEDialer.Deadline with unsupported type: time.Time

// skipped field NoSIGPIPEDialer.LocalAddr with unsupported type: net.Addr

- (BOOL)dualStack;
- (void)setDualStack:(BOOL)v;
// skipped field NoSIGPIPEDialer.FallbackDelay with unsupported type: time.Duration

// skipped field NoSIGPIPEDialer.KeepAlive with unsupported type: time.Duration

// skipped field NoSIGPIPEDialer.Resolver with unsupported type: *net.Resolver

// skipped field NoSIGPIPEDialer.Cancel with unsupported type: <-chan struct{}

// skipped method NoSIGPIPEDialer.Dial with unsupported parameter or return types

// skipped method NoSIGPIPEDialer.DialContext with unsupported parameter or return types

@end

@interface RntoolsProxyResult : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (BOOL)ok;
- (void)setOk:(BOOL)v;
- (NSString*)key;
- (void)setKey:(NSString*)v;
- (NSError*)error;
- (void)setError:(NSError*)v;
- (NSData*)data;
- (void)setData:(NSData*)v;
@end

/**
 * Server defines a proxy cache server
 */
@interface RntoolsServer : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
/**
 * NewServer creates a new server
 */
- (instancetype)init;
/**
 * Setup setup the server with addr and cache path
 */
- (void)setup:(NSString*)addr cachePath:(NSString*)cachePath;
/**
 * Shutdown the server
 */
- (void)shutdown;
/**
 * Start the server
 */
- (void)start;
@end

FOUNDATION_EXPORT const long RntoolsMetadata;

@interface Rntools : NSObject
// skipped variable Debug with unsupported type: *log.Logger

// skipped variable DebugWriter with unsupported type: io.Writer

/**
 * DefaultServer is a global proxy server
 */
+ (RntoolsServer*) defaultServer;
+ (void) setDefaultServer:(RntoolsServer*)v;

// skipped variable Error with unsupported type: *log.Logger

// skipped variable ErrorWriter with unsupported type: io.Writer

// skipped variable Info with unsupported type: *log.Logger

// skipped variable InfoWriter with unsupported type: io.Writer

// skipped variable NoSIGPIPETransport with unsupported type: net/http.RoundTripper

@end

FOUNDATION_EXPORT RntoolsCache* RntoolsCreateCache(NSString* path, NSError** error);

FOUNDATION_EXPORT void RntoolsGetHLS(NSString* url, NSString* storage, NSString* segmentURLPrefix, id<RntoolsEventBus> dispatcher);

FOUNDATION_EXPORT void RntoolsGetMultipleHLS(NSString* urlsString, NSString* storage, NSString* segmentURLPrefix, id<RntoolsEventBus> dispatcher);

FOUNDATION_EXPORT RntoolsConfig* RntoolsLoadConfig(NSString* path, NSError** error);

/**
 * NewHLSProxy creates a new server
 */
FOUNDATION_EXPORT RntoolsHLSProxy* RntoolsNewHLSProxy(void);

/**
 * NewServer creates a new server
 */
FOUNDATION_EXPORT RntoolsServer* RntoolsNewServer(void);

FOUNDATION_EXPORT RntoolsServer* RntoolsOnDebug(RntoolsServer* s);

/**
 * ReplaceHLSUrls replace hls urls
 */
FOUNDATION_EXPORT NSData* RntoolsReplaceHLSUrls(NSData* hlsRaw, NSString* proxyServerURL, NSError** error);

// skipped function SilenceSIGPIPE with unsupported parameter or return types


@class RntoolsEventBus;

@interface RntoolsEventBus : NSObject <goSeqRefInterface, RntoolsEventBus> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (void)sendMessageEvent:(NSString*)channel message:(NSString*)message;
@end

#endif
