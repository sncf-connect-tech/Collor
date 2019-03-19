Pod::Spec.new do |s|
  s.name             = 'Collor'
  s.version          = '1.1.30'
  s.summary          = 'A MVVM data-oriented framework for UICollectionView.'
  s.homepage         = 'https://github.com/voyages-sncf-technologies/Collor'
  s.screenshots      = 'https://raw.githubusercontent.com/voyages-sncf-technologies/Collor/master/resources/screenshot.jpg'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Gwenn Guihal' => 'gguihal@oui.sncf' }
  s.source           = { :git => 'https://github.com/voyages-sncf-technologies/Collor.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_myrddin_'
  s.ios.deployment_target = '10.0'
  s.source_files = 'Collor/Classes/**/*'
  s.swift_version = '4.2'
end
