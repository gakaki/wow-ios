Pod::Spec.new do |s|

  s.name         = "PonyFrameworkOnSwift"
  s.version      = "0.0.2"
  s.summary      = "王云鹏的PonyFrameworkOnSwift"
  s.description  = s.summary
  s.homepage     = "https://github.com/MakeBetterMe/PonyFrameworkOnSwift"
  s.license      = "MIT"


  s.author             = { "ponycoder" => "571533442@qq.com" }


  s.source       = { :git => "https://github.com/MakeBetterMe/PonyFrameworkOnSwift.git", :tag => "0.0.1" }


  s.source_files  = "PonyFrameworkOnSwift/**/*.swift"
  s.exclude_files = "PonyFrameworkOnSwift/**/*.{png,xib,storyboard}"


end
