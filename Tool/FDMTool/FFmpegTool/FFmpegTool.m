//
//  FFmpegTool.m
//  FDMFFmpegTool
//
//  Created by 发抖喵 on 2020/6/15.
//  Copyright © 2020 发抖喵. All rights reserved.
//

#import "FFmpegTool.h"

#define FDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define FBundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define FDocumentPath(res) [FDocument stringByAppendingPathComponent:res]

extern int ffmpeg_main(int argc, char * argv[]);

#pragma mark FFmpegTool

@implementation FFmpegTool

+ (void)ffmpegWithTypeAry:(NSArray<FFmpegType *> *)ary
{
    NSMutableArray<NSString *> * valueAry = [NSMutableArray array];
    
    for (FFmpegType *type in ary) {
        [valueAry addObject: type.value];
    }
    
    [FFmpegTool ffmpegWithStringAry:valueAry];
}

+ (void)ffmpegWithString:(NSString *)str
{
    [FFmpegTool ffmpegWithStringAry:[str componentsSeparatedByString:@" "]];
}

+ (void)ffmpegWithStringAry:(NSArray<NSString *> *)ary
{    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        int count = (int)[ary count];
        char *a[count];
        
        for (int i = 0; i < count; i++) {
            a[i] = (char*)[ary[i] UTF8String];
        }
        
        ffmpeg_main(sizeof(a)/sizeof(*a), a);
    });
}

@end

#pragma mark FFmpegType
@interface FFmpegType()
@property(nonatomic, readwrite) NSString *value;

@end

@implementation FFmpegType

