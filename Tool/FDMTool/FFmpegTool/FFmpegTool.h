//
//  FFmpegTool.h
//  FDMFFmpegTool
//
//  Created by 发抖喵 on 2020/6/15.
//  Copyright © 2020 发抖喵. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark FFmpegTool

NS_ASSUME_NONNULL_BEGIN

@class FFmpegType;
@interface FFmpegTool : NSObject

/// Be careful BundlePath and DocumentPath and @" "  -   注意文件路径与空格
///
///     NSString *inputFilePath = FBundlePath(@"inputVideo.MP4");
///     NSString *outputFilePath = FDocumentPath(@"outputVideo.mkv");
///
///     NSString *ffmpegString = [NSString stringWithFormat: @"ffmpeg -i %@ %@",inputFilePath,outputFilePath];
///     // ffmpeg -i inputVideo.MP4 outputVideo.mkv
///
///     [FFmpegTool ffmpegWithString:ffmpegString];
///
/// - Parameter NSString *:
///
+ (void)ffmpegWithString:(NSString *)str;
 
/// Be careful BundlePath and DocumentPath   -   注意文件路径
///
///     let ffmpegAry: [FFmpegType] = [.ffmpeg, ._i, .bundle(with: "inputVideo.MP4") .document(with: "outputVideo.mkv")]
///     // ffmpeg -i inputVideo.MP4 outputVideo.mkv
///
///     // let ffmpegAry: [FFmpegType] = [.ffmpeg, ._i, .bundle(with: "inputVideo.MP4"), .document(with: "outputImage%03d.png")]
///     // ffmpeg -i inputVideo.MP4 outputImage%03d.png
///
///     FFmpegTool.startFFmpeg(withAry: ffmpegAry)
///
/// Set other property  -  设置其他属性时
///
///     let setpts: FFmpegType = .init(value: "\"setpts=0.5*PTS\"") or
///     let timer: FFmpegType = .init(value: "00:00:03") or
///     let bit: FFmpegType = .init(value: "320k")
///
/// - Parameter NSArray<FFmpegType *> *:
///     let ffmpegAry = [FFmpegType]()
///
+ (void)ffmpegWithTypeAry:(NSArray<FFmpegType *> *)ary;

/// Be careful BundlePath and DocumentPath   -   注意文件路径
///
///     NSString *inputFilePath = FBundlePath(@"inputVideo.MP4");
///     NSString *outputFilePath = FDocumentPath(@"outputVideo.mkv");
///
///     [FFmpegTool ffmpegWithStringAry: @[@"ffmpeg", @"-i", inputFilePath, outputFilePath]];
///     // ffmpeg -i inputVideo.MP4 outputVideo.mkv
///
/// - Parameter NSArray<NSString *> *:
///     @[@"ffmpeg", @"-i", inputFilePath, outputFilePath];
///
+ (void)ffmpegWithStringAry:(NSArray<NSString *> *)ary;

@end

NS_ASSUME_NONNULL_END



#pragma mark FFmpegType  -  sort in alphabetical order  -  按首字母排序 如果没有找到自己需要的，请自行添加

NS_ASSUME_NONNULL_BEGIN

@interface FFmpegType : NSObject

@property(nonatomic, readonly) NSString *value;                               // Readonly Value

@property(class, nonatomic, readonly) FFmpegType *aac;                        //  aac

@property(class, nonatomic, readonly) FFmpegType *copy;                       //  copy

@property(class, nonatomic, readonly) FFmpegType *ffmpeg;                     //  ffmpeg

@property(class, nonatomic, readonly) FFmpegType *gif;                        //  gif

@property(class, nonatomic, readonly) FFmpegType *hls;                        //  hls

@property(class, nonatomic, readonly) FFmpegType *m4v;                        //  m4v
@property(class, nonatomic, readonly) FFmpegType *mp3;                        //  mp3
@property(class, nonatomic, readonly) FFmpegType *mpeg4;                      //  mpeg4

