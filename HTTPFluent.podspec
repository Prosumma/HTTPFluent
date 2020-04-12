Pod::Spec.new do |s|
  repo = 'https://github.com/prosumma/HTTPFluent'
  version = '1.0'

  s.name = 'HTTPFluent'
  s.version = version
  s.summary = 'A fluent interface over HTTP'
  s.description = <<-DESC
  A fluent inteface over HTTP, suitable especially for conversing with APIs.
  DESC
  s.homepage = repo
  s.license = 'MIT'
  s.author = { 'Gregory Higley' => 'code@revolucent.net' }
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.12'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '10.0'
  s.source = { git: "#{repo}.git", tag: "v#{version}" }
  s.source_files = "Sources/HTTPFluent"
  s.swift_versions = ['5.0', '5.1', '5.2'] 
end
