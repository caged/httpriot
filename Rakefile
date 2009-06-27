# requires osx/plist `sudo gem install osx-plist`
require 'rubygems'
require 'rake/packagetask'
require 'osx/plist'


# HTTPRIOT_ROOT = File.expand_path(File.dirname(__FILE__))
# HTTPRIOT_PLIST = File.join(HTTPRIOT_ROOT, 'Info.plist')

desc 'Run Clang'
task :analyze do
  FileUtils.rm_r(Project.build_dir)
  system("scan-build -k -V xcodebuild -target libhttpriot -configuration #{Project.active_config} -sdk iphonesimulator3.0")
end

namespace :osx do
  desc 'Run Unit Tests'
  task :test do
    system("xcodebuild -target TestRunner -configuration #{Project.active_config}")
    system("open #{File.join(Project.product_dir, 'TestRunner')}.app")
  end
end

namespace :iphone do
  desc 'Build 2.0 - 3.0 Release Versions of the static library for the simulator and device'
  task :build_all => :clean_all do
    %w(2.0 2.1 2.2 2.2.1 3.0).each do |version|
      system("xcodebuild -target libhttpriot -configuration Release -sdk iphonesimulator#{version}")
      system("xcodebuild -target libhttpriot -configuration Release -sdk iphoneos#{version}")
    end
  end
  
  desc 'Clean all targets'
  task :clean_all do
    system("xcodebuild clean -alltargets")
  end
  
  # TODO Find out how to run a program on the Simulator programtically
  desc 'Run iPhone Unit Tests'
  task :test do
    system("xcodebuild -target iPhoneUnitTestsRunner -configuration #{Project.active_config}")
    system("open #{File.join("#{Project.product_dir}-iphonesimulator", 'iPhoneUnitTestsRunner')}.app")
  end
end

namespace :sdk do  
  desc 'Build and package all SDKs' 
  task :package_all => ['iphone:build_all', 'sdk:package']
  
  desc 'Generate the documentation'
  task :doc do
    system("xcodebuild -target Documentation -configuration Release -sdk macosx10.5")
  end
  
  desc 'Install the SDK in ~/Library/SDks'
  task :install => ['sdk:repackage'] do
    cd Project.project_dir
    sdk = Dir.entries('pkg').detect {|e| e =~ /[^\.|\.\.|zip|tgz|tar|gz]$/i}

    sdk_base_dir = File.join(File.expand_path("~"), 'Library', 'SDKs')
    sdk_install_location = File.join(sdk_base_dir, sdk)

    mkdir(sdk_base_dir) unless File.exists?(sdk_base_dir)
    rm_r(sdk_install_location) if File.exists?(sdk_install_location)
    cd 'pkg'
    mv sdk, sdk_install_location
  end
end

task :default => "osx:test"

class SDKSettings
  def initialize(name, version, sdk, target)
    @name = name
    @version = version
    @sdk = sdk
    @target = target
  end
  
  def iphone?
    @sdk == 'iphoneos'
  end
  
  def simulator?
    @sdk == 'iphonesimulator'
  end
  
  def minimal_display_name
    iphone? ? 'Device' : 'Simulator'
  end
  
  def display_name
    iphone? ? "Device - iPhone OS #{@target}" : "Simulator - iPhone OS #{@target}"
  end
  
  def alternate_sdk
    "#{@name}#{@sdk}#{@version}"
  end
  
  def default_properties
    if iphone?
      {
        "CODE_SIGN_ENTITLEMENTS"        => "",
        "DEAD_CODE_STRIPPING"           => "YES",
        "ENTITLEMENTS_REQUIRED"         => "YES",
        "CODE_SIGN_RESOURCE_RULES_PATH" => "$(SDKROOT)/ResourceRules.plist",
        "AD_HOC_CODE_SIGNING_ALLOWED"   => "NO",
        "PLATFORM_NAME"                 => "iphoneos",
        "MACOSX_DEPLOYMENT_TARGET"      => "10.5",
        "GCC_THUMB_SUPPORT"             => "YES",
        "IPHONEOS_DEPLOYMENT_TARGET"    => @target
      }
     else
       {
         "GCC_PRODUCT_TYPE_PREPROCESSOR_DEFINITIONS" => " __IPHONE_OS_VERSION_MIN_REQUIRED=20000",
         "PLATFORM_NAME"                             => "iphonesimulator",
         "MACOSX_DEPLOYMENT_TARGET"                  => "10.5"
       }
     end
  end
  
  def to_plist
    {
      "MinimalDisplayName"            => minimal_display_name,
      "Version"                       => @target,
      "FamilyIdentifier"              => "iphoneos",
      "DisplayName"                   => display_name,
      "MaximumOSDeploymentTarget"     => "10.5",
      "AlternateSDK"                  => alternate_sdk,
      "MinimumSupportedToolsVersion"  => "3.1",
      "CustomProperties"              => {},
      "FamilyName"                    => "iPhone OS",
      "IsBaseSDK"                     => "NO",
      "DefaultProperties"             => default_properties,
      "CanonicalName"                 => alternate_sdk
    }.to_plist
  end
end

class Project
  
  def self.out
    @out ||= %x[xcodebuild -list]
  end
  
  def self.active_config
    config = 'Debug'
    out.each_line do |line|
      config = 'Release' if line.include?('Release (Active)')
    end
    config
  end
  
  def self.active_product
    proj = ''
    out.scan(/(.+?)\s\(Active\)/) do |m|
      proj = m[0].strip unless %w(Debug Release).include?(m[0].strip)
    end
    File.join(product_dir, proj)
  end
  
  def self.project_dir
    File.dirname(__FILE__)
  end
  
  def self.build_dir
    File.join(project_dir, 'build')
  end
  
  def self.product_dir
    File.join(build_dir, active_config)
  end
  
  def self.plist
    File.join(project_dir, 'Info.plist')
  end
  
  def self.targets
    %w(2.0 2.1 2.2 2.2.1 3.0)
  end
end


class SDKPackage < Rake::PackageTask
  
  # Project root directory unless provided
  attr_accessor :product_name
  
  # Build products dir.  Uses `build` by default
  attr_accessor :build_dir
  
  # Debug, Release, etc.  Release by default
  attr_accessor :configuration
  
  # Deployment target (2.0, 2.1, 2.2, 2.2.1, 3.0).  Contains all by default.
  attr_accessor :target
  
  # SDKs to package.  iphonesimulator, iphoneos by default
  attr_accessor :sdks
  
  def initialize(name = nil, version = nil)
    init(name, version)
    yield self if block_given?
    generate_tasks
  end
  
  def init(name, version)
    super
    @properties = OSX::PropertyList.load(File.read(Project.plist), format = false)
    @product_name = File.basename(Project.project_dir)
    @name = name || @product_name.downcase.gsub(/\s*/, '')
    @version = version || @properties['CFBundleVersion']
    @project_dir = Project.project_dir
    @package_dir = File.join(@project_dir, 'pkg')
    @build_dir = Project.build_dir
    @relative_user_dir = "usr/local"
    @sdks = %w(iphoneos iphonesimulator)
    @configuration = 'Release'
    @targets = Project.targets
  end
  
  def generate_tasks
    namespace :sdk do
    
      desc 'Build the iPhoneOS and iPhoneSimulator SDK package'
      task :package do
        package_root = File.join(package_dir, package_name)
        mkdir_p package_root
        cd package_root
        @targets.each do |target|
          @sdks.each do |sdk|
            # Create the SDK dir
            cd package_root
            sdk_dir = "#{sdk}#{target}.sdk"
            mkdir sdk_dir
          
          
            # Create the SDKSettings.plist file
            cd sdk_dir
            sdk_properties = SDKSettings.new(name, version, sdk, target).to_plist
            File.open(File.join(pwd, 'SDKSettings.plist'), 'w+') do |f|
              f << sdk_properties
            end
          
            # Copy the header files over
            built_sdk_dir = File.join(@build_dir, "#{@configuration}-#{sdk}#{target}")
            cp_r File.join(built_sdk_dir, "usr"), "./"
          
            # Create the lib directory and copy over the static library
            lib_dir = File.join(pwd, 'usr', 'local', 'lib')
            mkdir lib_dir
            cd lib_dir
            # assume product name is lib${NAME}.a
            cp File.join(built_sdk_dir, "lib#{name}.a"), './'
          end
        end
        
        # Move the framework over
        package_root = File.join(package_dir, package_name)
        cd package_root
        framework = Dir["#{File.join(@build_dir, @configuration)}/*.framework"].first
        cp_r(framework, './') if framework
        
        [
          [need_tar, tgz_file, "z"],
          [need_tar_gz, tar_gz_file, "z"],
          [need_tar_bz2, tar_bz2_file, "j"]
        ].each do |need_tar, file, flag|
          if need_tar
            cd package_dir do
              sh %{#{@tar_command} #{flag}cvf #{file} #{package_name}}
            end
          end
        end
        
        if need_zip
          cd package_dir do
            sh %{#{@zip_command} -r #{zip_file} #{package_name}}
          end
        end
      end
    
      desc 'Clean the package directory'
      task :clean do
        rm_r package_dir
      end
      
      desc 'Clean and package again'
      task :repackage => [:clean, :package]
    end
  end
end

SDKPackage.new do |sdk|
  sdk.need_tar_gz = true
  sdk.need_zip = true
end