ROOT = __dir__

PROJECT = "#{ROOT}/Rail Line.xcodeproj".freeze
SCHEME  = 'Rail Line'.freeze

namespace :ios do
  # regenerate the app icons from logo.svg. imagemagick's built-in svg renderer
  # can't handle logo.svg's stroke-only, css-styled paths (it renders blank), so
  # the glyph is rasterized with librsvg (rsvg-convert) and composited by
  # imagemagick. install both with `brew install imagemagick librsvg`.
  desc 'regenerate the iOS app icons from logo.svg (needs imagemagick + librsvg)'
  task :icons do
    require 'json'
    require 'tmpdir'

    source  = "#{ROOT}/logo.svg"
    iconset = "#{ROOT}/Rail Line/Assets.xcassets/AppIcon.appiconset"
    abort "missing #{source}" unless File.exist?(source)

    svg = File.read(source)

    # ios rejects icons with an alpha channel, so every variant is flattened onto
    # an opaque fill. the glyph is recolored per appearance by swapping the svg
    # stroke color (Colors.swift's cyan / fadedCyan), then centered on the 1024
    # canvas at 80% to leave 10% padding. [glyph stroke, background]
    variants = {
      'logo.png'        => ['#00bbbb', '#ffffff'], # light:  cyan glyph on white
      'logo-dark.png'   => ['#25c8c9', '#1c1c1e'], # dark:   faded cyan on near-black
      'logo-tinted.png' => ['#ffffff', '#000000']  # tinted: white glyph, ios applies the user's tint
    }

    Dir.mktmpdir do |tmp|
      variants.each do |name, (stroke, bg)|
        # swap the source stroke color so the rasterized glyph is the target
        # color instead of the original near-black.
        recolored = "#{tmp}/#{name}.svg"
        File.write(recolored, svg.gsub('#020202', stroke))

        # rasterize the glyph transparent at 80% (819/1024) with librsvg, then
        # center it on an opaque fill and strip the alpha channel ios forbids.
        glyph = "#{tmp}/#{name}"
        sh 'rsvg-convert', '-w', '819', '-h', '819', recolored, '-o', glyph
        sh 'magick', glyph, '-gravity', 'center', '-background', bg,
           '-extent', '1024x1024', '-flatten', '-alpha', 'off',
           '-depth', '8', '-strip', "PNG24:#{iconset}/#{name}"
      end
    end

    # single-size (1024) icon with the three ios appearances pointing at the
    # generated files. replaces the legacy per-size icon set.
    single = ->(extra) { { 'idiom' => 'universal', 'platform' => 'ios', 'size' => '1024x1024' }.merge(extra) }
    contents = {
      'images' => [
        single.call('filename' => 'logo.png'),
        single.call('appearances' => [{ 'appearance' => 'luminosity', 'value' => 'dark' }], 'filename' => 'logo-dark.png'),
        single.call('appearances' => [{ 'appearance' => 'luminosity', 'value' => 'tinted' }], 'filename' => 'logo-tinted.png')
      ],
      'info' => { 'author' => 'xcode', 'version' => 1 }
    }
    File.write("#{iconset}/Contents.json", "#{JSON.pretty_generate(contents)}\n")

    puts "regenerated app icons in #{iconset}"
  end

  desc 'build the iOS app for the simulator'
  task :build do
    sh "xcodebuild -project '#{PROJECT}' " \
       "-scheme '#{SCHEME}' " \
       "-destination 'generic/platform=iOS Simulator' " \
       '-configuration Debug ' \
       'build'
  end

  # archive the app and upload it to testflight (internal testers). runs on the
  # host, not in a container (no xcode in the build image).
  #
  # requires an app store connect api key. generate one at
  # appstoreconnect.apple.com -> users and access -> integrations -> app store
  # connect api, drop the .p8 at
  # ~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8, and export the ids:
  #   ASC_KEY_ID=... ASC_ISSUER_ID=... rake ios:testflight
  desc 'archive the iOS app and upload to testflight (internal testers)'
  task :testflight do
    key_id    = ENV['ASC_KEY_ID'].to_s
    issuer_id = ENV['ASC_ISSUER_ID'].to_s
    abort 'set ASC_KEY_ID and ASC_ISSUER_ID in the environment first' if key_id.empty? || issuer_id.empty?

    archive = "#{ROOT}/build/Rail Line.xcarchive"
    export  = "#{ROOT}/build/export"
    opts    = "#{ROOT}/ExportOptions.plist"

    # unlock the login keychain so codesign can read the signing key
    # (otherwise the archive fails with errSecInternalComponent)
    require 'io/console'
    pw = $stdin.getpass('login keychain password: ')
    sh 'security', 'unlock-keychain', '-p', pw,
       "#{Dir.home}/Library/Keychains/login.keychain-db", verbose: false

    # derive a fresh build number from the unix timestamp so testflight accepts
    # a new upload. passed as a build-setting override so the pbxproj is never
    # mutated (no git diff), and unique per run even between commits.
    build_no = Time.now.to_i

    sh 'xcodebuild archive ' \
       "-project '#{PROJECT}' " \
       "-scheme '#{SCHEME}' -configuration Release " \
       "-destination 'generic/platform=iOS' " \
       "-archivePath '#{archive}' " \
       "CURRENT_PROJECT_VERSION=#{build_no} " \
       '-allowProvisioningUpdates'

    sh 'xcodebuild -exportArchive ' \
       "-archivePath '#{archive}' " \
       "-exportPath '#{export}' " \
       "-exportOptionsPlist '#{opts}' " \
       '-allowProvisioningUpdates'

    sh "xcrun altool --upload-app -f '#{export}/Rail Line.ipa' --type ios " \
       "--apiKey #{key_id} --apiIssuer #{issuer_id}"
  end
end
