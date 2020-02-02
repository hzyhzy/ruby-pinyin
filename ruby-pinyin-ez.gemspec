$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ruby-pinyin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ruby-pinyin-ez"
  s.version     = PinYin::VERSION
  s.authors     = ["hzyhzy"]
  s.email       = ["18670314023@163.com"]
  s.homepage    = "https://github.com/hzyhzy/ruby-pinyin"
  s.summary     = "Convert Chinese characters into pinyin."
  s.description = "Pinyin is a romanization system (phonemic notation) of Chinese characters, this gem helps you to convert Chinese characters into pinyin form."
  s.license     = 'BSD'

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "README.markdown"]

  s.add_runtime_dependency('rmmseg-cpp-new', ['~> 0.3.1'])
  s.add_development_dependency('minitest', ['~> 5.4'])
end
