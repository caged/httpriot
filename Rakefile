# requires osx/plist `sudo gem install 
require 'rubygems'
require 'rake/packagetask'
require 'osx/plist'


HTTPRIOT_ROOT = File.expand_path(File.dirname(__FILE__))
HTTPRIOT_PLIST = File.join(HTTPRIOT_ROOT, 'Info.plist')

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


class SDKPackage < Rake::PackageTask
  
  # Project root directory unless provided
  attr_accessor :product_name
  
  # Build products dir.  Uses `build` by default
  attr_accessor :build_dir
  
  # Debug, Release, etc.  Release by default
  attr_accessor :configuration
  
  # Deployment target (2.0, 2.1, 2.2).  2.2 by default
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
    @properties = OSX::PropertyList.load(File.read(HTTPRIOT_PLIST), format = false)
    @product_name = File.basename(HTTPRIOT_ROOT)
    @name = name || @product_name.downcase.gsub(/\s*/, '')
    @version = version || @properties['CFBundleVersion']
    @project_dir = File.dirname(__FILE__)
    @package_dir = File.join(@project_dir, 'pkg')
    @build_dir = File.join(@project_dir, 'build')
    @relative_user_dir = "usr/local"
    @sdks = %w(iphoneos iphonesimulator)
    @configuration = 'Release'
    @target = "2.2"
  end
  
  def generate_tasks
    namespace :sdk do
    
      desc 'Build the iPhoneOS and iPhoneSimulator SDK package'
      task :package do
        package_root = File.join(package_dir, package_name)
        mkdir_p package_root
        cd package_root
        @sdks.each do |sdk|
          # Create the SDK dir
          cd package_root
          sdk_dir = "#{sdk}.sdk"
          mkdir sdk_dir
          
          
          # Create the SDKSettings.plist file
          cd sdk_dir
          sdk_properties = SDKSettings.new(name, version, sdk, target).to_plist
          File.open(File.join(pwd, 'SDKSettings.plist'), 'w+') do |f|
            f << sdk_properties
          end
          
          # Copy the header files over
          built_sdk_dir = File.join(@build_dir, "#{@configuration}-#{sdk}")
          cp_r File.join(built_sdk_dir, "usr"), "./"
          
          # Create the lib directory and copy over the static library
          lib_dir = File.join(pwd, 'usr', 'local', 'lib')
          mkdir lib_dir
          cd lib_dir
          # assume product name is lib${NAME}.a
          cp File.join(built_sdk_dir, "lib#{name}.a"), './'
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
          chdir(package_dir) do
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
  sdk.package_dir = HTTPRIOT_PKG_DIR
  sdk.need_tar_gz = true
  sdk.need_tar = true
  sdk.need_tar_bz2 = true
  sdk.need_zip = true
end