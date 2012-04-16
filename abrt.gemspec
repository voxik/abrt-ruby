# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "abrt"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vít Ondruch"]
  s.email = "v.ondruch@tiscali.cz"
  s.date = "2012-04-12"
  s.summary = "ABRT support for Ruby MRI."
  s.description = "Provides ABRT reporting support for applications written using Ruby."
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "lib/abrt.rb",
    "spec/abrt_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/voxik/abrt-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
  end
end

