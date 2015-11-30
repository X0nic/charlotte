class PageRegistry
  class NotRegisteredError < StandardError; end

  NOT_FETCHED = :not_fetched
  FETCHED     = :fetched

  ROOT_URL    = "/"

  attr_reader :assets

  def initialize
    @registry = {}
    @assets = []

    add_links([ROOT_URL])
  end

  def add(page)
    add_links(page.links)
    add_assets(page.assets)
  end

  def add_set(page_set)
    page_set.pages.each { |page| add(page) }
  end

  def links
    registry
  end

  def links_to_fetch
    registry.reject { |_k, v| v == PageRegistry::FETCHED }.keys
  end

  def uri_fetched(uri)
    return registry[uri] = PageRegistry::FETCHED if registry.key?(uri)
    fail NotRegisteredError, "Don't know about this url, can not mark it as fetched."
  end

  def uris_fetched(uris)
    uris.each{ |uri| uri_fetched(uri) }
  end

  def to_s
    registry.map { |k, v| "#{k} - #{v}\n" }
  end

  def stats
    {
      total_assets: assets.count,
      total_links: links.count,
      unfetched_links: links_to_fetch.count
    }
  end

  private

  def add_assets(assets_to_add)
    (assets << assets_to_add).flatten!.uniq!
  end

  def add_links(uris)
    uris_to_add = clean_uris(uris)
    uris_to_add.each do |uri|
      registry[uri] = PageRegistry::NOT_FETCHED unless registry.key?(uri)
    end
  end

  attr_reader :registry

  def clean_uris(uris)
    # TODO: Clean this up, and test it. It won't catch everything properly.
    uris.reject { |uri| uri.match(/:/) }.reject { |uri| uri.match(/#/) }
  end
end
