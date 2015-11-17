module Charlotte
  module Version

    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = 0

    def self.patch
      [MAJOR, MINOR, PATCH].compact.join('.')
    end

    def self.minor
      [MAJOR, MINOR].compact.join('.')
    end

    def self.to_s
      [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
    end

  end
end
