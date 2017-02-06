if Rails.application.config.assets.compile == false
  React::ServerRendering::SprocketsRenderer.asset_container_class = YamlManifestContainer
end