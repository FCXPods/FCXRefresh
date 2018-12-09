
Pod::Spec.new do |s|
  s.name         = "FCXRefresh"
  s.version      = "0.1.3"
  s.summary      = "上下拉刷新."
  s.description  = <<-DESC
		提供简便的上下拉刷新，支持自定义，只需简单的两三行代码即可.
                   DESC
  s.homepage     = "https://github.com/FCXPods/FCXRefresh"
  s.license      = "MIT"
  s.author             = { "fengchuanxiang" => "fengchuanxiang@126.com" }
  s.platform     = :ios,'6.0'
  s.source       = { :git => "https://github.com/FCXPods/FCXRefresh.git", :tag => s.version }
  s.source_files  = "FCXRefresh/"
  s.resources = "FCXRefresh/*.png"
  s.requires_arc = true
end