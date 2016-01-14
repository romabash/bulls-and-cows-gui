# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "kbgui"
  spec.version       = '1.0'
  spec.authors       = ["Roma"]
  spec.email         = [""]
  spec.summary       = %q{Logic number game}
  spec.description   = %q{Bulls and Cows: Logic number game gui}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = ['lib/kbgui.rb', 'lib/users.txt', 'lib/one.json', 'lib/two.json', 'lib/three.json', 
	                      'lib/four.json', 'lib/five.json', 'lib/six.json', 'lib/seven.json', 'lib/eight.json', 
												'lib/nine.json', 'lib/ten.json',
	                      'lib/kbgui/kbmodule.rb', 'lib/kbgui/kbgame.rb', 'lib/kbgui/kbquick_game.rb']
  spec.executables   << 'kbgui'
  spec.require_paths = ["lib"]
end
