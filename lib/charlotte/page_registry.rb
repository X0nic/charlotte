class PageRegistry
  NOT_FETCHED = :not_fetched
  FETCHED     = :fetched

  def initialize
    @registry = { }
    @assets = []
  end

  def add(page)
    add_links(page.links)
    add_assets(page.assets)
  end

  def assets
    @assets
  end

  def links
    registry
  end

  def links_to_fetch
    registry.reject{|k,v| v == PageRegistry::FETCHED}.keys
  end

  def uri_fetched(uri)
    registry[uri] = PageRegistry::FETCHED
  end

  def to_s
    registry.map{|k,v| "#{k} - #{v}\n"}
  end

  def stats
    {
      :unfetched => links_to_fetch.count,
      :assets => assets.count,
      :total => links.count
    }
  end

  private
  def add_assets(assets_to_add)
    (assets << assets_to_add).flatten!.uniq!
  end

  def add_links(uris)
    uris_to_add = clean_uris(uris)
    uris_to_add.each do |uri|
      registry[uri] = PageRegistry::NOT_FETCHED
    end
  end

  def registry
    @registry
  end

  def clean_uris(uris)
    # TODO: Clean this up, and test it. It won't catch everything properly.
    uris.reject{|uri| registry.has_key?(uri)}.reject{|uri| uri.match /:/}.reject{|uri| uri.match /#/}
  end
end
