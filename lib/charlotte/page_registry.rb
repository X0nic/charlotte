class PageRegistry
  NOT_FETCHED = :not_fetched
  FETCHED     = :fetched

  def initialize
    @registry = {
      "/" => PageRegistry::FETCHED
    }
  end

  def add_links(uris)
    uris_to_add = clean_uris(uris)
    uris_to_add.each do |uri|
      registry[uri] = PageRegistry::NOT_FETCHED
    end
  end

  def links
    registry
  end

  def to_s
    registry.map{|k,v| "#{k} - #{v}\n"}
  end

  private
  def registry
    @registry
  end

  def clean_uris(uris)
    # TODO: Clean this up, and test it. It won't catch everything properly.
    uris.reject{|uri| registry.has_key?(uri)}.reject{|uri| uri.match /:/}.reject{|uri| uri.match /#/}
  end
end
