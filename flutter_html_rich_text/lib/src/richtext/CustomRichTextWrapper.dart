// 注意: thanks to 'bytedance - limengyun2008' providing the idea
/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/9/19.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
/// 免费教程  https://www.toutiao.com/c/user/token/MS4wLjABAAAAYMrKikomuQJ4d-cPaeBqtAK2cQY697Pv9xIyyDhtwIM/
///

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'CustomRichTextRenderParagraph.dart';

/// Just a subclass of RichText for overriding createRenderObject
/// to return a [RealRichRenderParagraph] object
///
///   this.textAlign = TextAlign.start,
//    this.textDirection,
//    this.softWrap = true,
//    this.overflow = TextOverflow.clip,
//    this.textScaleFactor = 1.0,
//    this.maxLines,
//    this.locale,
//    this.strutStyle,
//    this.textWidthBasis = TextWidthBasis.parent,
//    this.textHeightBehavior,
class CustomRichTextWrapper extends RichText {
  CustomRichTextWrapper({
    super.key,
    required TextSpan super.text,
    super.textAlign,
    TextDirection? textDirection,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    required int super.maxLines,
    required Locale locale,
  });

  @override
  RenderParagraph createRenderObject(BuildContext context) {
    assert(textDirection != null || debugCheckHasDirectionality(context));
    return CustomRealRichRenderParagraph(
      text as TextSpan,
      textAlign: textAlign,
      textDirection: textDirection ?? Directionality.of(context),
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines ?? 100,
      locale: locale ?? Localizations.maybeLocaleOf(context) ?? Locale.fromSubtags(),
    );
  }
}