- (instancetype)initWithValue:(NSString *)value
{
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

#pragma mark ===============================

+ (instancetype)documentWith:(NSString *)fileName
{
    return [[FFmpegType alloc]initWithValue:FDocumentPath(fileName)];
}

+ (instancetype)bundleWith:(NSString *)fileName
{
    return [[FFmpegType alloc]initWithValue:FBundlePath(fileName)];
}

#pragma mark ===============================

+ (FFmpegType *)aac
{
    return [[FFmpegType alloc]initWithValue:@"aac"];
}

+ (FFmpegType *)copy
{
    return [[FFmpegType alloc]initWithValue:@"copy"];
}

+ (FFmpegType *)ffmpeg
{
    return [[FFmpegType alloc]initWithValue:@"ffmpeg"];
}

+ (FFmpegType *)gif
{
    return [[FFmpegType alloc]initWithValue:@"gif"];
}

+ (FFmpegType *)hls
{
    return [[FFmpegType alloc]initWithValue:@"hls"];
}

+ (FFmpegType *)m4v
{
    return [[FFmpegType alloc]initWithValue:@"m4v"];
}

+ (FFmpegType *)mp3
{
    return [[FFmpegType alloc]initWithValue:@"mp3"];
}

+ (FFmpegType *)mpeg4
{
    return [[FFmpegType alloc]initWithValue:@"mpeg4"];
}

#pragma mark ===============================

+ (FFmpegType *)_ab
{
    return [[FFmpegType alloc]initWithValue:@"-ab"];
}

+ (FFmpegType *)_ac
{
    return [[FFmpegType alloc]initWithValue:@"-ac"];
}

+ (FFmpegType *)_acodec
{
    return [[FFmpegType alloc]initWithValue:@"-acodec"];
}

+ (FFmpegType *)_af
{
    return [[FFmpegType alloc]initWithValue:@"-af"];
}

+ (FFmpegType *)_an
{
    return [[FFmpegType alloc]initWithValue:@"-an"];
}

+ (FFmpegType *)_ar
{
    return [[FFmpegType alloc]initWithValue:@"-ar"];
}

+ (FFmpegType *)_aspect
{
    return [[FFmpegType alloc]initWithValue:@"-aspect"];
}

+ (FFmpegType *)_author
{
    return [[FFmpegType alloc]initWithValue:@"-author"];
}

+ (FFmpegType *)_b
{
    return [[FFmpegType alloc]initWithValue:@"-b"];
}

+ (FFmpegType *)_bf
{
    return [[FFmpegType alloc]initWithValue:@"-bf"];
}

+ (FFmpegType *)_bt
{
    return [[FFmpegType alloc]initWithValue:@"-bt"];
}

+ (FFmpegType *)_croptop
{
    return [[FFmpegType alloc]initWithValue:@"-croptop"];
}

+ (FFmpegType *)_cropbottom
{
    return [[FFmpegType alloc]initWithValue:@"-cropbottom"];
}

+ (FFmpegType *)_cropleft
{
    return [[FFmpegType alloc]initWithValue:@"-cropleft"];
}

+ (FFmpegType *)_cropright
{
    return [[FFmpegType alloc]initWithValue:@"-cropright"];
}

+ (FFmpegType *)_deinterlace
{
    return [[FFmpegType alloc]initWithValue:@"-deinterlace"];
}

+ (FFmpegType *)_f
{
    return [[FFmpegType alloc]initWithValue:@"-f"];
}

+ (FFmpegType *)_g
{
    return [[FFmpegType alloc]initWithValue:@"-g"];
}

+ (FFmpegType *)_hq
{
    return [[FFmpegType alloc]initWithValue:@"-hq"];
}

+ (FFmpegType *)_i
{
    return [[FFmpegType alloc]initWithValue:@"-i"];
}

+ (FFmpegType *)_interlace
{
    return [[FFmpegType alloc]initWithValue:@"-interlace"];
}

+ (FFmpegType *)_intra
{
    return [[FFmpegType alloc]initWithValue:@"-intra"];
}

+ (FFmpegType *)_itsoffset
{
    return [[FFmpegType alloc]initWithValue:@"-itsoffset"];
}

+ (FFmpegType *)_padtop
{
    return [[FFmpegType alloc]initWithValue:@"-padtop"];
}

+ (FFmpegType *)_padbottom
{
    return [[FFmpegType alloc]initWithValue:@"-padbottom"];
}

+ (FFmpegType *)_padleft
{
    return [[FFmpegType alloc]initWithValue:@"-padleft"];
}

+ (FFmpegType *)_padright
{
    return [[FFmpegType alloc]initWithValue:@"-padright"];
}

+ (FFmpegType *)_padcolor
{
    return [[FFmpegType alloc]initWithValue:@"-padcolor"];
}

+ (FFmpegType *)_part
{
    return [[FFmpegType alloc]initWithValue:@"-part"];
}

+ (FFmpegType *)_pass
{
    return [[FFmpegType alloc]initWithValue:@"-pass"];
}

+ (FFmpegType *)_ps
{
    return [[FFmpegType alloc]initWithValue:@"-ps"];
}

+ (FFmpegType *)_qblur
{
    return [[FFmpegType alloc]initWithValue:@"-qblur"];
}

+ (FFmpegType *)_qmax
{
    return [[FFmpegType alloc]initWithValue:@"-qmax"];
}

+ (FFmpegType *)_qmin
{
    return [[FFmpegType alloc]initWithValue:@"-qmin"];
}

+ (FFmpegType *)_qscale
{
    return [[FFmpegType alloc]initWithValue:@"-qscale"];
}

+ (FFmpegType *)_r
{
    return [[FFmpegType alloc]initWithValue:@"-r"];
}

+ (FFmpegType *)_s
{
    return [[FFmpegType alloc]initWithValue:@"-s"];
}

+ (FFmpegType *)_ss
{
    return [[FFmpegType alloc]initWithValue:@"-ss"];
}

+ (FFmpegType *)_strict
{
    return [[FFmpegType alloc]initWithValue:@"-strict"];
}

+ (FFmpegType *)_t
{
    return [[FFmpegType alloc]initWithValue:@"-y"];
}

+ (FFmpegType *)_target
{
    return [[FFmpegType alloc]initWithValue:@"-target"];
}

+ (FFmpegType *)_title
{
    return [[FFmpegType alloc]initWithValue:@"-title"];
}

+ (FFmpegType *)_vc
{
    return [[FFmpegType alloc]initWithValue:@"-vc"];
}

+ (FFmpegType *)_vcodec
{
    return [[FFmpegType alloc]initWithValue:@"-vcodec"];
}

+ (FFmpegType *)_vd
{
    return [[FFmpegType alloc]initWithValue:@"-vd"];
}

+ (FFmpegType *)_vf
{
    return [[FFmpegType alloc]initWithValue:@"-vf"];
}

+ (FFmpegType *)_vn
{
    return [[FFmpegType alloc]initWithValue:@"-vn"];
}

+ (FFmpegType *)_y
{
    return [[FFmpegType alloc]initWithValue:@"-y"];
}

@end
