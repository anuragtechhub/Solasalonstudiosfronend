class YamlManifestContainer
  def initialize
    data = YAML.load_file(Rails.root.join("public/assets/manifest.yml"))

    @manifest = OpenStruct.new(
      assets: data,
      dir:    'assets'
    )
  end

  def find_asset(logical_path)
    asset_path = @manifest.assets[logical_path] || raise("No compiled asset for #{logical_path}, was it precompiled?")
    asset_full_path = ::Rails.root.join("public", @manifest.dir, asset_path)
    File.read(asset_full_path)
  end
end