@property(class, nonatomic, readonly) FFmpegType *_ab;                        //  -ab
@property(class, nonatomic, readonly) FFmpegType *_ac;                        //  -ac
@property(class, nonatomic, readonly) FFmpegType *_acodec;                    //  -acodec
@property(class, nonatomic, readonly) FFmpegType *_af;                        //  -af
@property(class, nonatomic, readonly) FFmpegType *_an;                        //  -an
@property(class, nonatomic, readonly) FFmpegType *_ar;                        //  -ar
@property(class, nonatomic, readonly) FFmpegType *_aspect;                    //  -aspect
@property(class, nonatomic, readonly) FFmpegType *_author;                    //  -author

@property(class, nonatomic, readonly) FFmpegType *_b;                         //  -b
@property(class, nonatomic, readonly) FFmpegType *_bf;                        //  -bf
@property(class, nonatomic, readonly) FFmpegType *_bt;                        //  -bt

@property(class, nonatomic, readonly) FFmpegType *_croptop;                   //  -croptop
@property(class, nonatomic, readonly) FFmpegType *_cropbottom;                //  -cropbottom
@property(class, nonatomic, readonly) FFmpegType *_cropleft;                  //  -cropleft
@property(class, nonatomic, readonly) FFmpegType *_cropright;                 //  -deinterlace

@property(class, nonatomic, readonly) FFmpegType *_deinterlace;               //  -deinterlace

@property(class, nonatomic, readonly) FFmpegType *_f;                         //  -f

@property(class, nonatomic, readonly) FFmpegType *_g;                         //  -g

@property(class, nonatomic, readonly) FFmpegType *_hq;                        //  -hq

@property(class, nonatomic, readonly) FFmpegType *_i;                         //  -i
@property(class, nonatomic, readonly) FFmpegType *_interlace;                 //  -interlace
@property(class, nonatomic, readonly) FFmpegType *_intra;                     //  -intra
@property(class, nonatomic, readonly) FFmpegType *_itsoffset;                 //  -itsoffset

@property(class, nonatomic, readonly) FFmpegType *_padtop;                    //  -padtop
@property(class, nonatomic, readonly) FFmpegType *_padbottom;                 //  -padbottom
@property(class, nonatomic, readonly) FFmpegType *_padleft;                   //  -padleft
@property(class, nonatomic, readonly) FFmpegType *_padright;                  //  -padright
@property(class, nonatomic, readonly) FFmpegType *_padcolor;                  //  -padcolor
@property(class, nonatomic, readonly) FFmpegType *_part;                      //  -part
@property(class, nonatomic, readonly) FFmpegType *_pass;                      //  -pass
@property(class, nonatomic, readonly) FFmpegType *_ps;                        //  -ps

@property(class, nonatomic, readonly) FFmpegType *_qblur;                     //  -qblur
@property(class, nonatomic, readonly) FFmpegType *_qmax;                      //  -qmax
@property(class, nonatomic, readonly) FFmpegType *_qmin;                      //  -qmin
@property(class, nonatomic, readonly) FFmpegType *_qscale;                    //  -qscale

@property(class, nonatomic, readonly) FFmpegType *_r;                         //  -r

@property(class, nonatomic, readonly) FFmpegType *_s;                         //  -s
@property(class, nonatomic, readonly) FFmpegType *_ss;                        //  -ss
@property(class, nonatomic, readonly) FFmpegType *_strict;                    //  -strict

@property(class, nonatomic, readonly) FFmpegType *_t;                         //  -t
@property(class, nonatomic, readonly) FFmpegType *_target;                    //  -target
@property(class, nonatomic, readonly) FFmpegType *_title;                     //  -title

@property(class, nonatomic, readonly) FFmpegType *_vc;                        //  -vc
@property(class, nonatomic, readonly) FFmpegType *_vcodec;                    //  -vcodec
@property(class, nonatomic, readonly) FFmpegType *_vd;                        //  -vd
@property(class, nonatomic, readonly) FFmpegType *_vf;                        //  -vf
@property(class, nonatomic, readonly) FFmpegType *_vn;                        //  -vn

@property(class, nonatomic, readonly) FFmpegType *_y;                         //  -y


+ (instancetype)documentWith:(NSString *)fileName;                            //  DocumentPath/name
+ (instancetype)bundleWith:(NSString *)fileName;                              //  BundlePath/name

- (instancetype)initWithValue:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
