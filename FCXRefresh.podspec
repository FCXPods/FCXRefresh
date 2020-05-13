
Pod::Spec.new do |s|
  s.name         = "FCXRefresh"
  s.version      = "0.1.6"
  s.summary      = "An easy way to use pull-to-refresh and loading-more"
  s.homepage     = "https://github.com/FCXPods/FCXRefresh"
  s.license      = "MIT"
  s.author             = { "fengchuanxiang" => "fengchuanxiang@126.com" }
  s.platform     = :ios,'6.0'
  s.source       = { :git => "https://github.com/FCXPods/FCXRefresh.git", :tag => s.version }
  s.source_files  = "FCXRefresh/*.{h,m}"
  s.resources = "FCXRefresh/*.png"
  s.requires_arc = true
end