Pod::Spec.new do |s|

  s.name         = "MarxKit"
  s.version      = "0.0.1"
  s.summary      = "Because debugging is Capital."

  s.description  = <<-DESC
  		   MarxKit is a framework aiming to ease yours testers' work
		   by adding in-app console, supporting external display and
		   offering a way to update parameters in real time.
                   DESC

  s.homepage     = "https://github.com/teriiehina/MarxKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Alejo Berman" => "aberman@gmail.com" , "Jérémie Godom" => "psg75@gmail.com" , "Peter Meuel" => "peter@teriiehina.net"}
  
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/teriiehina/MarxKit.git", :tag => "0.0.1" }

  s.source_files  = 'MarxKit/**/*.{h,m}'
  s.resources = "MarxKit/**/*.{png,xib}"

  s.requires_arc = true

end
