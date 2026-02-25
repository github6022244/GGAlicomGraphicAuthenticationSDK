Pod::Spec.new do |s|
  # ===================== 基础信息（必填，按需修改）=====================
  s.name         = "GGAlicomGraphicAuthenticationSDK"
  s.version      = "0.1.0"
  s.summary      = "阿里云验证码保护 SDK（AlicomCaptcha4）- 静态框架版"
  s.description  = <<-DESC
                    阿里云验证码保护 SDK，支持滑块/点选验证，适配 iOS 9.0+，
                    包含 framework 核心库和 bundle 资源包，已配置 -ObjC 链接参数。
                   DESC
  s.homepage     = "https://help.aliyun.com/document_detail/2189838.html"
  s.license      = {
    :type => "MIT",
    :text => <<-LICENSE
      Copyright (c) 2026 GG
      Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the "Software"), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:
      The above copyright notice and this permission notice shall be included in all
      copies or substantial portions of the Software.
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
      SOFTWARE.
      ---
      注意：本 Pod 仅封装阿里云验证码 SDK（AlicomCaptcha4），SDK 本身遵循阿里云商业授权协议，
      使用前需确保已获得阿里云的合法授权，本仓库的 MIT 协议仅适用于封装代码，不覆盖 SDK 本身。
    LICENSE
  }
  s.author       = { "GG" => "1563084860@qq.com" }
  s.platform     = :ios, "13.0"
  s.requires_arc = true
  s.static_framework = true

  # ===================== 源码/资源路径（核心，严格匹配目录）=====================
  s.source       = { :git => "https://github.com/github6022244/GGAlicomGraphicAuthenticationSDK.git", :tag => s.version.to_s }

  # 1. 引入阿里云静态 framework
  s.vendored_frameworks = "GGAlicomGraphicAuthenticationSDK/Classes/AlicomCaptcha4.framework"

  # 2. 引入 bundle 资源包
  # 解决方案：使用 resources 而不是 resource_bundles，避免 Info.plist 冲突
  # 直接引入整个 bundle 目录，让 CocoaPods 正确处理
  s.resources = [
    "GGAlicomGraphicAuthenticationSDK/Assets/AlicomCaptcha4.bundle"
  ]
  
  # 3. 源码文件
  s.source_files = [
    "GGAlicomGraphicAuthenticationSDK/Classes/Manager/**/*.{h,m}",
  ]

  # ===================== 编译配置（覆盖官方所有要求）=====================
  # 1. 添加 -ObjC 解决 Category 调用问题
  s.xcconfig = {
    "OTHER_LDFLAGS" => "-ObjC",
    "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/#{s.name}/GGAlicomGraphicAuthenticationSDK/Classes",
    "RESOURCE_SEARCH_PATHS" => "$(PODS_ROOT)/#{s.name}/GGAlicomGraphicAuthenticationSDK/Assets"
  }
  
  # 2. SDK 依赖的系统框架
  #s.frameworks = "UIKit", "Foundation", "Security", "WebKit", "CoreGraphics", "AVFoundation"

  # ===================== 头文件暴露（方便项目导入）=====================
  s.public_header_files = "GGAlicomGraphicAuthenticationSDK/Classes/**/*"
end
