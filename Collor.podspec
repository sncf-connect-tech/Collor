Pod::Spec.new do |s|
  s.name             = 'Collor'
  s.version          = '1.1.41'
  s.summary          = 'A declarative data-oriented framework for UICollectionView.'
  s.homepage         = 'https://github.com/sncf-connect-tech/Collor'
  s.screenshots      = 'https://raw.githubusercontent.com/sncf-connect-tech/Collor/master/resources/screenshot.jpg'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Gwenn Guihal' => 'gguihal@oui.sncf' }
  s.source           = { :git => 'https://github.com/sncf-connect-tech/Collor.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gwennguihal'
  s.ios.deployment_target = '10.0'
  s.source_files = 'Collor/Classes/**/*'
  s.swift_versions = ['5.1', '5.2']
end
