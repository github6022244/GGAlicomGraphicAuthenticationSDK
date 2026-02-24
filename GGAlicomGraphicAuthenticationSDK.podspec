Pod::Spec.new do |s|
  # ===================== 基础信息（必填，按需修改）=====================
  s.name         = "GGAlicomGraphicAuthenticationSDK"
  s.version      = "0.1.0"
  s.summary      = "阿里云验证码保护 SDK（AlicomCaptcha4）- 静态框架版"
  s.description  = <<-DESC
                    阿里云验证码保护 SDK，支持滑块/点选验证，适配 iOS 9.0+，
                    包含 framework 核心库和 bundle 资源包，已配置 -ObjC 链接参数。
                   DESC
  s.homepage     = "https://help.aliyun.com/document_detail/2189838.html" # 官方文档地址
  s.license      = {
    :type => "MIT",  # 对应你 Git 仓库的 MIT 协议
    :text => <<-LICENSE
      Copyright (c) [年份] [你的名字/团队名]
      
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
  s.platform     = :ios, "13.0"            # 阿里云 SDK 最低支持 iOS 9.0
  s.requires_arc = true                   # 开启 ARC（SDK 基于 ARC 开发）
  s.static_framework = true               # 关键：阿里云该 SDK 是静态框架，必须声明

  # ===================== 源码/资源路径（核心，严格匹配目录）=====================
  # 本地调试用路径（发布到私有库后替换为 git 地址）
  s.source       = { :git => "https://github.com/github6022244/GGAlicomGraphicAuthenticationSDK.git", :tag => s.version.to_s } # 私有库地址后续补充
  # 若本地调试，直接用路径引用：
  # s.source = { :path => "." }

  # 1. 引入阿里云静态 framework（替代手动拖拽到 Linked Frameworks）
  s.vendored_frameworks = "Assets/AlicomCaptcha4.framework"

  # 2. 引入 bundle 资源包（官方强制要求，否则验证界面无样式）
  # 用 resource_bundles 避免资源冲突，且保证 bundle 被正确打包
  s.resource_bundles = {
    "AlicomCaptcha4Resources" => ["Assets/AlicomCaptcha4.bundle/**/*"]
  }

  # ===================== 编译配置（覆盖官方所有要求）=====================
  # 1. 添加 -ObjC 解决 Category 调用问题（官方明确要求）
  s.xcconfig = {
    "OTHER_LDFLAGS" => "-ObjC",          # 核心：对应官方要求的 Other Linker Flags
    "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/#{s.name}/Assets", # 确保 framework 能被找到
    "RESOURCE_SEARCH_PATHS" => "$(PODS_ROOT)/#{s.name}/Assets"    # 确保 bundle 能被找到
  }

  # 2. SDK 依赖的系统框架（阿里云官方 SDK 必依赖，无需额外添加）
  s.frameworks = "UIKit", "Foundation", "Security", "WebKit", "CoreGraphics", "AVFoundation"

  # 3. 可选：若 SDK 依赖 libz 等系统库（部分版本需要，实测 4.0+ 需添加）
  s.libraries = "z", "c++"

  # ===================== 头文件暴露（方便项目导入）=====================
  s.public_header_files = "Assets/AlicomCaptcha4.framework/Headers/*.h"
  # s.private_header_files = "Assets/AlicomCaptcha4.framework/Headers/Private/*.h" # 若有私有头文件
end
