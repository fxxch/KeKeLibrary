#
#  Be sure to run `pod spec lint KeKeLibrary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

# pod lib  lint                    --verbose --use-libraries --allow-warnings
# pod spec lint  KeKeLibrary.podspec --verbose --use-libraries --allow-warnings
# pod trunk push KeKeLibrary.podspec --verbose --use-libraries --allow-warnings

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

    s.name         = "KeKeLibrary"
    s.version      = "0.1.5"
    s.summary      = "A marquee view used on iOS."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
    s.description   = <<-DESC
                    It is a marquee view used on iOS, which implement by Objective-C.
                    DESC

    s.homepage      = "https://github.com/fxxch/KeKeLibrary"
  # s.screenshots = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

    s.license    = 'MIT'
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

    s.author             = { "刘波" => "349230334@qq.com" }
  # Or just: s.author    = ""
  # s.authors            = { "" => "" }
  # s.social_media_url   = "http://twitter.com/"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
    s.platform     = :ios, "10.0"

  #  When using multiple platforms
    s.ios.deployment_target = "10.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  # 根据Tag
   s.source       = { :git => "https://github.com/fxxch/KeKeLibrary.git", :tag => s.version }

  # 根据提交的版本标识符
  # s.source       = { :git => "https://github.com/fxxch/KeKeLibrary.git", :commit => 'f8509d887a3788a5d2673315fc0769bac4b4d903'}
 

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

    s.source_files  = "KKLibrary/Classes/**/*.{h,m,c}"
    s.public_header_files = "KKLibrary/Classes/**/*.h"
  # s.exclude_files = "Classes/Exclude"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
    s.resources = "KKLibrary/Classes/**/*.{bundle,sqlite,caf,txt,plist}"  

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"


  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'FMDB'
  
  # s.dependency 'MBProgressHUD'
  # s.dependency 'AFNetworking'
  # s.dependency 'PinYin4Objc'
  # s.dependency 'AMap3DMap-NO-IDFA', '~> 5.5.0'
  # s.dependency 'AMapLocation-NO-IDFA', '~> 2.5.0'
  # s.dependency 'AMapSearch-NO-IDFA', '~> 5.5.0'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # 自己制作引用的framework
  # s.vendored_frameworks = 'Framework.framework'
  
    
  # 1、s.license Pods依赖库使用的license类型，大家填上自己对应的选择即可。
  # 2、s.source_files 表示源文件的路径，注意这个路径是相对podspec文件而言的。
  # 3、s.frameworks 需要用到的frameworks，不需要加.frameworks后缀。

end
