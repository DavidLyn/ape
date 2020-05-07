import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';

import 'package:ape/util/log_utils.dart';

/// 创建图片 widget（支持本地与网络图片）
class LoadedImageWidget extends StatelessWidget {
  
  const LoadedImageWidget(this.image, {
    Key key,
    this.width, 
    this.height,
    this.fit: BoxFit.cover, 
    this.format: 'png',
    this.holderImg: 'img_none'
  }): super(key: key);
  
  final String image;
  final double width;
  final double height;
  final BoxFit fit;
  final String format;
  final String holderImg;
  
  @override
  Widget build(BuildContext context) {
    if (TextUtil.isEmpty(image) || image == 'null') {
      return LoadedAssetImageWidget(holderImg,
        height: height,
        width: width,
        fit: fit,
        format: format
      );
    } else {
      if (image.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => LoadedAssetImageWidget(holderImg, height: height, width: width, fit: fit),
          errorWidget: (context, url, error) => LoadedAssetImageWidget(holderImg, height: height, width: width, fit: fit),
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return LoadedAssetImageWidget(image,
            height: height,
            width: width,
            fit: fit,
            format: format
        );
      }
    }
  }
}

/// 加载本地资源图片
class LoadedAssetImageWidget extends StatelessWidget {
  
  const LoadedAssetImageWidget(this.image, {
    Key key,
    this.width,
    this.height, 
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.format: 'png',
    this.color
  }): super(key: key);

  final String image;
  final double width;
  final double height;
  final int cacheWidth;
  final int cacheHeight;
  final BoxFit fit;
  final String format;
  final Color color;
  
  @override
  Widget build(BuildContext context) {

    return Image.asset(
      ImageUtils.getImgPath(image, format: format),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}

/// 图片加载工具 - 提供从本地资源或Web获取 ImageProvider
///
class ImageUtils {

  static ImageProvider getAssetImageProvider(String name, {String format: 'png'}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static ImageProvider getWebImageProvider(String imageUrl, {String holderImg: 'img_none'}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(getImgPath(holderImg));
    }
    return CachedNetworkImageProvider(imageUrl, errorListener: () => Log.e("图片加载失败！"));
  }
}