

class SApiUrls {


  static String uploadApi(String cloudName) =>'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static String deleteApi(String cloudName) =>'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';

  static const String aiProxyUrl =
      'https://edutrack-ai-proxy.zubayer2003-coc.workers.dev';


}